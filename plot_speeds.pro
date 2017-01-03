; plot routine for sog, bsp and rowpermin
; day: day 
; hmin: lower hour
; hmax: upper hour
; e.g plot_speeds, data, 21,16,17,55,05 would plot from 16:55 to 17:05 on the 21.06.2006
;loadct,12

pro plot_speeds,data,day,hmin,hmax,minmin,minmax,noerase=noerase,heel=heel,color=color,bottom=bottom, top=top, yrange=yrange, wind=wind,charsize=charsize

xr=[julday(min(data.zeit.month),day,min(data.zeit.year),hmin,minmin),julday(max(data.zeit.month),day,max(data.zeit.year),hmax,minmax)]

if n_elements(color) eq 0 then color=[15,4,12,8]
if n_elements(yrange) eq 0 then yrange=[0,4]
if n_elements(charsize) eq 0 then charsize=1.2

plot,data.loc_time,data.sog,xtickf=['label_date'],XTICKU=['Time'],YMar=[4,2],xr=xr,noerase=noerase,ystyle=8,ytit='Geschwindigkeit  in Knoten',xmar=[6,7],xtit='Uhrzeit',chars=charsize,col=color[0],yr=yrange
oplot,data.loc_time,data.bsp,col=color[1],nsum=2

if keyword_set(wind) then begin
  oplot,data.loc_time,data.tws/0.51444,col=color[3],nsum=5
  axis,yaxis=1,xtickf=['label_date','label_date'],XTICKU=['Time','Hour'],YMar=[4,2],color=color[2],xr=xr,/noerase,/save,ytit='TWA',xmar=[6,7],chars=charsize,yr=[0,180]
  oplot,data.loc_time,abs(data.twa),col=color[2],nsum=5
end

if n_elements(heel) eq 1 then begin
 if heel eq 0 then begin ;Stampfen
    oplot, data.loc_time, data.aws,color=150,nsum=2
    axis,yaxis=1,xtickf=['label_date','label_date'],XTICKU=['Time','Hour'],YMar=[4,2],color=100,xr=xr,yr=[0,8],/noerase,/save,ytit='Stampfen (Grad)',xmar=[6,7],chars=charsize
    oplot,data.loc_time,data.heel,col=color[2],psym=5
    legend,['Geschwindigkeit '+STRING("374B)+'ber Grund','Bootsgeschwindigkeit','Stampfen (Grad)'],col=[0,200,100],line=[0,0,0],/bottom
  endif else begin ;Kr�ngung
    oplot, data.loc_time, data.aws,color=150,nsum=2
    axis,yaxis=1,xtickf=['label_date','label_date'],XTICKU=['Time','Hour'],YMar=[4,2],color=100,xr=xr,yr=[0,8],/noerase,/save,ytit='Kr�ngung (Grad)',xmar=[6,7],chars=charsize
    oplot,data.loc_time,data.heel,col=color[2],psym=5
    legend,['Geschwindigkeit '+STRING("374B)+'ber Grund','Bootsgeschwindigkeit','Kr�ngung (Grad)'],col=color,line=[0,0,0],/bottom
  endelse
endif else begin ;Ruderschl�ge
  if ~keyword_set(wind) then begin
    axis,yaxis=1,xtickf=['label_date','label_date'],XTICKU=['Time','Hour'],YMar=[4,2],color=color[2],xr=xr,yr=[0,50],/noerase,/save,ytit='Ruderschl'+STRING("344B)+'ge pro Minute',xmar=[6,7],chars=charsize
    oplot,data.loc_time,data.rowpermin>0,col=color[2]
    !P.color=color[0]
    legend,['Linke Achse','Geschwindigkeit '+STRING("374B)+'ber Grund','Bootsgeschwindigkeit','Rechte Achse', 'Ruderschl'+STRING("344B)+'ge pro Minute'],col=[color[0],color[0],color[1],color[0],color[2]],line=[-99,0,0,-99,0],bottom=bottom,top=top, textcol=[color[0],color[0],color[1],color[2],color[2]],box=1
  endif else begin
   !P.color=color[0]
    legend,['Linke Achse','Geschwindigkeit '+STRING("374B)+'ber Grund','Bootsgeschwindigkeit','TWS','Rechte Achse', 'TWA (180 ist von achtern)'],col=[color[0],color[0],color[1],color[3],color[0],color[2]],line=[-99,0,0,0,-99,0],bottom=bottom,top=top, textcol=[color[0],color[0],color[1],color[3],color[2],color[2]],box=1
 endelse
endelse
print,'mean SOG:',mean(data.sog[wann(data.zeit,[hmin,hmax],[minmin,minmax])])
print,'mean BSP:',mean(data.bsp[wann(data.zeit,[hmin,hmax],[minmin,minmax])])
end

