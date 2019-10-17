South Park Downloader
=====================
This is a quick hack to download full seasons of South Park from the official South Park website. Currently it's only tested for **German** episodes. Due to geo-blocking I couldn't (without using a VPN or so) develop this tool for other countries. It should be quite easy though. It's probably already enough to adjust the `url` variable in `get_season.sh`. Feel free to open a PR.

Requirements
------------
It's a **BASH** script. So you better have one available.
You'll need [`youtube-dl`](https://rg3.github.io/youtube-dl/)(make sure it's the latest version) and [`MP4Box`](https://gpac.wp.imt.fr/mp4box/) as well as some standard command line tools (i.e. `echo`, `curl`, `grep`, `sed`, `printf`, `mkdir`, `find`, `rev`, `cut`, `sort`, `tr`, `mv` `rename`)

Installation
------------
 - Download the [code](https://github.com/robsdedude/southpark-downloader/archive/master.zip)
 - Extract it to some folder (e.g. "South Park") and open a terminal there.
 - run `chmod +x join_acts.sh get_season.sh`.
 
What the script does
--------------------
When you run `./get_season.sh 20`it will use `youtube-dl` to download all episodes of the season into a folder called `S20` (other seasons in the same fashion). The episodes will be downloaded in 3-4 acts (that's how the South Park website works). `MP4Box` is then used to merge the acts together into one file. After that some renaming happens so that the files are in the right order. Before that renaming happens the script will exit. You now have to check manually that the episodes and acts were named correctly (the South Park guys seem to fail frequently). To do so, look through the created season folder(s); if you see failures, you'll notice them. Fix them, then open `join_acts.sh` and change `exit 0` to `#exit 0`. Finally run `./join_acts.sh S20` (again). After everything worked you can go through the season folders and delete the `parts` folder inside to save space. These are only kept for safety.

I'm still unsure how naming failures look like or how to fix them
-----------------------------------------------------------------
Ok then. The single acts will be moved to a folder inside the season folder called `parts`. The season folder should only contain one file per episode now. If not, check the names of the acts and make sure they follow the same pattern. Then bring the acts of the failed episode back and, if existing, delete the incomplete joined episode. When joining worked, check the name of the full episodes and make sure that they follow the same naming scheme.  
Optional: For not working joins you can open an issue (please provide season number, full episode name and file names of the acts.

Pro Tips
--------
Run `for i in {1..20}; do ./get_season.sh $i; done` to download all seasons.
