#!/bin/bash
clear
###
#
#	Get-Em 1.0.0
#
#	Lead Author: Lee Hodson
#	Donate: paypal.me/vr51
#	Website: https://journalxtra.com
#	First Written: 3rd Sep. 2017
#	First Release: 3rd Sep. 2017
#	This Release: 3rd Sep. 2017
#
#	Copyright 2017 Get-EM <https://journalxtra.com>
#	License: GPL3
#
#	Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>
#
#	Use of this program is at your own risk
#
#	USE TO:
#
#	  Download ATR discs from http://www.mushca.com/f/atari/index.php
#		To see the current update notice.
#
#
#	TO RUN:
#
#   All files are downloaded to the current execution directory e.g. if you are in ~/Downloads then
#   discs will download to ~/Downloads/<files>
#
#	  Ensure the script is executable.
#
#   To download all Atari ATR discs from 001 to 437:
#      Command line: bash get-em.sh or ./get-em.sh
#
#   To download from a specific disc set upto set 437, e.g 101 to 437:
#      bash get-em.sh 101
#
#   To download a specific disc range, e.g 51 to 99:
#      bash get-em.sh 51 99
#
#   To download a single disc, e.g disc 43:
#      bash get-em.sh 43 43
#
#		To read the current update message to see which disc(s) or file(s) has(have) been updated:
#      bash get-em.sh m
#
#	LIMITATIONS
#
#		Will download disc collections only. Some files are not in ATR disc collections so these NAMED files must be downloaded manually.
#
###

# Locate Where We Are
filepath="$(dirname "$(readlink -f "$0")")"
# A Little precaution
cd "$filepath"

# Download the discs
if test $# == 0; then 
	start=1
	end=437
fi

if test "$1" == 'm'; then
	message=$(wget -qO- 'http://www.mushca.com/f/atari/index.php?id' | grep 'lsx=0;txt=')

	pre='lsx=0;txt="'
	post='";'

	message=$(sed "s/$pre//" <<< "$message")
	echo "${message/%$post/}"
	echo "Visit http://www.mushca.com/f/atari/index.php from time to time."
	echo "Download script from https://github.com/VR51/get-em"
	exit 0
fi

if test "$1"; then
	start=$1
fi

if test "$2" ; then
	end=$2
	else
	end=437
fi


while [ "$start" -le "$end" ]; do

	printf -v file "%03d" $start
	wget -q "http://www.mushca.com/f/atari/GAMES/GAMES$file.ZIP" -O "$filepath/GAMES$file.zip"
	let start=start+1

done
