for d in */
do
    cd $d
    echo "Going inside "$d
    file_pattern=${d%?}
    file_A=$file_pattern"_A.jpg"
    file_B=$file_pattern"_B.jpg"
    if [ ! -f "$file_A" ] || [ ! -f "$file_B" ]
    then
        cd ..
        echo "ERROR: $file_A or $file_B not found."
        continue
    fi

    joined_file=$file_pattern"_Full.jpg"
    if [ ! -f "$joined_file" ]
    then
        convert -append $file_A $file_B $joined_file
    else
        echo "WARN: joined file $joined_file already exists."
    fi

    cd ..
    echo "_done_"
done
