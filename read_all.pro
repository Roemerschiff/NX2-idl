d11=read_nx2('first-day-no-sail19-06-2006.00.csv',19,corr_bsp=-42)
d21=read_nx2('second-day-no-sail-20.06.2006.00.csv',20,corr_bsp=-42)
d22=read_nx2('second-day-second-trip-no-sail-20-06-2006.00.csv',20,corr_bsp=-42)
d31=read_nx2('third-day-no-sail21-06-2006.00.csv',21,corr_bsp=1.25)
d32=read_nx2('third-day-no-sail-compass21-06-2006.00.csv',21,corr_bsp=1.25)
d41=read_nx2('fourth-day-no-sail22-06-2006.00.csv',22,corr_bsp=1.25)
d42=read_nx2('fourth-day-no-sail-second-try22-06-2006.00.csv',22,corr_bsp=1.25)
d43=read_nx2('fourth-day-no-sail-third-try22-06-2006.00.csv',22,corr_bsp=-42)
;A note on the corr_bsp
;From rowing on the Naab we find corr_bsp = 1.25
;but that does not match the Donau experiences we had
;we use corr_bsp=1.1 here
d51=read_nx2('fifth-day-no-sail23-06-2006.00.csv',23,corr_bsp=1.1)
d61=read_nx2('sixth-day-with-sail24-06-2006.00.csv',24,corr_bsp=1.1)

all=ptrarr(9)
all[0]=ptr_new(d11)
all[1]=ptr_new(d21)
all[2]=ptr_new(d22)
all[3]=ptr_new(d31)                             
all[4]=ptr_new(d32)
all[5]=ptr_new(d41)
all[6]=ptr_new(d42)
all[7]=ptr_new(d51)
all[8]=ptr_new(d61)
n_totalnumber=0
;for i=0,8 do n_totaldatanumber+=n_elements((*all[i]).twa))
;alldata=

result=label_date(date=['%I:%S','%H'])
loadct,12