function make_histogr,data,tws
index=place_cuts(data,tws=tws,sailing=[1.,0.,20.],row=[0.,1.,10],const=[5.,10.,20.])
histogr=hist_2d(data.bsp[index],abs(data.twa[index]),min1=-0.05,max1=6.95,min2=0.,max2=180.,bin1=0.1,bin2=15.001)
hist_mean=make_array(n_elements(histogr[0,*]))
for i=0,n_elements(hist_mean)-1 do hist_mean[i]=mean(histogr[*,i])/10.
return,hist_mean
end

;plot,/polar,mean3,-(findgen(12)*15+7.5-90.)/180.*!pi,psym=4
