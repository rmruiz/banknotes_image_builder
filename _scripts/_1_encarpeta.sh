#!/usr/bin/env zsh

num=0

while true; do
  jpgs=( *.jpg(N) )   # (N) = si no hay matches, queda vacío (no error)
  (( ${#jpgs} == 0 )) && break

  num=$((num+1))
  folder="../_step2/Nuevos$num"

  [[ -d "$folder" ]] && continue

  mkdir "$folder"

  mv -- "$jpgs[1]" "$folder"
  (( ${#jpgs} >= 2 )) && mv -- "$jpgs[2]" "$folder"
done
