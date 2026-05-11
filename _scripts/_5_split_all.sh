#!/bin/bash

for d in */
do
    [[ $d == _* ]] && continue
    [[ $d == zz* ]] && continue
    ./_scripts/_split.sh -d $d -f "A"
    ./_scripts/_split.sh -d $d -f "B"
done
