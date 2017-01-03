;+
; PROJECT:
;	NX_2
; NAME:
;	wann
;
; PURPOSE:
;	timeselection of data
;
; CATEGORY:
;	mixed
;
; CALLING SEQUENCE:
;	RESULT=wann(zeit,stunde,minute[,sekunde],day=day)
;
; INPUTS:
;	zeit	:zeit structure with at least three fileds 
;				.h hours
;				.m minutes
;				.s seconds
;	stunde:	hour to select, may be single integer or array [lower bound, upper bound]
;	min:	minute to select, may be single integer or array [lower bound, upper bound]
;
; OPTIONAL INPUTS:
;	sekunde:	second to select, may be single integer or array [lower bound, upper bound]
;
; KEYWORDS:
;	day:  day to select, may be single integer or array [lower bound, upper bound]
;
; EXAMPLE:
;	result=wann(zeit,2,[3,15])
;
; TEST STATUS:
;	not tested
;
; MODIFICATION HISTORY:
;	Written by:	Moritz G�nther 02.08.2006
;       23.04.2008 fixed bug, that returned only 4:20-4:40 and 5:20-5:40 for wann(zeit,[4,5],[20,40])
;-

function wann,zeit,stunde,minute,sekunde,day=day

n_h=n_elements(stunde)
n_m=n_elements(minute)
n_s=n_elements(sekunde)
n_d=n_elements(day)
case n_params() of 
 4: begin
      if n_elements(day) eq 0 then begin
        early=min(where(zeit.h ge stunde[0] and zeit.m ge minute[0] and zeit.s ge sekunde[0]))
        late= max(where(zeit.h le stunde[n_h-1] and zeit.m le minute[n_m-1] and zeit.s le sekunde[n_s-1]))
      endif else begin
        early=min(where(zeit.h ge stunde[0] and zeit.m ge minute[0] and zeit.s ge sekunde[0] and zeit.day eq day))
        late= max(where(zeit.h le stunde[n_h-1] and zeit.m le minute[n_m-1] and zeit.s le sekunde[n_s-1] and zeit.day eq day))
      endelse
    end
 3: begin
      if n_elements(day) eq 0 then begin
        early=min(where(zeit.h ge stunde[0] and zeit.m ge minute[0]))
        late= max(where(zeit.h le stunde[n_h-1] and zeit.m le minute[n_m-1]))
      endif else begin
        early=min(where(zeit.h ge stunde[0] and zeit.m ge minute[0] and zeit.day eq day))
        late= max(where(zeit.h le stunde[n_h-1] and zeit.m le minute[n_m-1] and zeit.day eq day))
      endelse
    end
 else: begin
 ;---Paramter anzahl ist nicht zul�ssig
    print,'%wann.pro: Eingabe Zeit, Stunde, Minute n�tig!'
    return, -2 
  end   
endcase
;check for existence
if early eq -1 or late eq -1 or early gt late then return,-1 else return, indgen(late-early+1)+early
end


