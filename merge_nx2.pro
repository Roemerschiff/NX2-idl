function merge_NX2, a0,A1,A2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20


if n_elements(a2) ne 0 then begin
  return, merge_nx2(merge_nx2(A0,A1),a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
endif else begin
  if n_elements(a1) ne 0 then begin
       sum=n_elements(a0.cog)+n_elements(a1.cog)
       tname=tag_names(a1)
       returnstr=create_struct('loc_time',[a0.loc_time,a1.loc_time])
       for i =1,n_elements(tname)-1 do begin
         case tname[i] of
           'HEADER': returnstr=add_tag(returnstr,a0.(i),tname[i])
           'ZEIT': begin
             zeit=jul2time(returnstr.loc_time)
             returnstr=add_tag(returnstr,zeit,tname[i])
             end
           else: returnstr=add_tag(returnstr,[a0.(i),a1.(i)],tname[i])
         endcase
       endfor
       return,returnstr
  endif else begin
    if n_elements(a0) ne 0 then return,a0 else message,'give NX2 Data to merge! '
  endelse
endelse
end 
