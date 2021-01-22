#!/bin/bash
clear
###
#
#	Get-Em 1.0.10
#
#	Lead Author: Lee Hodson
#	Donate: https://paypal.me/vr51
#	Website: https://journalxtra.com/gaming/classic-atari-games-downloader/
#	This Release: 22nd Jan. 2021
#	First Written: 3rd Sep. 2017
#	First Release: 3rd Sep. 2017
#
#	Copyright 2017-2018 Get-EM <https://journalxtra.com>
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
#		All files are downloaded to the current directory e.g. if you are in ~/Downloads then
#		discs will download to ~/Downloads/<files>
#
#		Ensure the script is executable.
#
#		Option 7 is best to use to build your first collection. This option will download all disks (both ATR discs and individual files), then unzip all downloadded packages before it deletes the zip packages.
#
#		But.. if you want to control the download...
#
#		To download all Atari ATR discs from 001 to 456 and the individual files:
#			Command line: bash get-em.sh or ./get-em.sh
#			Choose option 4
#
#		To download from a specific disc set up to set 456, e.g 101 to 456
#			bash get-em.sh 101
#
#		To download a specific disc range, e.g 51 to 99:
#			bash get-em.sh 51 99
#
#		To download a single disc, e.g disc 43:
#			bash get-em.sh 43 43
#
#	To read the current update message to see which disc(s) or file(s) has(have) been updated:
#		bash get-em.sh m OR just click the program file
#
#
###

# Locate Where We Are
filepath="$( echo $PWD )"
# A Little precaution
cd "$filepath"

today=$( date '+%a %b %e, %Y' )

declare -a options
declare -a last_message=()

options[1]="Download disk #"
options[2]="Download specific disk(s)"
options[3]="Download disk range"
options[4]="Download ALL software (Atari ATR disks and individual programs)"
options[5]="Unzip all zip files in $filepath"
options[6]="Unzip and delete all zip files in $filepath"
options[7]="Download ALL software, unzip them, then delete all zips."
options[8]="Delete_message_log"
options[9]="Exit"

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
		printf "\nDownload Get-Em script updates from https://github.com/VR51/get-em\n"
		printf "\nSend clean donations to https://paypal.me/vr51\n"

		# Record last message
		sed -i -E "0,/last_message=\((.*)\)/s/last_message=\((.*)\)/last_message=('$today: $message' \1)/" "$0"
		
		printf $bold
		get_em_prompt "Options" "${options[*]}"

		exit 0

	fi

	if test "$1"; then
		start=$1
	fi

	if test "$2" ; then
		end=$2
	fi

	if [[ "$start" =~ ^-?[0-9]+$ ]]; then
	
		printf "\nDownloading Disk:\n"
		
		while [ $start -le $end ]; do

			printf -v file "%03d" $start
			# wget -q "http://www.mushca.com/f/atari/GAMES/GAMES$file.ZIP" -O "$filepath/GAMES$file.zip"
			curl -e "http://www.mushca.com/f/atari/index.php" "http://www.mushca.com/f/atari/index.php?dl=$file" -o "$filepath/GAMES$file.zip"
			printf "\nGAMES$file.zip\n"
			let start=start+1

		done
	fi
	
	if [[ "$start" == 'all' ]]; then
	
		printf "\nDownloading All Software:\n"
		
		printf "\nHomesoft Collection\n"
		curl -e "http://www.mushca.com/f/atari/index.php" "http://www.mushca.com/f/atari/index.php?dl=FAF" -o "$filepath/homesoft-collection.zip"
		printf "\nhomesoft-collection.zip\n"
		
		printf "\nHomesoft Disks\n"
		curl -e "http://www.mushca.com/f/atari/index.php" "http://www.mushca.com/f/atari/index.php?dl=FAI" -o "$filepath/all-disks.zip"
		printf "\nall-disks.zip\n"

	fi
	
	if test $3; then
		if test $3 -eq $end; then
			printf "\nPress any key to continue.\n"
			read a
		fi
	else
		printf "\nPress any key to continue.\n"
		read a
	fi

}


function get_em_prompt() {

		# Extract newly edited disk number
		disk=$message
		disk=$(printf "$disk" | sed -E "s/.*Diskette\s([0-9]{1,3}).*/\1/i")

		if test "${#disk}" -gt 0; then
			options[1]="$(printf "${options[1]}" | sed "s/#/$disk/i")"
		else
			options[1]=' '
		fi
		
		
		printf "\n$1\n\n"
		printf $normal
		
  while true; do
  
		n=1
		for i in "${options[@]}"; do
			printf "$n) $i\n"
			let n=n+1
		done
		
			printf "\n"
		
		read REPLY
	
		case $REPLY in
		
		1) # Get updated disk
		
			if test "$disk" -gt 0 ; then
				get_em_discs $disk $disk
			fi
			clear

		;;
		
		2) # Get specific disk(s)
		
			printf "\nDisk number(s) to download. Separate multiple disk numbers with a space\n"
			read -a a

			c=${a[-1]}
			for i in ${a[@]}; do
				get_em_discs $i $i $c
			done
			clear
		;;
		
		3) # Get range
		
			printf "\nFirst disk number\n"
			read a
			printf "\nLast disk number\n"
			read z
			
			get_em_discs $a $z
			clear
			
		;;
		
		4)
		
			# Get all disks
			
			# start=1
			# end=443
			start=all
			end=all
			
			get_em_discs $start $end
			clear
			
		;;

		5) # Unzip files and keep zips
			
			for f in "$filepath"/*.zip
			do
				if test -f "$f"
				then
					unzip "$f"
				fi

			done

			printf $bold
			printf "\nPress any key to continue\n"
			printf $normal
			read something
			clear

		;;

		6) # Unzip files and delete zips
			
			for f in "$filepath/"*.zip
			do
				if test -f "$f"
				then
					unzip "$f"
					unlink "$f"
				fi

			done

			printf $bold
			printf "\nPress any key to continue\n"
			printf $normal
			read something
			clear

		;;
		
		7) # Download, unzip, delete
		
			# Get all disks
			
			# start=1
			# end=443
			start=all
			end=all
			
			get_em_discs $start $end
			
			# Unzip and delete packages
			
			for f in "$filepath/"*.zip
			do
				if test -f "$f"
				then
					unzip "$f"
					unlink "$f"
				fi

			done

			printf $bold
			printf "\nPress any key to continue\n"
			printf $normal
			read something
			clear
		
		;;
		
		8) # Delete message log
			
			sed -i -E "0,/last_message=\(.*\)/s/last_message=\(.*\)/last_message=()/" "$0"
			printf "\nLog deleted\n"
			clear
			get_em_run "$@"
			
		;;
		
		9) # Exit
			
			exit 0
			
		;;
		
		*)
			
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
