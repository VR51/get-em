# Get-Em

Games download script. Downloads Atari 8Bit Game Discs found at [http://www.mushca.com/f/atari/index.php](http://www.mushca.com/f/atari/index.php).

These discs are in ATR format. You will need an emulator to play the discs such as Atari800 or MAME. Some emulators required the files to be unzipped whereas some like them zipped. This script will not unzip the files.

More information about MAME software is available at [JournalXtra.com](https://journalxtra.com/gaming/download-complete-sets-of-mess-and-mame-roms/).

Lead Author: Lee Hodson

Donate: paypal.me/vr51

Website: https://journalxtra.com

First Written: 3rd Sep. 2017

First Release: 3rd Sep. 2017

This Release: 3rd Sep. 2017

Copyright 2017 Get-EM <https://journalxtra.com>

License: GPL3

Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>

Use of this program is at your own risk

# USE THIS TO:

- Download ATR discs from http://www.mushca.com/f/atari/index.php
- To see the current update notice displayed at the Homecroft site.

# TO RUN:

All files are downloaded to the current execution directory e.g. if you are in ~/Downloads then discs will download to ~/Downloads/<files>

Ensure the script is executable.

To download all Atari ATR discs from 001 to 437:

```bash get-em.sh or ./get-em.sh```

To download from a specific disc set upto set 437, e.g 101 to 437:

```bash get-em.sh 101```

To download a specific disc range, e.g 51 to 99:

```bash get-em.sh 51 99```

To download a single disc, e.g disc 43:

```bash get-em.sh 43 43```

To read the current update message to see which disc(s) or file(s) has(have) been updated:

```bash get-em.sh m```

# LIMITATIONS

This games download script will download disc collections only. Some files are not in ATR disc collections so these NAMED files must be downloaded from from http://www.mushca.com/f/atari/index.php manually.
