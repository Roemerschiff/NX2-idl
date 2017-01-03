function jul2time, juldate
  n=n_elements(juldate)
  result={day:make_array(n),h:make_array(n),m:make_array(n),s:make_array(n),month:make_array(n),year:make_array(n)}
  for i=0L,n-1 do begin
    caldat,juldate[i],month,day,year,hour,minute,second
    result.day[i]=day
    result.h[i]=hour
    result.m[i]=minute
    result.s[i]=second
    result.month[i]=month
    result.year[i]=year
  endfor  
return,result
end