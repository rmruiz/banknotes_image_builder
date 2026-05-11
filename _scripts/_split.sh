#!/bin/bash
insta_dir="../_INSTAGRAM"

while getopts d:f: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
        f) splitfile=${OPTARG};;
    esac
done

if [ $OPTIND -eq 1 ]; then exit; fi
if [ "${directory: -1}" == "/" ]; then directory=${directory%?}; fi
echo "  Directory: $directory - File Prefix: $splitfile";

cd $directory
file_name="${directory}_${splitfile}.jpg"

if [ -f ${directory}__${splitfile}0.jpg ]; then
    echo "Skipping: ${directory}__${splitfile}0.jpg"
    exit
fi
#echo $file_name

h=$(identify -format "%h" $file_name)
w=$(identify -format "%w" $file_name)

#echo "  Dimensions: ${w}x${h}"
#3500(w) /2 -> 1750 /4*5 -> 2187 - 1725(h) -> 462
#3500(w) /3 -> 1666 /4*5 -> 2082 - 1725(h) -> 357 -> min -> winner

let s2="w/2/4*5-h"
let s3="w/3/4*5-h"
s2=${s2#-}
s3=${s3#-}

#echo "  S2: $s2, S3: $s3"

if [ $s2 -lt $s3 ]; then
    let ew="8"
    let eh="5"
else
    let ew="12"
    let eh="5"
fi
#echo "  Ratio: $ew/$eh"

# expand to proper ratio for splitting
let eh2="h/eh"
let ew2="w/ew"
#echo "  New Ratio: $ew2 : $eh2"

let dif="$eh2-$ew2"
dif=${dif#-}
#echo "  Difference: $dif"

if [ $eh2 -gt $ew2 ]; then
    #echo "expanding horizontally"
    let new_width="$dif*$ew+$w"
    magick $file_name -resize ${new_width}x${h} -background black -gravity center -extent ${new_width}x${h} tmp.jpg
else
    #echo "expanding vertically"
    let new_height="$dif*$eh+$h"
    magick $file_name -resize ${w}x${new_height} -background black -gravity center -extent ${w}x${new_height} tmp.jpg
fi
mkdir -p ${insta_dir}/${directory}

if [ $s2 -lt $s3 ]; then
    #echo "  Splitting in 2..."
    magick tmp.jpg -crop 50%x100% +repage +adjoin ${insta_dir}/${directory}/${directory}__${splitfile}%d.jpg
else
    #echo "  Splitting in 3..."
    magick tmp.jpg -crop 33.33%x100% +repage +adjoin ${insta_dir}/${directory}/${directory}__${splitfile}%d.jpg
fi

#identify -format "h%h w%w" ${directory}__${splitfile}0.jpg
#identify -format "h%h w%w" ${directory}__${splitfile}1.jpg
rm tmp.jpg
cd ..