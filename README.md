# Get-Em 1.0.8

Download Atari 8-bit Game Disks from [http://www.mushca.com/f/atari/index.php](http://www.mushca.com/f/atari/index.php).

Disks downloaded by Get-Em are in zipped ATR format. You will need an emulator to play the disks. Such an emulator would be Atari800 or MAME. Some emulators like these disks to be unzipped whereas others like them zipped. This Atari disk downloader has an option to unzip downloaded files and either a, keep the zip files, or, b, delete the zip files. For reference, Atari800 / Atari800 Win prefers files unzipped.

The only file you need from here is get-em.sh. The other files provide information about get-em.sh and list the games in the disks.

More information about MAME software is available at [JournalXtra.com](https://journalxtra.com/gaming/download-complete-sets-of-mess-and-mame-roms/).

You must visit [http://www.mushca.com/f/atari/index.php](http://www.mushca.com/f/atari/index.php) to get disks that are not software compilation disks i.e. those that are named by game name and not named by compilation set number.

Lead Author: Lee Hodson

Donate: https://paypal.me/vr51

Website: https://journalxtra.com/gaming/classic-atari-games-downloader/

This Release: 5th Aug 2018

First Written: 3rd Sep. 2017

First Release: 3rd Sep. 2017


Copyright 2017 Get-EM <https://journalxtra.com>

License: GPL3

Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>

Use of this program is at your own risk

# USE THIS TO:

- Download ATR discs from http://www.mushca.com/f/atari/index.php
- To see the current update notice displayed at the Homesoft site.

# TO RUN:

All files are downloaded to the current execution directory e.g. if you are in ~/Downloads then discs will download to ~/Downloads/<files>

Ensure the script is executable. Click the get-em.sh file to run the program or use from the command line with arguments.

To download all Atari ATR discs from 001 to 444:

```bash get-em.sh or ./get-em.sh```
- Choose option 4.

To download all disks, unzip them and delete the reduendent zip files:
```bash get-em.sh or ./get-em.sh```
- Choose option 7.

To download from a specific disc set number up to set 437, e.g 101 to 437:

```bash get-em.sh 101```

To download a specific disc range, e.g 51 to 99:

```bash get-em.sh 51 99```
Or launch the program and choose option 3

To download a single disc, e.g disc 43:

```bash get-em.sh 43 43```
Or launch the program and choose option 2

To read the current update message to see which disc(s) or file(s) has(have) been updated:

```bash get-em.sh m```

To get the most recently updated disk, launch the program and choose option 1.

Or just click the program file. This will display the update message, any previous update messages the script downoaded and offer to download all files (option 4).

# LIMITATIONS

This games download script will download disc collections only. Some files are not in ATR disc collections. Files not in collections must be downloaded from from http://www.mushca.com/f/atari/index.php manually.

# CHANGELOG
1.0.8
- Changed final disk to 443.

1.0.7
- Changed final disk to 442.
- Adjusted code to improve menu.

1.0.6
- Updated highest value of available disks from 440 to 441.

1.0.5
- New option. Added option to download all disks, unzip their package files then clean up the zip downloads (deletes them).
- Bugfix. Replaced disk downloader. Changed from wget with curl.

1.0.4
- Changed final disk download number to 440.

1.0.3
- Added unzip options: 1) unzip and keep zip files; and 2) unzip then delete zip files.

1.0.2
- Added menu options: 1) Download most recently updated disk, 2) Download specific disk(s), 3) Download a disk range, 4) Download all disks, and, 5) Exit.

1.0.1
- Added click-to-run feature
- The script now records the disc archive update messages

1.0.0
- First public release
