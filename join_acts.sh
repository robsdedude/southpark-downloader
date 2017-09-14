#!/bin/bash
set -e

find $1 -maxdepth 1 -iname "*.mp4" | rename 's/–/-/g'
find $1 -maxdepth 1 -iname "*.mp4" | rename 's/\s+/ /g'

OIFS="$IFS"
IFS=$'\n'
acts1=$(find $1 -maxdepth 1 -iregex ".*\(Act 1\|1\. Akt\|1. Ak-\|Akt 1\|Teil 1\).*")
parts=$(echo $1 | sed -e 's/\/*$//')"/parts/"
mkdir -p $parts
echo "acts1: $acts1"
for fn in $acts1; do
    echo "fn: $fn"
    pathpattern=$(echo "$fn" | sed -e 's/Act 1.*\.mp4\|1\. Akt.*\.mp4\|1. Ak-.*\.mp4\|Akt 1.*\.mp4\|Teil 1.*\.mp4/*.mp4/')
    echo "pathpattern: $pathpattern"
    pattern=$(echo "$pathpattern" | rev | cut -d/ -f1 | rev)
    echo "pattern: $pattern"
    group=$(find $1 -maxdepth 1 -iname "$pattern" | sort)
    echo "group: $group"
    outfn=$(echo "$pathpattern" | sed -e 's/[ -]*\*\.mp4$/.mp4/')
    echo "outfn: $outfn"
    catargs=$(echo "$group" | sed -e 's/^/-cat "/g' -e 's/$/"/g' | tr '\n' ' ')
    echo "catargs: $catargs"
    bash -c "MP4Box $catargs -new \"$outfn\""
    mv $group $parts
    echo
done
IFS="$OIFS"

exit 0
# run this part of the script after making sure that the southpart guys didn't
# mess up the naming of the episone acts (because that happes frequently)

echo "Normalize file names"
declare -a months=(January February March April May June July August September October November December)
for ((i = 0; i < ${#months[@]}; ++i)); do
    month=${months[$i]}
    find $1 -maxdepth 1 -iname "*$month*.mp4" | rename "s/(.*)$month(.*)/\${1}$(printf "%02d" $((i+1)))\$2/i";
    rename 's/South Park_(\d{2})\D*(\d{2})\D*(\d{4})(.*)/South Park_$3-$1-$2$4/' "$1/South Park_"*.mp4
done

