loadct,12,ncol=16
mps2knots=0.51444

setplotps,'~/Galeere2/Buch/erklarungpolarplot'
device,/color,xsize=10,ysize=30

plot, /polar, [2.78,2],[-!pi/2-.05,-1.2],psym=1,xr=[-4,4],yr=[-4,4],xstyle=5,ystyle=5,thick=3,symsize=3.,col=12, pos=[0.01,.676,.99,.99];,xmar=[3,3],ymar=[3,3]
for i=1,4.,1. do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=1,thick=3.
axis,0,0,xaxis=0,xtickn=['4','2','0','2','4'],xthick=3
axis,0,0,yaxis=0,ytickn=['4','2','0','2','4'],ythick=3
plots,[0,.5,.5,-.5,-.5,0],[1.3,.8,-1,-1,.8,1.3]
xyouts,.5,3.5,'Abbildung A'

;index=where(dlog.twa gt 90 and dlog.twa lt 180)   ,index=index
index=place_cuts(dlog,sailing=[1,.1,120],tws=[2.,.1,2])
;index=[126453,126454,126455,126456,126457]
plot, /polar, dlog.bsp[index],-((dlog.twa[index])/180.*!pi)+!pi*.5, psym=1, xr=[-4,4], yr=[-4,4], xstyle=5, ystyle=5, thick=3, symsize=3., col=12,/noerase, pos=[0.01,.343,.99,.656];,xmar=[3,3],ymar=[3,3]
for i=1,4.,1. do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=1,thick=3.
axis,0,0,xaxis=0,xtickn=['4','2','0','2','4'],xthick=3
axis,0,0,yaxis=0,ytickn=['4','2','0','2','4'],ythick=3
plots,[0,.5,.5,-.5,-.5,0],[1.3,.8,-1,-1,.8,1.3]
for i=0,24 do oplot,[0,4],[0, (15.*i+7.5)/180.*!pi],/polar,col=8 ,thick=3.
xyouts,.5,3.5,'Abbildung B'

xyouts,-3,-5,'Fertiges Polardiagramm:'

plot,[0],[0],/polar,/nodata,xr=[0,4.],yr=[-4.,1.],xstyle=5,ystyle=4,thick=3.,xmar=[8,2],ymar=[.1,4.],/noerase, pos=[0.5,0.05,.99,.273]
axis,0,0,xaxis=0,chars=1.3+!p.multi[1]/4.
axis,0,0,yaxis=0,ytit='Bootsgeschwindigkeit [Knoten]',chars=1.3+!p.multi[1]/4.,ytickn=['4','3','2','1','0','1']
for i=1,4.,1. do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=1,thick=3.
for i=-6,7 do oplot,[0,4],[0, (15.*i+7.5)/180.*!pi],/polar,col=8 ,thick=3.
mps2knots=0.51444
mean=mean_histogr(dlog,index=index);sailing=[1,.1,120],tws=[2.,.1,2],
oplot,/polar,mean,-(findgen(13)*15.-91.)/180.*!pi,col=12,psym=1,symsize=2.,thick=3.
xyouts,.2,-4.5,'Abbildung C'

setplotx














loadct,12,ncol=16
mps2knots=0.51444

setplotps,'~/Galeere2/Vortrag/erklarungpolarplot'
device,/color,xsize=30,ysize=10
!p.multi=[0,3,1]
plot, /polar, [2.78,2],[-!pi/2-.05,-1.2],psym=1,xr=[-4,4],yr=[-4,4],xstyle=5,ystyle=5,thick=3,symsize=3.,col=12;,xmar=[3,3],ymar=[3,3]
for i=1,4.,1. do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=1,thick=3.
axis,0,0,xaxis=0,xtickn=['4','2','0','2','4'],xthick=3,chars=1.3+!p.multi[1]/4.
axis,0,0,yaxis=0,ytickn=['4','2','0','2','4'],ythick=3,chars=1.3+!p.multi[1]/4.
plots,[0,.5,.5,-.5,-.5,0],[1.3,.8,-1,-1,.8,1.3],thick=3
;xyouts,.5,3.5,'Abbildung A'

;index=where(dlog.twa gt 90 and dlog.twa lt 180)   ,index=index
index=place_cuts(dlog,sailing=[1,.1,120],tws=[2.,.1,2])
;index=[126453,126454,126455,126456,126457]
plot, /polar, dlog.bsp[index],-((dlog.twa[index])/180.*!pi)+!pi*.5, psym=1,xstyle=5,ystyle=5, xr=[-4,4], yr=[-4,4], thick=3, symsize=3., col=12
for i=1,4.,1. do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=1,thick=3.
axis,0,0,xaxis=0,xtickn=['4','2','0','2','4'],xthick=3,chars=1.3+!p.multi[1]/4.
axis,0,0,yaxis=0,ytickn=['4','2','0','2','4'],ythick=3,chars=1.3+!p.multi[1]/4.
plots,[0,.5,.5,-.5,-.5,0],[1.3,.8,-1,-1,.8,1.3],thick=3
for i=0,24 do oplot,[0,4],[0, (15.*i+7.5)/180.*!pi],/polar,col=8 ,thick=3.
;xyouts,.5,3.5,'Abbildung B'

xyouts,-3,-5,'Fertiges Polardiagramm:'

plot,[0],[0],/polar,/nodata,xr=[0,4.],yr=[-4.,1.],xstyle=5,ystyle=4,thick=3.,xmar=[8,2],ymar=[.1,4.],/noerase
axis,0,0,xaxis=0,chars=1.3+!p.multi[1]/4.,xthick=3
axis,0,0,yaxis=0,ytit='Bootsgeschwindigkeit [Knoten]',chars=1.3+!p.multi[1]/4.,ytickn=['4','3','2','1','0','1'],xthick=3
for i=1,4.,1. do oplot,/polar,make_array(360,val=i),findgen(360)/180.*!pi,line=1,thick=3.
for i=-6,7 do oplot,[0,4],[0, (15.*i+7.5)/180.*!pi],/polar,col=8 ,thick=3.
mps2knots=0.51444
mean=mean_histogr(dlog,index=index);sailing=[1,.1,120],tws=[2.,.1,2],
oplot,/polar,mean,-(findgen(13)*15.-91.)/180.*!pi,col=12,psym=1,symsize=2.,thick=3.
;xyouts,.2,-4.5,'Abbildung C'

setplotx
