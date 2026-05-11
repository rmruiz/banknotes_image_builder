#!/bin/bash

line1="Macao (China)"
line2="10 Patacas - 2022"
line3="banknotes.cl@gmail.com"
convert -background black -fill white \
          -font Verdana -pointsize 120 label:"$line1" \
          line1.png
convert -background black -fill white \
          -font Verdana -pointsize 80 label:"$line2" \
          line2.png
convert -background black -fill white \
          -font Verdana -pointsize 30 label:"$line3" \
          line3.png

convert -gravity west -append line1.png line2.png line12.png
rm line1.png line2.png
convert -gravity east -append line12.png line3.png box.png
rm line12.png line3.png

h=$(identify -ping -format '%h' box.png)

convert FLAG_CHINA.jpg -resize ${h}x6000 flag2.jpg
convert box.png flag2.jpg -gravity east -splice 100x0+0+0 +append name.png
rm box.png flag2.jpg
convert name.png -gravity east +repage -chop 100x0+0+0 name.png

convert name.png -bordercolor black -border 50x50 name_border.png
rm name.png

h=$(identify -ping -format '%h' name_border.png)
w=$(identify -ping -format '%w' name_border.png)

convert -size ${w}x${h} xc:none -draw "roundrectangle 0,0,${w},${h},20,20" mask.png
convert name_border.png -matte mask.png -compose DstIn -composite final.png
rm name_border.png mask.png

  ####
h=$(identify -ping -format '%h' MACAO_10.Petacas_2022_Full.jpg)
w=$(identify -ping -format '%w' MACAO_10.Petacas_2022_Full.jpg)

borde=350
let "wf=$w-2*$borde"
convert final.png -resize ${wf}x${h} final_resized.png

magick MACAO_10.Petacas_2022_Full.jpg final_resized.png -geometry +0+50 -gravity south -define compose:args=80,100 -compose dissolve -composite MACAO_10.Petacas_2022_Full_with_text.jpg
rm final_resized.png final.png


