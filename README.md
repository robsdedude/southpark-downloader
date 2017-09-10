South Park Downloader
=====================
This is a quick hack to download full seasons of South Park for the official South Park website. Currently it's only tested for **German** episodes. Due to geo-blocking I couldn't (without using a VPN or so) develop this tool for other countries. It should be quite easy though. It's probably already enough to adjust the `url` variable in `get_season.sh`. Feel free to open a PR.

Requirements
------------
It's a **BASH** script. So you better have one available.
You'll need [`youtube-dl`](https://rg3.github.io/youtube-dl/)(make sure it's the latest version) and [`MP4Box`](https://gpac.wp.imt.fr/mp4box/) as well as some standard command line tools (e.g. `curl`, `rename`, `find`)

Installation
------------
 - Download the [code](https://github.com/robsdedude/southpark-downloader/archive/master.zip)
 - Extract it to some folder (e.g. "South Park") and open a terminal there.
 - run `chmod +x join_acts.sh get_season.sh`.
 - run `./get_season.sh 20` to get season 20.
 
What the script does
--------------------
It will use `youtube-dl` to download all episodes of the season into a folder called `S20` for season 20. The episodes will be downloaded in 3-4 acts (that's how the South Park website works). `MP4Box` is then used to merge the acts together into one file. After that some renaming happens so that the files are in the right order.

Pro Tips
--------
Run `for i in {1..20}; do ./get_season.sh $i; done` to download all seasons.
