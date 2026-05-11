#!/usr/bin/env zsh

for d in */; do
  ../_scripts/_append_text.sh -d "$d"
done
