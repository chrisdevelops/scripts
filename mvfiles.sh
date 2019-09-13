#!/usr/bin/env bash
declare -a months=(
    "January"
    "February"
    "March"
    "April"
    "May"
    "June"
    "July"
    "August"
    "September"
    "October"
    "November"
    "December"
)

for dir in */
    do
       # enter directory
        cd "$dir"
        # make sub-directories (1-12 - for Jan to Dec)
        mkdir {1..12}
        # cycle through months array (key/value pair)
        for idx in "${!months[@]}"
            do
                # Shift index to reference sub-directories 
                subdir="$(($idx + 1))"
                # move files into sub-directories
                # e.g. mv blah-January-blah.txt 1/
                mv *"${months[$idx]}"* "$subdir"
                # rename sub-directories to months
                # e.g. mv 1/ January/
                mv "$subdir" "${months[$idx]}"
            done
        cd ../
    done
