;+
; NAME:
;       SCHNITTMENGE
;
; PURPOSE:
;       This function returns the intersection of two (index) arrays
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
;       22.04.2008     changed algorithm to use histograms, hoping to speed up the process - HMG
;- 

function schnittmenge,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19
;if n_elements(a2) lt n_elements (a1) then swap theses arrays, -> better use pointers
;elem=[n_elements(a0),n_elements(a1),n_elements(a2),n_elements(a3),n_elements(a4),n_elements(a5),n_elements(a6),n_elements(a7),n_elements(a8),n_elements(a9)]
if n_elements(a2) ne 0 then begin
  return, schnittmenge(schnittmenge(a0,a1),a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19)
endif else begin
  if n_elements(a1) ne 0 then begin
    if a0[0] eq -1 or a1[0] eq -1 then begin
      return,-1
    endif else begin
    ;for i=0,n_elements(a0)-1 do if where(a1 eq a0[i]) ne -1 then schnitt=n_elements(schnitt) eq 0 ? a0[i] : [schnitt,a0[i]]
    ;if n_elements(schnitt) ne 0 then return,schnitt else return,-1
    ;check if a0 and a1 are arrays
    if n_elements(a0) eq 1 then a0=[a0]
    if n_elements(a1) eq 1 then a1=[a1]
    return,where(histogram(a0,OMIN=om) gt 0 AND histogram(a1,MIN=om) gt 0)+om
   endelse
  endif else begin
    if n_elements(a0) ne 0 then return,a0 else return,-1
  endelse
endelse
end 


 