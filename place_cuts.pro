;+
; NAME:
;       PLACE_CUTS
;
; PURPOSE:
;       This function returns the time indices of the NX_2 data, where some given parameters did not change to much 
;	just before the measurement
;
; CATEGORY:
;       data selection
;
; CALLING SEQUENCE:
;       Result=place_cuts
;
; INPUTS:
;       data:  NX_2 data from read_nx2
;      
; KEYWORD PARAMETERS:
;	This is what makes this function do things. The keywords allow to specify selection criteria.
;	Each keyword is given as array with [value, allowed variation, in time in seconds]
;	e.g. bsp=[2.,0.1,30] requires that the bsp did not deviate by more then 10% in the last 30 seconds from 2.0       
;
; OUTPUTS:
;       index array of meassurement points, which match all conditions
;
; EXAMPLE:
;       result=PLACE_CUTS(data,bsp=[2.,.1,20])
;
; PROGRAMMING NOTES:
;	Routine could be speeded up considerably by giving only values to schnittmenge, which do not contain a full index!
;
; MODIFICATION HISTORY:
;       Written by:    Moritz Guenther, 15.12.2006
;	9. May 2008 added keywords, changed call to Schnittmenge in order to speed up routine
;- 

function place_cuts,data,sailing=sailing, bsp=bsp, awa=awa, aws=aws, tws=tws, hdc=hdc, rowpermin=rowpermin, const_course=const_course, mean_tws=mean_tws,mean_vtws=mean_vtws,mean_aws=mean_aws, index_in=index_in,const_sog=const_sog,const_bsp=const_bsp;,... und einige mehr, wenn die routine erst einmal l�uft

if n_elements(index_in) eq 0 then ind=indgen(n_elements(data.x),/long) else ind=long(index_in)
;ergebnis=indgen(n_elements(ind),/long)

; bsp_result=indgen(n_elements(ind),/long)
; sog_result=indgen(n_elements(ind),/long)
; awa_result=indgen(n_elements(ind),/long)
; sailing_result=indgen(n_elements(ind),/long)
; aws_result=indgen(n_elements(ind),/long)
; tws_result=indgen(n_elements(ind),/long)
; mean_tws_result=indgen(n_elements(ind),/long)
; hdc_result=indgen(n_elements(ind),/long)
; rowpermin_result=indgen(n_elements(ind),/long)
; cog_result=indgen(n_elements(ind),/long)
; constant_sog_result=indgen(n_elements(ind),/long)
; constant_bsp_result=indgen(n_elements(ind),/long)
; constant_course_result=indgen(n_elements(ind),/long)
; mean_vtws_result=indgen(n_elements(ind),/long)



if n_elements(bsp) eq 3 then begin
  bsp_result=long(-1)
  index=where(data.bsp[ind] gt (bsp[0]*(1.-bsp[1])) and data.bsp[ind] lt (bsp[0]*(1.+bsp[1])))
  for i=long(bsp[2]), n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(bsp[2])),index[i-(bsp[2]-1):i]) then bsp_result = bsp_result[0] eq -1 ? index[i] : [bsp_result,index[i]]
  print,'BSP',n_elements(bsp_result)
endif
if n_elements(bsp_result) ne 0 then if bsp_result[0] eq -1 then return,-1 else ind=ind[bsp_result]


if n_elements(sog) eq 3 then begin
  sog_result=long(-1)
  index=where(data.sog[ind] gt (sog[0]*(1.-bsp[1])) and data.sog[ind] lt (bsp[0]*(1.+sog[1])))
  for i=long(sog[2]), n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(sog[2])),index[i-(sog[2]-1):i]) then sog_result = sog_result[0] eq -1 ? index[i] : [sog_result,index[i]]
  print,'SOG',n_elements(sog_result)
endif
if n_elements(sog_result) ne 0 then if sog_result[0] eq -1 then return,-1 else ind=ind[sog_result]


if n_elements(awa) eq 3 then begin
  awa_result=long(-1)
  index=where(data.awa[ind] gt (awa[0]*(1.-awa[1])) and data.awa[ind] lt (awa[0]*(1.+awa[1])))
  for i=long(awa[2]), n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(awa[2])),index[i-(awa[2]-1):i]) then awa_result = awa_result[0] eq -1 ? index[i] : [awa_result,index[i]]
print,'AWA',n_elements(awa_result)
endif
if n_elements(awa_result) ne 0 then if awa_result[0] eq -1 then return,-1 else ind=ind[awa_result]

if n_elements(sailing) eq 3 then begin
  sailing_result=long(-1)
  index=where(data.sailing[ind] eq sailing[0])
  for i=long(sailing[2]), n_elements(index)-2-sailing[2] do if array_equal(reverse(index[i]-indgen(sailing[2])),index[i-(sailing[2]-1):i]) and array_equal(index[i]+indgen(sailing[2]),index[i:i+(sailing[2]-1)]) then sailing_result = sailing_result[0] eq -1 ? index[i] : [sailing_result,index[i]]
  print,'Sailing',n_elements(sailing_result)
endif
if n_elements(sailing_result) ne 0 then if sailing_result[0] eq -1 then return,-1 else ind=ind[sailing_result]

if n_elements(aws) eq 3 then begin
  aws_result=long(-1)
  index=where(data.aws[ind] gt (aws[0]*(1.-aws[1])) and data.aws[ind] lt (aws[0]*(1.+aws[1])))
  for i=long(aws[2]), n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(aws[2])),index[i-(aws[2]-1):i]) then aws_result = aws_result[0] eq -1 ? index[i] : [aws_result,index[i]]
  print,'AWS',n_elements(aws_result)
endif
if n_elements(aws_result) ne 0 then if aws_result[0] eq -1 then return,-1 else ind=ind[aws_result]

if n_elements(tws) eq 3 then begin
  tws_result=long(-1)
  index=where(data.tws[ind] gt (tws[0]*(1.-tws[1])) and data.tws[ind] lt (tws[0]*(1.+tws[1])))
  for i=long(tws[2]), n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(tws[2])),index[i-(tws[2]-1):i]) then tws_result = tws_result[0] eq -1 ? index[i] : [tws_result,index[i]]
  print,'TWS',n_elements(tws_result)
endif
if n_elements(tws_result) ne 0 then if tws_result[0] eq -1 then return,-1 else ind=ind[tws_result]

if n_elements(mean_tws) eq 3 then begin
  mean_tws_result=long(-1)
  smoothed=ts_smooth(data.tws,mean_tws[2],/backward,order=2*mean_tws[2])
  mean_tws_result=where(smoothed[ind] gt (mean_tws[0]*(1.-mean_tws[1])) and smoothed[ind] lt (mean_tws[0]*(1.+mean_tws[1])))
  print,'mean_tws',n_elements(mean_tws_result)
endif
if n_elements(mean_tws_result) ne 0 then if mean_tws_result[0] eq -1 then return,-1 else ind=ind[mean_tws_result]

if n_elements(mean_aws) eq 3 then begin
  mean_aws_result=long(-1)
  smoothed=ts_smooth(data.aws,mean_aws[2],/backward,order=2*mean_aws[2])
  mean_aws_result=where(smoothed[ind] gt (mean_aws[0]*(1.-mean_aws[1])) and smoothed[ind] lt (mean_aws[0]*(1.+mean_aws[1])))
  print,'mean_aws',n_elements(mean_aws_result)
endif
if n_elements(mean_aws_result) ne 0 then if mean_aws_result[0] eq -1 then return,-1 else ind=ind[mean_aws_result]


; if n_elements(mean_vtws) eq 3 then begin
;   mean_vtws_result=long(-1)
;   smoothed=ts_smooth(sqrt(data.vtwsx^2.+data.vtwsy^2.),mean_vtws[2],/backward,order=2*mean_vtws[2])
;   mean_vtws_result=where(smoothed[ind] gt (mean_vtws[0]*(1.-mean_vtws[1])) and smoothed[ind] lt (mean_vtws[0]*(1.+mean_vtws[1])))
;   print,'mean_vtws',n_elements(mean_vtws_result)
; endif

if n_elements(hdc) eq 3 then begin
  hdc_result=long(-1)
  index=where(data.hdc[ind] gt (hdc[0]*(1.-hdc[1])) and data.hdc[ind] lt (hdc[0]*(1.+hdc[1])))
  for i=long(hdc[2]), n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(hdc[2])),index[i-(hdc[2]-1):i]) then hdc_result = hdc_result[0] eq -1 ? index[i] : [hdc_result,index[i]]
  print,'HDC',n_elements(hdc_result)
endif
if n_elements(hdc_result) ne 0 then if hdc_result[0] eq -1 then return,-1 else ind=ind[hdc_result]

if n_elements(rowpermin) eq 3 then begin
  rowpermin_result=long(-1)
  index=where(data.rowpermin[ind] ge (rowpermin[0]*(1.-rowpermin[1])) and data.rowpermin[ind] le (rowpermin[0]*(1.+rowpermin[1])))
  for i=long(rowpermin[2]), n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(rowpermin[2])),index[i-(rowpermin[2]-1):i]) then rowpermin_result = rowpermin_result[0] eq -1 ? index[i] : [rowpermin_result,index[i]]
  print,'ROWPERMIN',n_elements(rowpermin_result)
endif
if n_elements(rowpermin_result) ne 0 then if rowpermin_result[0] eq -1 then return,-1 else ind=ind[rowpermin_result]

if n_elements(const_course) eq 3 then begin
  constant_course_result=long(-1)
  for i=long(const_course[2]), n_elements(ind)-1 do begin
     if (max(abs(data.cog[ind[i]]-data.cog[(ind[i]-const_course[2]):ind[i]])) le const_course[1]) then constant_course_result = constant_course_result[0] eq -1 ? i : [constant_course_result,i]
      ;print,  max(abs(data.cog[ind[i]]-data.cog[ind[i]-constant_course[2]:ind[i]]))
   endfor
  print,'constant_course',n_elements(constant_course_result)
endif
if n_elements(constant_course_result) ne 0 then if constant_course_result[0] eq -1 then return,-1 else ind=ind[constant_course_result]

if n_elements(const_sog) eq 3 then begin
  constant_sog_result=long(-1)
  for i=long(const_sog[2]), n_elements(ind)-1 do begin
     if (max(abs(data.sog[ind[i]]-data.sog[(ind[i]-const_sog[2]):ind[i]])) le const_sog[1]) then constant_sog_result = constant_sog_result[0] eq -1 ? i : [constant_sog_result,i]
   endfor
  print,'constant_sog',n_elements(constant_sog_result)
endif
if n_elements(constant_sog_result) ne 0 then if constant_sog_result[0] eq -1 then return,-1 else ind=ind[constant_sog_result]

if n_elements(const_bsp) eq 3 then begin
  constant_bsp_result=long(-1)
  for i=long(0), n_elements(ind)-1 do begin
     if (max(abs(data.bsp[ind[i]]-data.bsp[(ind[i]-const_bsp[2]):ind[i]])) le const_bsp[1]) then constant_bsp_result = constant_bsp_result[0] eq -1 ? i : [constant_bsp_result,i]
   endfor
  print,'constant_bsp',n_elements(constant_bsp_result)
endif
if n_elements(constant_bsp_result) ne 0 then if constant_bsp_result[0] eq -1 then return,-1 else ind=ind[constant_bsp_result]

; if n_elements(const_course) eq 3 then begin
;   constant_course_result=long(-1)
;   for i=long(const_course[2]), n_elements(ind)-1 do if array_equal(reverse(ind[i]-indgen(const_course[2])),ind[i-(const_course[2]-1):i]) then constant_course_result = constant_course_result[0] eq -1 ? ind[i] : [constant_course_result,ind[i]]
;   print,'constant_course',n_elements(constant_course_result)
; endif
; 
; if n_elements(const_bsp) eq 3 then begin
;   constant_bsp_result=long(-1)
;   for i=long(const_bsp[2]), n_elements(ind)-1 do if array_equal(reverse(ind[i]-indgen(const_bsp[2])),ind[i-(const_bsp[2]-1):i]) then constant_bsp_result = constant_bsp_result[0] eq -1 ? ind[i] : [constant_bsp_result,ind[i]]
;   print,'constant_bsp',n_elements(constant_bsp_result)
; endif
; 
; if n_elements(const_sog) eq 3 then begin
;   constant_sog_result=long(-1)
;   for i=long(const_sog[2]), n_elements(ind)-1 do if array_equal(reverse(ind[i]-indgen(const_sog[2])),ind[i-(const_sog[2]-1):i]) then constant_sog_result = constant_sog_result[0] eq -1 ? ind[i] : [constant_sog_result,ind[i]]
;   print,'constant_sog',n_elements(constant_sog_result)
; endif



; if n_elements(constant_course_result) ne 0 then ergebnis=schnittmenge(ergebnis,constant_course_result)
; if n_elements(sailing_result) ne 0 then ergebnis=schnittmenge(ergebnis,sailing_result)
; if n_elements(rowpermin_result) ne 0 then ergebnis=schnittmenge(ergebnis,rowpermin_result)
; if n_elements(mean_tws_result) ne 0 then ergebnis=schnittmenge(ergebnis,mean_tws_result)
; if n_elements(aws_result) ne 0 then ergebnis=schnittmenge(ergebnis,aws_result)
; if n_elements(tws_result) ne 0 then ergebnis=schnittmenge(ergebnis,tws_result)
; if n_elements(hdc_result) ne 0 then ergebnis=schnittmenge(ergebnis,hdc_result)
; if n_elements(cog_result) ne 0 then ergebnis=schnittmenge(ergebnis,cog_result)
; 
; if n_elements(awa_result) ne 0 then ergebnis=schnittmenge(ergebnis,awa_result)
; if n_elements(mean_aws_result) ne 0 then ergebnis=schnittmenge(ergebnis,mean_aws_result)
; 
; if n_elements(constant_sog_result) ne 0 then ergebnis=schnittmenge(ergebnis,constant_sog_result)
; if n_elements(constant_bsp_result) ne 0 then ergebnis=schnittmenge(ergebnis,constant_bsp_result)

;ergebnis=schnittmenge(constant_course_result,sailing_result,rowpermin_result,mean_tws_result,aws_result,tws_result,hdc_result,cog_result, bsp_result,awa_result,mean_aws_result,sog_result,constant_sog_result,constant_bsp_result) ;mean_vtws_result

print, 'place_cuts: Anzahl an Punkten, die alle Bed. erfuellen',n_elements(ind)
return, ind
;if ergebnis[0] eq -1 then return, -1 else return, ind[ergebnis]
end