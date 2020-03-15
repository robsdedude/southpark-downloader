South Park Downloader
=====================
This is a quick hack to download full seasons of South Park from the official South Park website. It supports English, German, and Spanish. English and Spanish support however, are not fully tested as of now. If you encounter problems, feel free to open an issue.

Requirements (what do I need?)
------------------------------
It's a **BASH** script. So you better have one available.
You'll need [`youtube-dl`](https://rg3.github.io/youtube-dl/)(make sure it's the latest version) and [`MP4Box`](https://gpac.wp.imt.fr/mp4box/) as well as some standard command line tools (i.e. `echo`, `curl`, `grep`, `sed`, `printf`, `mkdir`, `find`, `rev`, `cut`, `sort`, `tr`, `mv`, and `rename`)

Installation (how to get it running?)
-------------------------------------
 - Download the [code](https://github.com/robsdedude/southpark-downloader/archive/master.zip)
 - Extract it to some folder (e.g. "South Park") and open a terminal there.
 - run `chmod +x join_acts.sh get_season.sh`.
 
Usage (what does the script do?)
--------------------------------
When you run `./get_season.sh 20`it will use `youtube-dl` to download all episodes of the season into a folder called `S20_en` (other seasons in the same fashion). The episodes will be downloaded in 3-4 acts (that's how the South Park website works). `MP4Box` is then used to merge the acts together into one file. After that some renaming happens so that the files are in the right order. Before that renaming happens the script will exit. You now have to check manually that the episodes and acts were named correctly (the South Park guys seem to fail frequently). To do so, look through the created season folder(s); if you see failures, you'll notice them. Fix them, then open `join_acts.sh` and change `exit 0` to `#exit 0`. Finally run `./join_acts.sh S20_en` (again). After everything worked you can go through the season folders and delete the `parts` folder inside to save space. These are only kept for safety.

Naming mistakes (how do I know I fixed all of the naming mistakes mentioned before?)
------------------------------------------------------------------------------------
Ok then. When you think you're done with fixing, call `./join_acts.sh <season_folder>` (it won't harm if you missed mistakes). The single acts will be moved to a folder inside the season folder called `parts`. The season folder should only contain one file per episode now. If not, you missed a mistake. Check the names of the acts and make sure they follow the same pattern. Then bring the acts of the failed episode back (from the `parts` folder to the season folder) and, if existing, delete the incomplete joined episode(s).
Then run `join_acts.sh` again. Repeat until all parts got merged into full episodes. Then check the name of the full episodes and make sure that they follow the same naming scheme. If not, you may open an issue and provide season number, selected language, full episode file name, and file names of the acts.

Language selection (how do I download non-English seasons?)
-----------------------------------------------------------
Just run `./get_season.sh <season_number> <language_code>` instead, where you replace `<season_number>` with the season you want to download and `<langauge_code>` with one of `en`, `de`, or `es` (e.g. `./get_season.sh 20 de`). The season will then be downloaded into a folder named `S<season_number>_<language_code>` (e.g. `S20_de`).


Top Tip (it's tip-top)
----------------------
Run `for i in {1..20}; do ./get_season.sh $i; done` to download all seasons from 1 to 20 (including).
