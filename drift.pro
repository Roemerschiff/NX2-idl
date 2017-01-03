function mean_histogr_drift,data,tws=tws,sailing=sailing,row=row,mean_tws=mean_tws,awa=awa,angle_smooth=angle_smooth,mean_vtws=mean_vtws,vtwa=vtwa, aws=aws,mean_aws=mean_aws, index=index,sog=sog

if n_elements(index) eq 0 then index=indgen(n_elements(data.x))

if n_elements(tws) ne 3 and n_elements(mean_tws) ne 3 and n_elements(mean_vtws) ne 3 and n_elements(aws) ne 3  and n_elements(mean_aws) ne 3 then print,'%mean_histogr: Give either tws or mean_tws oder meanVWIND_WASSYS!'

ind=place_cuts(data,tws=tws,sailing=sailing,row=row,mean_tws=mean_tws,mean_vtws=mean_vtws,aws=aws,mean_aws=mean_aws, ind=index)

if n_elements(ind) ne 1 and ind[0] ne -1 then begin
  ;smooth wind angle for rapid changes with backward smothing
  if n_elements(angle_smooth) ne 0 then begin
     print, 'awa set?',keyword_set(awa)
     if keyword_set(awa) then wa=ts_smooth(abs(data.awa),angle_smooth[0],/backward,order=2*angle_smooth[0]) else wa=ts_smooth(abs(data.twa),angle_smooth[0],/backward,order=2*angle_smooth[0])
    endif else wa=keyword_set(awa)? data.awa : data.twa
  
;   inddrift=ind[where(data.bsp[ind] le data.sog[ind])]
;   print, 'keep ',n_elements(inddrift),'Where bsp<=sog, discard bsp>sog',n_elements(where(data.bsp[ind] ge data.sog[ind])),' points'
;   drift=sqrt(data.sog[inddrift]^2.-data.bsp[inddrift]^2.)
  
  inddrift=ind
  teststromung=where(data.stromwo[inddrift] ne -1000)
  if n_elements(teststromung) eq n_elements(inddrift) then begin
    sogx=data.sog*sin(data.cog*!pi/180.)-data.stromwo
    sogy=data.sog*cos(data.cog*!pi/180.)-data.stromsn
    sog=sqrt(sogx^2.+sogy^2.)
  endif else sog=data.sog
  drift=sin(abs(data.hdc[inddrift]-data.cog[inddrift])/180.*!pi)*sog[inddrift]
  hist=histogram(abs(wa[inddrift]),min=-7.5,max=187.49,bin=15,rev=rev,loc=loc)
  print,'Histogram Windangle:',hist
  drift_mean=loc*0.
  for i=0,12 do drift_mean[i]=rev[i] eq rev[i+1]? 0.:  mean(drift[rev[rev[i]:rev[i+1]-1]])
  return,drift_mean
endif else begin
  return,[0]
endelse
end


;+
; PROJECT:
;	NX_2
; NAME:
;	polar_plot
;
; PURPOSE:
;	produce a polar plot of the filted data
;
; CATEGORY:
;	plotting
;
; CALLING SEQUENCE:
;	polar_plot,data,tws=tws,sailing=sailing,row=row,const=const,mean_tws=mean_tws,mean_vtws=mean_vtws,awa=awa, angle_smooth=angle_smooth, vtwa=vtwa, text=text,no_legend=no_legend,aws=aws,mean_aws=mean_aws
;
; INPUTS:
;	data:	structure from read_nx2
;
; OPTIONAL INPUTS:
;	This are describes the implemented selection criteria:
;	sailing, row ; array of [required value, max. deviation, time]
;		so row=[20,4,180] collects only points where in ALL preceding 180 s the rowing frequency was between 20-4=16 and 20+4=24
;	mean : before filetrung a backward smoothing algotrithm is applied
;	tws,vtws: array[x,y,z] x,y are ignored, z is the time for which a wind speed within +- 0.25 ktn is required
;	text:  optinol explanatory output
;	anlge_smooth: smoth wind angle for anlge_smooth seconds before filtering, useful in case of rapidly chaning wind directions in times of very small wind speeds. Angle_smooth allows to keep this data
;
; KEYWORDS:
;	awa: use awa for sorting not twa (should always be used for analysis)
;	no_legend: suppresses legend output
;	
;
; EXAMPLE:
;	polar_plot, d61,mean_aws=[1.,20,15],sailing=[1.,.1,60],angle=10,const_course=[1,10,20],row=[0,1,60],/awa
;
; TEST STATUS:
;	not tested
;
; MODIFICATION HISTORY:
;	Written by:	Moritz G�nther 02.08.2006
;	9. May 2008 added keywords const_sog, const_bsp and changed keyword const to const_course  HMG
;-
pro drift,data,tws=tws,sailing=sailing,row=row,const_course=const_course,mean_tws=mean_tws,mean_vtws=mean_vtws,awa=awa, angle_smooth=angle_smooth, vtwa=vtwa, text=text,no_legend=no_legend,aws=aws,mean_aws=mean_aws, index=index,sog=sog, const_sog=const_sog,const_bsp=const_bsp,titel=titel

if n_elements(index) eq 0 then index=indgen(n_elements(data.x),/long)


if n_elements(tws) ne 3 and n_elements(mean_tws) ne 3 and n_elements(mean_vtws) ne 3 and n_elements(aws) ne 3  and n_elements(mean_aws) ne 3 then tws=[1.,1.,10]
plot,[0],[0],/polar,/nodata,xr=[0,1.5],yr=[-1.5,.5],xstyle=5,ystyle=4,thick=3.,xmar=[8,2],ymar=[.1,4.],title=title
axis,0,0,xaxis=0,chars=1.3+!p.multi[1]/4.
;axis,0,0,yaxis=0,ytit='Bootsgeschwindigkeit [Knoten]',chars=1.3+!p.multi[1]/4.,ytickn=['1.5','1.0','0.5','0','0.5']
axis,0,0,yaxis=0,ytit='Bootsgeschwindigkeit [Knoten]',chars=1.3,ytickn=['1.5','1.0','0.5','0','0.5']

mps2knots=0.51444

;those three selection criteria are the same for every step in velocity. 
;Pre filter data here once and work on the subset later to save time!
ind=place_cuts(data,sailing=sailing,row=row,const_course=const_course,const_sog=const_sog,const_bsp=const_bsp, ind=index)

;good colors, easy to see on print
;colors=[1,5,7,12,4,7,10]
colors=[1,5,8,12,6,7,10]

for speed=1.,7.,1.5 do begin
  speedinmps=speed*mps2knots
  if n_elements(aws) eq 3 then aws=[speedinmps,0.25/(speedinmps),aws[2]]
  if n_elements(tws) eq 3 then tws=[speedinmps,0.25/(speedinmps),tws[2]]
  if n_elements(mean_tws) eq 3 then mean_tws=[speedinmps,0.25/(speedinmps),mean_tws[2]]
  if n_elements(mean_vtws) eq 3 then mean_vtws=[speedinmps,0.25/(speedinmps),mean_vtws[2]] 
  if n_elements(mean_aws) eq 3 then mean_aws=[speedinmps,0.25/(speedinmps),mean_aws[2]]
  mean=mean_histogr_drift(data,tws=tws,mean_tws=mean_tws,mean_vtws=mean_vtws,angle_smooth=angle_smooth,vtwa=vtwa,aws=aws,mean_aws=mean_aws,awa=awa, index=ind,sog=sog)
  oplot,/polar,mean,-(findgen(13)*15.-91.)/180.*!pi,col=colors[(speed-1.)/1.5],psym=1,symsize=2.,thick=3.
  speeds=n_elements(speeds) eq 0 ? speed : [speeds,speed]
endfor
col=[0,colors]
lines=[-99,make_array(n_elements(speeds),val=0)]
speeds=['Wind [Knoten]',string(speeds,format='(f3.1)')]
if ~keyword_set(no_legend) then legend,speeds,/bottom,/right,col=col,lines=lines
if n_elements(text) ne 0 then xyouts,0.1,.7,text,charth=3

for i=0.5,1.5,0.25 do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=1,thick=3.

xyouts,.75,.6,titel,charsize=1.8,ali=0.5

end
