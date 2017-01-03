
;keep graphic windows
device, retain=2

;load colour table
device,true_color=24
device,decomposed=0
device,/bypass_translation
loadct,12,ncol=16

print,"idl_startup.pro done"
astron
.comp /usr/local/rsi/user_contrib/astron/pro/legend.pro  ;there is name clash and astrolib is not sourced last

loadct,12,ncol=16

d18=read_nx2('../data/18tue_firstday.00.csv',19,6,2010,38.9489,20.763,corr_bsp=1.5)
d19=read_nx2('../data/19wed_secondday.00.csv',19,6,2010,38.9489,20.763,corr_bsp=1.5)
d20=read_nx2('../data/20thu_thirdday.00.csv',19,6,2010,38.9489,20.763,corr_bsp=1.5)
d20_2=read_nx2('../data/20thu_thirdday_2.00.csv',19,6,2010,38.9489,20.763,corr_bsp=1.5)
all=merge_nx2(d18,d19,d20,d20_2)

googlemaps,d18,'../d18'
googlemaps,d19,'../d19'
googlemaps,d20,'../d20'
googlemaps,d20_2,'../d20_2'

set_plot,'ps'
device,/color,file='../data/d19.ps'
check_compass,d19,scale=250,labelstep=600,linestep=300,xr=[-1.4e4,0]
device,/close
set_plot,'X'

set_plot,'ps'
device,/color,file='../data/d19_speeds.ps'
plot_speeds,d19,19,11,15,00,60,yr=[0,15]
device,/close
set_plot,'X'

set_plot,'ps'
device,/color,file='../data/d19_polar.ps'
polar_plot, d19,mean_aws=[1.,30,10],angle=10,const_course=[1,30,10],/awa,speedbins=[2.,10,2],xmax=7
device,/close
set_plot,'X'




