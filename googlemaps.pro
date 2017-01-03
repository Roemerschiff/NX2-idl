pro googlemaps,data,filename

nskip=5

openw,lu,filename+'.kml',/get_lun
printf,lu,'<?xml version="1.0" encoding="UTF-8"?>'
printf,lu,'<kml xmlns="http://earth.google.com/kml/2.2">'
printf,lu,'  <Document>'
printf,lu, data.zeit.day[1],data.Zeit.month[1],data.zeit.year[1],format="('  <name> Fahrtstrecke ',i2,'.',i2,'.',i4,'</name>')"
printf,lu,'  <description>Dies stellt die Fahrtstrecke der Galeere am angegebenen Tag dar. Sie sieht eckig aus, weil das GPS nur auf einige Meter genau ist. Ruder und Segelstrecken werden mit unterschiedlichen Farben angezeigt. Jede Strecke kann auf der Karte einzeln an- und ausgeschaltet werden. Bei jeder Strecke ist die Startzeit vermerkt.'
printf,lu,'Bei technischen Problemen der Messelektronik fehlen Stellen im Fahrtweg. '
printf,lu,'Fragen an: Moritz.guenther@hs.uni-hamburg.de</description>'
printf,lu,'    <Style id="yellowLine">'
printf,lu,'      <LineStyle>'
printf,lu,'        <color>7f00ffff</color>'
printf,lu,'        <width>4</width>'
printf,lu,'      </LineStyle>'
printf,lu,'    </Style>'
printf,lu,'    <Style id="redLine">'
printf,lu,'      <LineStyle>'
printf,lu,'        <color>7f0000ff</color>'
printf,lu,'        <width>4</width>'
printf,lu,'      </LineStyle>'
printf,lu,'    </Style>'


    printf,lu,'    <Folder>'
    printf,lu,'        <name>Ruderstrecke</name>'
    printf,lu,'      <description>Hier war das Segel nicht gesetzt, entweder wurde gerudert oder Pause gemacht.</description>' 
    printf,lu,'      <open>0</open>  '
    route=0
  
    for i=0L,n_elements(data.lat)-1,nskip do begin
      if data.lon[i] eq data.lon[i] and data.lat[i] eq data.lat[i] then begin
        if data.sailing[i] ne 1 and route eq 0 then begin  ;Beginn einer Ruderphase
          printf,lu,'      <Placemark>'
          printf,lu,'        <name>Ruderstrecke</name>'
          printf,lu,data.zeit.h[i], data.zeit.m[i],format="('        <description>Startzeit ',i2,':',i2,'</description>' )" 
          printf,lu,'        <styleUrl>#yellowLine</styleUrl>'
          printf,lu,'        <LineString>'
          printf,lu,'          <extrude>1</extrude>'
          printf,lu,'          <tessellate>1</tessellate>'
          printf,lu,'          <altitudeMode>absolute</altitudeMode>'
          printf,lu,'          <coordinates>'
          printf, lu,data.lon[i],data.lat[i],format='("          ",f10.7,",",f10.7,",0")'
          route=1
        endif
        ;regular case - in middle of route
        ;print only if coordinates have changed to keep files small
        if data.sailing[i] ne 1 and route eq 1 and (i+nskip lt n_elements(data.lat)-1 && data.lon[i] ne data.lon[i+nskip] or data.lat[i] ne data.lat[i+nskip]) then printf, lu,data.lon[i],data.lat[i],format='("          ",f10.7,",",f10.7,",0")'
        if (data.sailing[i] eq 1 or i+nskip ge n_elements(data.lat)-1) and route eq 1 then begin  ;Ende einer Ruderphase  
          printf,lu,'        </coordinates>'
          printf,lu,'      </LineString>'
          printf,lu,'    </Placemark>'
          route=0
        endif
      endif
    endfor
    printf,lu,'    </Folder>'  
    
    
  if n_elements(where(data.sailing eq 1)) gt nskip then begin
    printf,lu,'    <Folder>'
    printf,lu,'        <name>Segelstrecke</name>'
    printf,lu,'      <description>Segel gesetzt!</description>' 
    printf,lu,'      <open>0</open>  '
    route=0
    for i=0,n_elements(data.lat)-1,nskip do begin
      if data.lon[i] eq data.lon[i] and data.lat[i] eq data.lat[i] then begin
        if data.sailing[i] eq 1 and route eq 0 then begin  ;Beginn einer Ruderphase
          printf,lu,'      <Placemark>'
          printf,lu,'        <name>Segelstrecke</name>'
          printf,lu,data.zeit.h[i], data.zeit.m[i],format="('        <description>Startzeit ',i2,':',i2,'</description>' )" 
          printf,lu,'        <styleUrl>#redLine</styleUrl>'
          printf,lu,'        <LineString>'
          printf,lu,'          <extrude>1</extrude>'
          printf,lu,'          <tessellate>1</tessellate>'
          printf,lu,'          <altitudeMode>absolute</altitudeMode>'
          printf,lu,'          <coordinates>'
          printf, lu,data.lon[i],data.lat[i],format='("          ",f10.7,",",f10.7,",0")'
          route=1
        endif
        ;regular case - in middle of route
        ;print only if coordinates have changed to keep files small
        if data.sailing[i] eq 1 and route eq 1 and (i+nskip lt n_elements(data.lat)-1 && data.lon[i] ne data.lon[i+nskip] or data.lat[i] ne data.lat[i+nskip]) then printf, lu,data.lon[i],data.lat[i],format='("          ",f10.7,",",f10.7,",0")'
        if (data.sailing[i] ne 1 or i+nskip ge n_elements(data.lat)-1) and route eq 1 then begin  ;Ende einer Ruderphase  
          printf,lu,'        </coordinates>'
          printf,lu,'      </LineString>'
          printf,lu,'    </Placemark>'
          route=0
        endif
      endif
    endfor
    printf,lu,'    </Folder>'
   endif 
printf,lu,'  </Document>'
printf,lu,'</kml>'

free_lun,lu
end
