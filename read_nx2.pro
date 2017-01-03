;+
; PROJECT:
;	NX_2
; NAME:
;	read_nx2
;
; PURPOSE:
;	read the NX2 data in the form of csv tables in IDL structures
;
; CATEGORY:
;	mixed
;
; CALLING SEQUENCE:
;	RESULT=read_nx2(filename,day,verbose=verbose,corr_bsp=corr_bsp)
;
; INPUTS:
;	filename: filename of csv file in csv/ subdirectory
;	day:	  day of month (e.g. 23 for 23-july-2006)
;       month     integer
;       year
;       originlat latitude   (Regenbsurg:49.0164)
;       originlon and longitude to set as [0,0] in m scale (Regensburg:12.0285)
;
; OPTIONAL INPUTS:
;	corr_bsp: Log correction factor to be used, needs to be determined from the data.
;       rowfile:  csv file with rowing data
;       stromfile:.sav file with Schwaller data
;       heelfile: csv file with heel data
;
; KEYWORDS:
;	verbose:  switch on additional output from the read_ascii processes
;
; ADDITIONAL FILES REQUIRED:
;        ascii_templates in IDLtemplate.sav
;
; RESULT:
;	a data structure containing all the data from the NX2 files
;
; EXAMPLE:
;	result=read_nx2()
;
; TEST STATUS:
;	tested
;
; MODIFICATION HISTORY:
;	Written by:	Moritz G�nther 02.08.2006
;       ver 2:  changed required data files (Ruderschlage, neigung, stromgeschwindigkeit) to keywords
;               clarified structure, added origin input, filename need now full path (incl "CSV/") 
;               added month, year, input  MG 16.04.2008
;-

function read_nx2,filename,day,month,year,originlat,originlon, verbose=verbose, corr_bsp=corr_bsp, rowfile=rowfile, stromfile=stromfile, heelfile=heelfile

mps2knots=0.51444

print,'M. Guenther & A. Wawrzyn'
print,'Reading NX2 data in IDL structures and prepare for analysis'

;--- read in files---
restore,'IDLtemplate.sav'
data=read_ascii(filename,template=template,verbose=verbose,header=header)
;---treat time and save in different forms
timecolumn=julday(month,day,year,2)+data.time/(24.*60.*60.)
zeit=jul2time(timecolumn)

;--- add all required new tags to data structure
n_data=n_elements(data.lat)
emptyarr=make_array(n_data,val=-1000.)
emptyarrint=make_array(n_data,val=-1000)
output=create_struct('loc_time',timecolumn,'zeit',zeit, data, 'header',header, 'sailing',emptyarr, 'rowpermin',emptyarr, 'x',emptyarr, 'y',emptyarr, 'stromwo',emptyarr, 'stromsn',emptyarr, 'vx_wassys',make_array(n_data), 'vy_wassys',make_array(n_data), 'heel',emptyarr, 'par2keel',emptyarrint)




;---transform LAT and LON in x,y set origin at stating location
r_earth=6300e3	;in Si unit - meter
output.y=2.*!pi*r_earth/360.*(output.lat-originlat)
output.x=2.*!pi*r_earth*cos(output.lat/180*!pi)/360.*(output.lon-originlon)
;apply BSP correction factor if given
if n_elements(corr_bsp) eq 1 then output.bsp=output.bsp*corr_bsp else message,'WARNING: BSP not corrected!',/cont


;---read rowing information from rowingfile
if n_elements(rowfile) eq 1 then begin
  print,'Reading data for rowing'
  rowdata=read_ascii(rowfile,template=rowtemplate,verbose=verbose,header=rowheader)
  counter=0
  for i=0,n_elements(rowdata.m)-1 do begin
    if (rowdata.h[i] ge 0 and rowdata.m[i] ge 0 and rowdata.day[i] ge 0) then begin 	;Messwerte mit Problemen sind negativ geflagt. Die werden hier aussortiert.
      timeindex=wann(output.zeit,rowdata.h[i],rowdata.m[i],day=rowdata.day[i])
      if timeindex[0] ge 0 then begin				;timeindex negativ flagged Zuordnungschwierigkeiten
        output.rowpermin[timeindex]=rowdata.counts[i]
        output.sailing[timeindex]=rowdata.sailing[i]
        counter++
      endif  
    endif
  endfor
  print,' Es konnten ',string(counter),' Minuten Ruder und Segeldaten zugeordnet werden'
endif  ; read row data

;---lese Kr�ngung und Stampinformation aus neigung.csv
if n_elements(heelfile) eq 1 then begin
  print,'Reading data for heeling'
  heeldata=read_ascii(heelfile,template=heeltemplate,verbose=verbose,header=heelheader)
  counter=0
  for i=0,n_elements(heeldata.m)-1 do begin
    if (heeldata.h[i] ge 0 and heeldata.m[i] ge 0 and heeldata.day[i] ge 0) then begin 	;Messwerte mit Problemen sind negativ geflagt. Die werden hier aussortiert.
      timeindex=wann(zeit,heeldata.h[i],heeldata.m[i],heeldata.s[i]+[0.,+1.5],day=heeldata.day[i])
      if timeindex[0] ge 0 then begin				;timeindex negativ flagged Zuordnungschwierigkeiten
        output.heel[timeindex[0]]=heeldata.angle[i]
        output.par2keel[timeindex[0]]=heeldata.par2keel[i]
        counter++
      endif 
    endif
  endfor
  print,' Es konnten ',string(counter),' Kr�ngungsdatenpunkte zugeordnet werden.'
end  ; read heel data

;--- read stream velocity from Dr. Schwaller data
if n_elements(stromfile) eq 1 then begin
  restore,stromfile
  ; velocities read are in m/s, but the data from NX2 is in nautic miles per hour
  ; We use the factor mps2knots to do this conversion

  for i=0,n_elements(timecolumn)-1 do begin
    dist=sqrt((strom.x-x[i])^2.+(strom.y-y[i])^2.)
    test=min(dist,min_index)
    output.stromwo[i]=strom.vx[min_index]/mps2knots
    output.stromsn[i]=strom.vy[min_index]/mps2knots
    if strom.vges[min_index] eq 0 then print,'%read_nx2.pro: Warnung: zugeordnete Str�mungsgeschwindigkeit ist 0 am Punkt',output.x[i],output.y[i]
    ; if test gt 10 then print,'%read_nx2.pro: Warnung: V mehr als 10 m entfernt vom Punkt',x[i],y[i],'Entfernung ',test
    output.vx_wassys[i]=data.sog[i]*sin(data.cog[i]*!pi/180.)-stromwo[i]
    output.vy_wassys[i]=data.sog[i]*cos(data.cog[i]*!pi/180.)-stromsn[i]
  endfor 
endif 

return,output

end

