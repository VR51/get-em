#!/bin/bash
clear
###
#
#	Get-Em 1.0.1
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
#		To see the current update notice from http://www.mushca.com/f/atari/index.php
#
#
#	TO RUN:
#
#   All files are downloaded to the current directory e.g. if you are in ~/Downloads then
#   discs will download to ~/Downloads/<files>
#
#	  Ensure the script is executable.
#
#   To download all Atari ATR discs from 001 to 437:

#     Command line: bash get-em.sh or ./get-em.sh
#			Press D to download all discs
#			Press any other key to close window without downloading anything.
#
#   To download from a specific disc set up to set 437, e.g 101 to 437:
#      bash get-em.sh 101
#
#   To download a specific disc range, e.g 51 to 99:
#      bash get-em.sh 51 99
#
#   To download a single disc, e.g disc 43:
#      bash get-em.sh 43 43
#
#		To read the current update message to see which disc(s) or file(s) has(have) been updated:
#      bash get-em.sh m OR just click the program file
#
#	LIMITATIONS
#
#		Will download disc collections only. Some files are not in ATR disc collections so these NAMED files must be downloaded manually.
#
###

# Locate Where We Are
filepath="$( dirname "$(readlink -f "$0")" )"

today=$( date '+%a %b%e, %Y' )

last_message=()

# A Little precaution
cd "$filepath"

bold=$(tput bold)
normal=$(tput sgr0)




function get_em_run() {
	# Check for terminal then run else just run program
	tty -s
	if test "$?" -ne 0 ; then
		get_em_launch
	else
		get_em_discs "$@"
	fi
	
}


function get_em_discs() {

	if test "$1" == 'm' || test "$#" == 0 ; then
	
		message=$(wget -qO- 'http://www.mushca.com/f/atari/index.php?id' | grep 'lsx=0;txt=')

		pre='lsx=0;txt="'
		post='";'

		message=$(sed "s/$pre//g" <<< "$message")
		message=$(sed "s/$post//g" <<< "$message")
		message=$(sed "s/'/\"/g" <<< "$message")
		
		printf $bold
		printf "\nNew Message: $today\n"
		printf $normal

		printf "\n$message\n"

		if test "${#last_message[@]}" -ne 0; then
		
			printf $bold
			printf "\nOld Message(s)\n"
			printf $normal
			
			for i in "${last_message[@]}"; do
				printf "\n$i"
			done
		
		fi

		printf $bold
		printf "\n\nInformation\n"
		printf $normal
		
		printf "\nVisit http://www.mushca.com/f/atari/index.php from time to time.\n"
		printf "\nDownload script from https://github.com/VR51/get-em\n"

		# Record last message
		sed -i -E "0,/last_message=\((.*)\)/s/last_message=\((.*)\)/last_message=('$today: $message' \1)/" "$0"

		
		printf $bold
		get_em_prompt "\nPress 'D' to download all available ATR discs to the current directory or press any other key to exit.\n"
		printf $normal
		
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

}


function get_em_prompt() {

  while true; do

		printf "${1}\n\n"
		
		read REPLY
	
		case $REPLY in
		
		[dD])
		
			start=1
			end=437
			
			get_em_discs $start $end
			
			return 0
			
		;;

		*)
			
			exit 0
			
		esac

  done
  
}


## launch terminal

function get_em_launch() {

	terminal=( konsole gnome-terminal x-terminal-emulator xdg-terminal terminator urxvt rxvt Eterm aterm roxterm xfce4-terminal termite lxterminal xterm )
	for i in ${terminal[@]}; do
		if command -v $i > /dev/null 2>&1; then
			exec $i -e "$0"
			# break
		else
			printf "\nUnable to automatically determine the correct terminal program to run e.g Console or Konsole. Please run this program from the command line.\n"
			read something
			exit 1
		fi
	done
}

## Boot

get_em_run "$@"

# Exit is at end of get_em_run()

# FOR DEBUGGING

# declare -p
