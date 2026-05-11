#!/usr/bin/env zsh

set -u

if ! command -v gsed >/dev/null 2>&1; then
  echo "ERROR: gsed is not installed. try 'brew install gsed'"
  exit 1
fi
if ! command -v magick >/dev/null 2>&1; then
  echo "ERROR: magick is not installed. try 'brew install imagemagick'"
  exit 1
fi

format="jpg"
tmp_dir="/tmp"
flag_dir="../_flags"
full_dir="./_FULL"
insta_dir="./_INSTAGRAM"

directory=""

while getopts "d:" flag; do
  case "$flag" in
    d) directory="$OPTARG" ;;
  esac
done

[[ -z "$directory" ]] && exit 1

# quitar slash final si viene como "carpeta/"
directory="${directory%/}"

echo "Directory: $directory"

# split por "_"
a=( ${(s:_:)directory} )

i=1  # en zsh arrays parten en 1

flag_name="${flag_dir}/FLAG_${a[$i]}.jpg"
if [[ ! -f "$flag_name" ]]; then
  echo "FATAL: Flag not found - $flag_name"
  exit 1
fi

echo "  flag: $flag_name"

pais="${a[$i]//./ }"

# lowercase + capitalizar palabras usando gsed
pais=$(echo "$pais" | gsed -e 's/\(.*\)/\L\1/' | gsed -r 's/\<./\U&/g')

# fixes manuales
pais="${pais/ De / de }"
pais="${pais/ Y / y }"
pais="${pais/ñA/ña}"
pais="${pais/Afganistan/Afganistán}"
pais="${pais/Belgica/Bélgica}"
pais="${pais/Brunei/Brunéi}"
pais="${pais/Canada/Canadá}"
pais="${pais/Haiti/Haití}"
pais="${pais/Hungria/Hungría}"
pais="${pais/Iran/Irán}"
pais="${pais/Japon/Japón}"
pais="${pais/Kazajistan/Kazajistán}"
pais="${pais/Libano/Líbano}"
pais="${pais/Mali/Malí}"
pais="${pais/Mexico/México}"
pais="${pais/Panama/Panamá}"
pais="${pais/Peru/Perú}"
pais="${pais/Republica/República}"
pais="${pais/Tunez/Túnez}"
pais="${pais/Turquia/Turquía}"
pais="${pais/Union/Unión}"
pais="${pais/Uzbekistan/Uzbekistán}"

echo "  pais: $pais"

(( i++ ))

if (( ${#a[$i]} < 4 )); then
  (( i++ ))
fi

moneda="${a[$i]//./ }"
moneda="${moneda/Dolar/Dólar}"
moneda="${moneda/Bolivar/Bolívar}"
moneda="${moneda/Centimo/Céntimo}"
moneda="${moneda/Cordoba/Córdoba}"
moneda="${moneda/Guarani/Guaraní}"
moneda="${moneda/Karbovan/Karbóvan}"
moneda="${moneda/Tolar/Tólar}"
moneda="${moneda/Dolare/Dólare}"

moneda=$(echo "$moneda" | gsed ':a;s/\B[0-9]\{3\}\>/\.&/;ta')

echo "  moneda: $moneda"

(( i++ ))
year="${a[$i]//./ }"

echo "  año: $year"

line4=""

if [[ "$pais" == "Chile" || "$pais" == "Estados Unidos" ]]; then
  (( i++ ))
  line4="${a[$i]//./ }"
fi

[[ -n "$line4" ]] && echo "  Apellidos/Estados: $line4"

line1="$pais"
line2="$moneda - $year"
line3="banknotes.cl@gmail.com"

line1_size=120
line2_size=80
apellido_size=60
line3_size=30

side_a="${directory}/${directory}_A.jpg"
side_b="${directory}/${directory}_B.jpg"

if [[ ! -f "$side_a" || ! -f "$side_b" ]]; then
  echo "FATAL: Missing side images: $side_a / $side_b"
  exit 1
fi

google_name="${full_dir}/${directory}_Full_with_text.${format}"
final_name="${insta_dir}/${directory}/${directory}___InstagramSize.${format}"

if [[ -f "${insta_dir}/${directory}/uploaded" ]]; then
  echo "ALREADY UPLOADED: ${insta_dir}/${directory}/uploaded"
fi
[[ -f "$final_name" ]] && echo "REWRITING: $final_name exists"
[[ -f "$google_name" ]] && echo "REWRITING: $google_name exists"

echo "  creating $google_name"
echo "  creating $final_name"

# tmp files únicos (evita pisarse)
tmp_prefix="${tmp_dir}/append_text_${directory}_$$"
line1_img="${tmp_prefix}_line1.${format}"
line2_img="${tmp_prefix}_line2.${format}"
line3_img="${tmp_prefix}_line3.${format}"
line4_img="${tmp_prefix}_line4.${format}"
line12_img="${tmp_prefix}_line12.${format}"
box_img="${tmp_prefix}_box.${format}"
flag2_img="${tmp_prefix}_flag2.${format}"
name_img="${tmp_prefix}_name.${format}"
mask_img="${tmp_prefix}_mask.${format}"
tmp_a_img="${tmp_prefix}_tmp_a.${format}"
tmp_b_img="${tmp_prefix}_tmp_b.${format}"
tmp_a1_img="${tmp_prefix}_tmp_a1.${format}"
tmp_b1_img="${tmp_prefix}_tmp_b1.${format}"
tmp_join_img="${tmp_prefix}_tmp.${format}"
name_border_img="${tmp_prefix}_name_border.${format}"

cleanup() {
  rm -f \
    "$line1_img" "$line2_img" "$line3_img" "$line4_img" \
    "$line12_img" "$box_img" "$flag2_img" "$name_img" \
    "$mask_img" "$tmp_a_img" "$tmp_b_img" "$tmp_a1_img" \
    "$tmp_b1_img" "$tmp_join_img" "$name_border_img"
}
trap cleanup EXIT

# crear labels
magick -background black -fill white -font Verdana -pointsize $line1_size label:"$line1" "$line1_img"
magick -background black -fill white -font Verdana -pointsize $line2_size label:"$line2" "$line2_img"

if [[ -n "$line4" ]]; then
  magick -background black -fill white -font Verdana -pointsize $apellido_size label:"$line4" "$line4_img"
fi

magick -background black -fill white -font Verdana -pointsize $line3_size label:"$line3" "$line3_img"

magick -background black -gravity west "$line1_img" "$line2_img" -append "$line12_img"

if [[ -n "$line4" ]]; then
  magick -background black -gravity west "$line12_img" "$line4_img" -append "$line12_img"
fi

magick -background black -gravity east "$line12_img" "$line3_img" -append "$box_img"

# flag al lado
h=$(identify -ping -format '%h' "$box_img")
magick "$flag_name" -resize ${h}x6000 "$flag2_img"

magick "$flag2_img" \
  -bordercolor black  -border 1 \
  -bordercolor white  -border 6 \
  -bordercolor grey60 -border 1 \
  -background black \( +clone -shadow 60x4+4+4 \) +swap \
  -background none -flatten \
  "$flag2_img"

magick -background black "$box_img" "$flag2_img" -gravity east -splice 10x0+0+0 +append "$name_img"
magick "$name_img" -gravity east +repage -chop 10x0+0+0 "$name_img"

# rounded corners side A
h=$(identify -ping -format '%h' "$side_a")
w=$(identify -ping -format '%w' "$side_a")
magick -size ${w}x${h} xc:none -draw "roundrectangle 0,0,${w},${h},20,20" "$mask_img"
magick "$side_a" -alpha Set "$mask_img" -compose DstIn -composite "$tmp_a_img"
magick "$tmp_a_img" -bordercolor black -border 50x50 "$tmp_a1_img"

# rounded corners side B
h=$(identify -ping -format '%h' "$side_b")
w=$(identify -ping -format '%w' "$side_b")
magick -size ${w}x${h} xc:none -draw "roundrectangle 0,0,${w},${h},20,20" "$mask_img"
magick "$side_b" -alpha Set "$mask_img" -compose DstIn -composite "$tmp_b_img"
magick "$tmp_b_img" -bordercolor black -border 50x50 "$tmp_b1_img"

# resize text box al ancho correcto
h=$(identify -ping -format '%h' "$side_a")
w=$(identify -ping -format '%w' "$side_a")

borde=50
wf=$(( w - 2*borde ))

magick "$name_img" -resize ${wf}x${h} "$name_border_img"

# join
magick "$tmp_a1_img" "$name_border_img" -background black -gravity south -append "$tmp_join_img"
magick "$tmp_join_img" "$tmp_b1_img" -background black -gravity south -append "$google_name"

# resize google output
magick "$google_name" -resize 1080x1350 "$google_name"

mkdir -p "${insta_dir}/${directory}"

h=$(identify -ping -format '%h' "$google_name")
w=$(identify -ping -format '%w' "$google_name")

new_h=$(( w * 5 / 4 ))

if (( new_h > h )); then
  magick "$google_name" -trim -background black -gravity center -extent ${w}x${new_h} "$final_name"
else
  new_w=$(( h * 4 / 5 ))
  magick "$google_name" -trim -background black -gravity center -extent ${new_w}x${h} "$final_name"
fi

