#!/bin/bash
set -e
echo "Fetching episode list"
url="http://www.southpark.de/feeds/carousel/video/e3748950-6c2a-4201-8e45-89e255c06df1/30/1/json/!airdate/staffel-$1"
episodes=$(curl "$url" | grep '"default":' |
           sed -e 's/^.*default.*:.*"http/http/g' -e 's/" *, *$//g')
seasonpath=$(printf "%02d" $1)
mkdir -p "S$1"
cd "S$1"

echo "Downloading episodes"
~/youtube-dl -i $episodes
cd ..
echo "Merging episodes"
./join_acts.sh "S$1"
