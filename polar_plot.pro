;example polar_plot,d61,mean_tws=[1.,1,20],const=[1.,5.,20.]


function mean_histogr,data,tws=tws,sailing=sailing,row=row,mean_tws=mean_tws,awa=awa,angle_smooth=angle_smooth,mean_vtws=mean_vtws,vtwa=vtwa, aws=aws,mean_aws=mean_aws, index=index,sog=sog

if n_elements(index) eq 0 then index=indgen(n_elements(data.x))

if n_elements(tws) ne 3 and n_elements(mean_tws) ne 3 and n_elements(mean_vtws) ne 3 and n_elements(aws) ne 3  and n_elements(mean_aws) ne 3 then print,'%mean_histogr: Give either tws or mean_tws oder meanVWIND_WASSYS!'
;if n_elements(const) eq 0 then const=[5.,10.,20.]
;if n_elements(row) eq 0 then row=[0.,1.,10.]
;if n_elements(sailing) eq 0 then sailing=[1.,0.,20.]
ind=place_cuts(data,tws=tws,sailing=sailing,row=row,mean_tws=mean_tws,mean_vtws=mean_vtws,aws=aws,mean_aws=mean_aws, ind=index)

if n_elements(ind) ne 1 and ind[0] ne -1 then begin
  ;smooth wind angle for rapid changes with backward smothing
  if n_elements(angle_smooth) ne 0 then begin
     print, 'awa set?',keyword_set(awa)
     if keyword_set(awa) then wa=ts_smooth(abs(data.awa),angle_smooth[0],/backward,order=2*angle_smooth[0]) else wa=ts_smooth(abs(data.twa),angle_smooth[0],/backward,order=2*angle_smooth[0])
    endif else wa=keyword_set(awa)? data.awa : data.twa
  histogr= keyword_set(sog) ? hist_2d(data.sog[ind],abs(wa[ind]),min1=-0.05,max1=6.95,min2=-7.5,max2=187.49,bin1=0.1,bin2=15.) :  hist_2d(data.bsp[ind],abs(wa[ind]),min1=-0.05,max1=6.95,min2=-7.5,max2=187.49,bin1=0.1,bin2=15.)
  hist_mean=make_array(n_elements(histogr[0,*]))
  for i=0,n_elements(hist_mean)-1 do begin
    hist_mean[i]=total(histogr[*,i]) eq 0 ? 0:total(histogr[*,i]*findgen(71)/10./total(histogr[*,i]))
  endfor
  print,'histgr', total(histogr,1)
  print,'last bin',histogr[*,n_elements(hist_mean)-1]

  return,hist_mean
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
pro polar_plot,data,tws=tws,sailing=sailing,row=row,const_course=const_course,mean_tws=mean_tws,mean_vtws=mean_vtws,awa=awa, angle_smooth=angle_smooth, vtwa=vtwa, text=text,no_legend=no_legend,aws=aws,mean_aws=mean_aws, index=index,sog=sog, const_sog=const_sog,const_bsp=const_bsp,psym=psym,symsize=symsize,circle=circle, speedbins=speedbins,xmax=xmax

if n_elements(index) eq 0 then index=indgen(n_elements(data.x),/long)
if n_elements(psym) eq 0 then psym=1
if n_elements(symsize) eq 0 then symsize=2
if n_elements(circle) eq 0 then circle=1
if n_elements(speedbins) eq 0 then speedbins=[1.,7.,1.5]
if n_elements(xmax) eq 0 then xmax=3

if n_elements(tws) ne 3 and n_elements(mean_tws) ne 3 and n_elements(mean_vtws) ne 3 and n_elements(aws) ne 3  and n_elements(mean_aws) ne 3 then tws=[1.,1.,10]
plot,[0],[0],/polar,/nodata,xr=[0,xmax],yr=[-xmax,xmax/3.],xstyle=5,ystyle=4,thick=3.,xmar=[8,2],ymar=[.1,4.]
axis,0,0,xaxis=0,chars=1.3+!p.multi[1]/4.
axis,0,0,yaxis=0,ytit='Bootsgeschwindigkeit [Knoten]',chars=1.3+!p.multi[1]/4.;,ytickn=['3','2','1','0','1']
mps2knots=0.51444

;those three selection criteria are the same for every step in velocity. 
;Pre filter data here once and work on the subset later to save time!
ind=place_cuts(data,sailing=sailing,row=row,const_course=const_course,const_sog=const_sog,const_bsp=const_bsp, ind=index)

;good colors, easy to see on print
colors=[1,5,7,12,4,7,10]
colors=[1,5,8,12,6,7,10]

for speed=speedbins[0],speedbins[1],speedbins[2] do begin
  speedinmps=speed*mps2knots
  if n_elements(aws) eq 3 then aws=[speedinmps,0.25/(speedinmps),aws[2]]
  if n_elements(tws) eq 3 then tws=[speedinmps,0.25/(speedinmps),tws[2]]
  if n_elements(mean_tws) eq 3 then mean_tws=[speedinmps,0.25/(speedinmps),mean_tws[2]]
  if n_elements(mean_vtws) eq 3 then mean_vtws=[speedinmps,0.25/(speedinmps),mean_vtws[2]] 
  if n_elements(mean_aws) eq 3 then mean_aws=[speedinmps,0.25/(speedinmps),mean_aws[2]]
  mean=mean_histogr(data,tws=tws,mean_tws=mean_tws,mean_vtws=mean_vtws,angle_smooth=angle_smooth,vtwa=vtwa,aws=aws,mean_aws=mean_aws,awa=awa, index=ind,sog=sog)
  oplot,/polar,mean,-(findgen(13)*15.-91.)/180.*!pi,col=colors[(speed-1.)/1.5],psym=psym,symsize=symsize,thick=3.
  speeds=n_elements(speeds) eq 0 ? speed : [speeds,speed]
endfor
col=[0,colors]
lines=[-99,make_array(n_elements(speeds),val=0)]
speeds=['Wind [Knoten]',string(speeds,format='(f3.1)')]
if ~keyword_set(no_legend) then legend,speeds,/bottom,/right,col=col,lines=lines
if n_elements(text) ne 0 then xyouts,0.1,.7,text,charth=3

for i=0.5,xmax,0.5 do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=circle,thick=3.

end
