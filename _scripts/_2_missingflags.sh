#!/usr/bin/env zsh

old=""

for d in */; do
  file_pattern="${d%%_*}"

  if [[ "$old" != "$file_pattern" ]]; then
    flag="../_flags/FLAG_${file_pattern}.jpg"

    if [[ ! -f "$flag" ]]; then
      echo "$flag NOT FOUND"
    fi

    old="$file_pattern"
  fi
done
