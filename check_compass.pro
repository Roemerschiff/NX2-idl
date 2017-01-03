;+
; PROJECT:
;	NX_2
; NAME:
;	check_compass
;
; PURPOSE:
;	Plot the course in order to riminf us where we did what
;
; CATEGORY:
;	plotting
;
; CALLING SEQUENCE:
;	check_compass, data,xrange=xrange,yrange=yrange
;
; INPUTS:
;	data	:da data structure from read_nx2
;
; OPTIONAL INPUTS:
;	xr, yr as in plot
; OUTPUT:
;	white line: trajectory
;	blue line:  trajectory with sail set
;	white numbers : time stamps (approx. every 3 min)
;	red lines: hdc= direction of bow
;	green line: cog= direction of movement over ground (to see e.g. a backward drift)
;
; MODIFICATION HISTORY:
;	Written by:	Moritz G�nther 02.08.2006
;-

pro check_compass, data,xrange=xrange,yrange=yrange,labelstep=labelstep, index=index,scale=scale,xtickname=xtickname, linestep=linestep

if n_elements(index) eq 0 then index=indgen(n_elements(data.x),/long)
if n_elements(scale) eq 0 then scale=20.
if n_elements(labelstep) eq 0 then labelstep=180
if n_elements(linestep) eq 0 then linestep=60

mps2knots=0.51444

plot, data.x[index],data.y[index],xrange=xrange,yrange=yrange,xtit='West-Ost-Koordinate [m]', ytit='S'+STRING("374B)+'d-Nord-Koordinate [m]',xtickname=xtickname
sail=where(data.sailing[index] eq 1)
if sail[0] ne -1 then oplot, data.x[index[sail]],data.y[index[sail]],color=6
for i=50L,n_elements(index),linestep do begin
  oplot, data.x[index[i]]+[0,scale*data.bsp[index[i]]*sin(data.hdc[index[i]]/180.*!pi)], data.y[index[i]]+[0,scale*data.bsp[index[i]]*cos(data.hdc[index[i]]*!pi/180)], color=12, thick=2
  oplot, data.x[index[i]]+[0,scale*data.sog[index[i]]*sin(data.cog[index[i]]/180.*!pi)], data.y[index[i]]+[0,scale*data.sog[index[i]]*cos(data.cog[index[i]]*!pi/180)], color=2,thick=2
  oplot, data.x[index[i]]+[0,scale*data.tws[index[i]]/mps2knots*sin((data.cog[index[i]]+data.twa[index[i]])/180.*!pi)], data.y[index[i]]+[0,scale*data.tws[index[i]]*cos((data.cog[index[i]]+data.twa[index[i]])*!pi/180)], color=8,thick=2
endfor

for i=50L,n_elements(index),labelstep do begin
  caldat, data.loc_time[index[i]],month,day,year,hour,minute,second
  xyouts, data.x[index[i]],data.y[index[i]],strtrim(hour,2)+':'+strtrim(minute,2)
endfor
;legend,['Fahrtstrecke ohne Segel','Fahrt mit gesetztem Segel','Kompasskurs','Kurs '+STRING("374B)+'ber Grund','wahrer Wind'],line=[0,0,0,0,0],col=[15,6,12,2,8],/bottom,/left
legend,['Fahrt mit gesetztem Segel','Kompasskurs','Kurs '+STRING("374B)+'ber Grund','wahrer Wind'],line=[0,0,0,0],col=[6,12,2,8] ,/bottom,/left
end
