#!/usr/bin/env zsh

# renombra archivos dentro de la carpeta: nombrecarpeta_A.jpg / nombrecarpeta_B.jpg

for directorio in */; do
  [[ "$directorio" == _* ]] && continue

  cleandir="${directorio%/}"   # quita el / final
  targetA="${cleandir}/${cleandir}_A.jpg"
  targetB="${cleandir}/${cleandir}_B.jpg"

  # obtener jpg dentro de la carpeta
  jpgs=( "$cleandir"/*.jpg(N) )

  if (( ${#jpgs} < 2 )); then
    echo "Not enough jpg files in $cleandir"
    continue
  fi

  mv -- "$jpgs[1]" "$targetA"
  mv -- "$jpgs[2]" "$targetB"
  mv -- "$cleandir" ../_step3/
done
