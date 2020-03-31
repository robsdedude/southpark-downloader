#!/bin/bash
set -e

DEBUG=${2:-false}
if [ $DEBUG == true ]; then
    echo "It's debug time!"
fi

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
    if [ $(echo "$group" | wc -l) -lt 3 ]; then
        echo "Couldn't find 3 or more acts matching the act $group"
        continue
    fi
    if [ $DEBUG != true ]; then
        ffmpeg -f concat -safe 0 \
               -i <(for f in $group; do printf "file '${PWD}/%s'\n" $(echo "$f" | sed -r "s/'/'\\\''/g"); done) \
               -c copy "$outfn"
    else
        touch ${outfn}
    fi
    mv $group $parts
    echo
done
IFS="$OIFS"

if [ $DEBUG == false ]; then
    :
    exit 0
fi
# run this part of the script after making sure that the South Park guys didn't
# mess up the naming of the episode acts (because that happens frequently)

echo "Normalize file names"
declare -a months=(January February March April May June July August September October November December)
for ((i = 0; i < ${#months[@]}; ++i)); do
    month=${months[$i]}
    find $1 -maxdepth 1 -iname "*$month*.mp4" | rename "s/(.*)$month(.*)/\${1}$(printf "%02d" $((i+1)))\$2/i"
done
rename 's/South Park_(\d{2})\D*(\d{2})\D*(\d{4})(.*)/South Park_$3-$1-$2$4/' "$1/South Park_"*.mp4
rename 's/(South Park)_(\d{4}-\d{2}-\d{2})_.*?(\d{2})(\d{2}).* - (.*)/$1_S$3E$4_$2 - $5/' "$1/South Park_"*.mp4

