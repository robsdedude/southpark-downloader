#!/bin/bash
set -e

DEBUG=false

url_de='https://www.southpark.de/feeds/carousel/video/e3748950-6c2a-4201-8e45-89e255c06df1/30/1/json/!airdate/staffel-'${1}
url_en='https://southpark.cc.com/feeds/carousel/video/6154fc40-b7a3-4387-94cc-fc42fc47376e/30/1/json/!airdate/season-'${1}
url_es='https://southpark.cc.com/feeds/carousel/video/351c1323-0b96-402d-a8b9-40d01b2e9bde/30/1/json/!airdate/temporada-'${1}'?lang=es'

lang=${2}
echo "language: \"${lang}\""
case ${lang} in
  "en")
    echo 'Selected language: English'
    url=${url_en}
    ;;
  "de")
    echo 'Selected language: German'
    url=${url_de}
    ;;
  "es")
    echo 'Selected language: Spanish'
    url=${url_es}
    ;;
  *)
    echo 'Selected language unknown: chose one of "en" (default), "de", or "es".'
    exit 1
    ;;
esac
echo "Fetching episode list"
if [ $DEBUG == true ]; then
    echo "URL: $url"
fi
episodes=$(curl -L "$url" | grep '"default":' |
           sed -e 's/^.*default.*:.*"https/https/g' -e 's/" *, *$//g')

episodes_filter=$(echo $(echo ${@:3} | xargs -n1 printf "s%02de%02d " ${1}) | sed 's/ /\\|/g')
episodes=$(echo $episodes | tr ' ' '\n' | grep ${episodes_filter})
seasonpath="S$(printf "%02d" "${1}")_${lang}"
if [ $DEBUG == true ]; then
    seasonpath="${seasonpath}_dbg"
fi
mkdir -p ${seasonpath}
cd ${seasonpath}

echo "Downloading episodes"
if [ $DEBUG != true ]; then
    youtube-dl -i $episodes
else
    echo "Episodes $episodes"
    youtube-dl --get-filename -i $episodes | xargs -d '\n' touch
fi
cd ..
echo "Merging episodes"
./join_acts.sh ${seasonpath} ${DEBUG}
