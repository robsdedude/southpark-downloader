#!/bin/bash
set -e

OIFS="$IFS"
IFS=$'\n'
acts1=$(find $1 -maxdepth 1 -iregex ".*\(Act 1\|1\. Akt\|1. Ak-\).*")
parts=$(echo $1 | sed -e 's/\/*$//')"/parts/"
mkdir -p $parts
echo "acts1: $acts1"
for fn in $acts1; do
    echo "fn: $fn"
    pattern=$(echo $fn | sed -e 's/Act [0-9]\+.*\.\|[0-9]\+\. Akt.*\.\|[0-9]\+. Ak-.*\./*./')
    echo "pattern: $pattern"
    pattern=$(echo "$pattern" | rev | cut -d/ -f1 | rev)
    echo "pattern2: $pattern"
    group=$(find $1 -maxdepth 1 -iname "$pattern" | sort)
    echo "group: $group"
    outfn=$(echo "$fn" | sed -e 's/[ -]*Act [0-9]\+.*$\|[ -]*[0-9]\+\. Akt.*$/.mp4/')
    echo "outfn: $outfn"
    catargs=$(echo "$group" | sed -e 's/^/-cat "/g' -e 's/$/"/g' | tr '\n' ' ')
    echo "catargs: $catargs"
    bash -c "MP4Box $catargs -new \"$outfn\""
    mv $group $parts
    echo
done
IFS="$OIFS"

echo "Normalize file names"
declare -a months=(January February March April May June July August September October November December)
for ((i = 0; i < ${#months[@]}; ++i)); do
    month=${months[$i]}
    find $1 -maxdepth 1 -iname "*$month*.mp4" | rename "s/(.*)$month(.*)/\${1}$(printf "%02d" $((i+1)))\$2/i";
    rename 's/South Park_(\d{2})\D*(\d{2})\D*(\d{4})(.*)/South Park_$3-$1-$2$4/' $1/South\ Park_*.mp4
done

