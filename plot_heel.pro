pro plot_heel,data,day,hmin,hmax,minmin,minmax,noerase=noerase,heel=heel
xr=[julday(6,day,2006,hmin,minmin),julday(6,day,2006,hmax,minmax)]

plot,data.loc_time,data.aws,xtickf=['label_date'],XTICKU=['Time'],YMar=[4,2],xr=xr,noerase=noerase,ystyle=8,ytit='Geschwindigkeit [Knoten]',xmar=[6,7],xtit='Zeit [min]',chars=1.2,yr=[0,8]
oplot,data.loc_time,data.heel,col=100,psym=5

axis,yaxis=1,xtickf=['label_date','label_date'],XTICKU=['Time','Hour'],YMar=[4,2],color=100,xr=xr,/noerase,/save,ytit='AWA',xmar=[6,7],chars=1.2,yr=[-180,+180]
oplot,data.loc_time,data.awa,col=200

legend,['AWS','heel(degree)','awa'],col=[0,100,200],line=[0,0,0],/top, /left
end