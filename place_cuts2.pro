;+
; NAME:
;       SCHNITTMENGE
;
; PURPOSE:
;       This function returens the intersection of two (index) arrays
;
; CATEGORY:
;       auxilary
;
; CALLING SEQUENCE:
;       Result=SCHNITTMENGE(a0,a1)
;
; INPUTS:
;       up to 10 (index) arrays
;
; OUTPUTS:
;       intersection of all arrays
;
; PROCEDURE:
;	Schnittmenge works recursively splitting the input until only two arrays input, which are then compared
;	elements by element. Exspecially for input arrays of vary different size this routine can be speed up considerably if always the smalleest 
;	array is used as reference
;
; EXAMPLE:
;       result=SCHNITTMENGE([1,2,3,6],[3,6,9])
;	print, result -> 3 6
;
; MODIFICATION HISTORY:
;       Written by:    Moritz Guenther, 15.12.2006
;- 

function schnittmenge,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19
;if n_elements(a2) lt n_elements (a1) then swap theses arrays, -> better use pointers
;elem=[n_elements(a0),n_elements(a1),n_elements(a2),n_elements(a3),n_elements(a4),n_elements(a5),n_elements(a6),n_elements(a7),n_elements(a8),n_elements(a9)]
params=ptrarr(20,/allocate_heap)
if n_elements(a0) ne 0 then *params[0]=a0
if n_elements(a1) ne 0 then *params[1]=a1
if n_elements(a2) ne 0 then *params[2]=a2
if n_elements(a3) ne 0 then *params[3]=a3
if n_elements(a4) ne 0 then *params[4]=a4
if n_elements(a5) ne 0 then *params[5]=a5
if n_elements(a6) ne 0 then *params[6]=a6
if n_elements(a7) ne 0 then *params[7]=a7
if n_elements(a8) ne 0 then *params[8]=a8
if n_elements(a9) ne 0 then *params[9]=a9
if n_elements(a10) ne 0 then *params[10]=a10
if n_elements(a11) ne 0 then *params[11]=a11
if n_elements(a12) ne 0 then *params[12]=a12
if n_elements(a13) ne 0 then *params[13]=a13
if n_elements(a14) ne 0 then *params[14]=a14
if n_elements(a15) ne 0 then *params[15]=a15
if n_elements(a16) ne 0 then *params[16]=a16
if n_elements(a17) ne 0 then *params[17]=a17
if n_elements(a18) ne 0 then *params[18]=a18
if n_elements(a19) ne 0 then *params[19]=a19
elem=make_array(20)
for i=0,19 do elem[i]=n_elements(*params[i])
sorted_param=reverse(sort(elem))
number_params=n_elements(where(elem ne 0))


CASE number_params of
  ;smallest_array=min(elem,min_index)
  0: return,-1
  1: return,*params[sorted_param[0]]
  2: begin 
      for i=0,n_elements(*params[sorted_param[1]])-1 do if where(*params[sorted_param[1]] eq (*params[sorted_param[0]])[i]) ne -1 then schnitt=n_elements(schnitt) eq 0 ? (*params[sorted_param[0]])[i] : [schnitt,(*params[sorted_param[0]])[i]]
      return,schnitt
     end
  else: return, schnittmenge(schnittmenge(*params[sorted_param[2]],*params[sorted_param[1]]),*params[sorted_param[0]],*params[sorted_param[3]],*params[sorted_param[4]],*params[sorted_param[5]],*params[sorted_param[6]],*params[sorted_param[7]],*params[sorted_param[8]],*params[sorted_param[9]],*params[sorted_param[10]],*params[sorted_param[11]],*params[sorted_param[12]],*params[sorted_param[13]],*params[sorted_param[14]],*params[sorted_param[15]],*params[sorted_param[16]],*params[sorted_param[17]],*params[sorted_param[18]],*params[sorted_param[19]])
endcase
;   return, schnittmenge(schnittmenge(a0,a1),a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19)
; endif else begin
;   if n_elements(a1) ne 0 then begin
;     for i=0,n_elements(a0)-1 do if where(a1 eq a0[i]) ne -1 then schnitt=n_elements(schnitt) eq 0 ? a0[i] : [schnitt,a0[i]]
;     return,schnitt
;   endif else begin
;     if n_elements(a0) ne 0 then return,a0 else return,-1
;   endelse
; endelse

end  
;+
; NAME:
;       PLACE_CUTS
;
; PURPOSE:
;       This function returns the time indices of the NX_2 data, where some given parameters did not change to much 
;	just before the measurement
;
; CATEGORY:
;       data seclction
;
; CALLING SEQUENCE:
;       Result=place_cuts
;
; INPUTS:
;       data:  NX_2 data from read_nx2
;      
; KEYWORD PARAMETERS:
;	This is what makes this function do things. The keywords allow to specify selection criteria.
;	Each keyword is given as array with [value, allowed variation, in time in seconds]
;	e.g. bsp=[2.,0.1,30] requires that the bsp did not deviate by more then 10% in the last 30 seconds from 2.0
;       
;
; OUTPUTS:
;       index array of meassurement points, which match all conditions
;
; EXAMPLE:
;       result=PLACE_CUTS(data,bsp=[2.,.1,20])
;
; MODIFICATION HISTORY:
;       Written by:    Moritz Guenther, 15.12.2006
;- 

function place_cuts,data,sailing=sailing, bsp=bsp , awa=awa, aws=aws,tws=tws,hdc=hdc,rowpermin=rowpermin,constant_couse=constant_course;,... und einige mehr, wenn die routine erst einmal läuft

if n_elements(bsp) eq 3 then begin
  bsp_result=-1
  index=where(data.bsp gt (bsp[0]*(1.-bsp[1])) and data.bsp lt (bsp[0]*(1.+bsp[1])))
  for i=bsp[2], n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(bsp[2])),index[i-(bsp[2]-1):i]) then bsp_result = bsp_result[0] eq -1 ? index[i] : [bsp_result,index[i]]
  print,'BSP',n_elements(bsp_result)
endif

if n_elements(awa) eq 3 then begin
  awa_result=-1
  index=where(data.awa gt (awa[0]*(1.-awa[1])) and data.awa lt (awa[0]*(1.+awa[1])))
  for i=awa[2], n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(awa[2])),index[i-(awa[2]-1):i]) then awa_result = awa_result[0] eq -1 ? index[i] : [awa_result,index[i]]
print,'AWA',n_elements(awa_result)
endif

if n_elements(sailing) eq 3 then begin
  sailing_result=-1
  index=where(data.sailing eq sailing[0])
  for i=sailing[2], n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(sailing[2])),index[i-(sailing[2]-1):i]) then sailing_result = sailing_result[0] eq -1 ? index[i] : [sailing_result,index[i]]
print,'Sailing',n_elements(sailing_result)
endif

if n_elements(aws) eq 3 then begin
  aws_result=-1
  index=where(data.aws gt (aws[0]*(1.-aws[1])) and data.aws lt (aws[0]*(1.+aws[1])))
  for i=aws[2], n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(aws[2])),index[i-(aws[2]-1):i]) then aws_result = aws_result[0] eq -1 ? index[i] : [aws_result,index[i]]
print,'AWS',n_elements(aws_result)
endif

if n_elements(tws) eq 3 then begin
  tws_result=-1
  index=where(data.tws gt (tws[0]*(1.-tws[1])) and data.tws lt (tws[0]*(1.+tws[1])))
  for i=tws[2], n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(tws[2])),index[i-(tws[2]-1):i]) then tws_result = tws_result[0] eq -1 ? index[i] : [tws_result,index[i]]
print,'TWS',n_elements(tws_result)
endif

if n_elements(hdc) eq 3 then begin
  hdc_result=-1
  index=where(data.hdc gt (hdc[0]*(1.-hdc[1])) and data.hdc lt (hdc[0]*(1.+hdc[1])))
  for i=hdc[2], n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(hdc[2])),index[i-(hdc[2]-1):i]) then hdc_result = hdc_result[0] eq -1 ? index[i] : [hdc_result,index[i]]
print,'HDC',n_elements(hdc_result)
endif

if n_elements(rowpermin) eq 3 then begin
  rowpermin_result=-1
  index=where(data.rowpermin ge (rowpermin[0]*(1.-rowpermin[1])) and data.rowpermin le (rowpermin[0]*(1.+rowpermin[1])))
  for i=rowpermin[2], n_elements(index)-1 do if array_equal(reverse(index[i]-indgen(rowpermin[2])),index[i-(rowpermin[2]-1):i]) then rowpermin_result = rowpermin_result[0] eq -1 ? index[i] : [rowpermin_result,index[i]]
print,'ROWPERMIN',n_elements(rowpermin_result)
endif

if n_elements(constant_course) eq 3 then begin
  constant_course_result=-1
  for i=constant_course[2], n_elements(data.cog)-1 do if (max(abs(data.cog[i]-data.cog[i-constant_course[2]:i])) le constant_course[1]) then      constant_course_result = constant_course_result[0] eq -1 ? i : [constant_course_result,i]
print,'constant_course',n_elements(constant_course_result)
endif

return, schnittmenge(bsp_result,awa_result,sailing_result,aws_result,tws_result,hdc_result,rowpermin_result,cog_result,constant_course_result)
end