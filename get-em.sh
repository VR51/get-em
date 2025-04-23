#!/bin/bash
# Enable error handling
set -e
clear
###
#
#	Get-Em 1.1.0
#
#	Lead Author: Lee Hodson
#	Donate: https://paypal.me/vr51
#	Website: https://journalxtra.com/gaming/classic-atari-games-downloader/
#	This Release: 24th April 2025
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
#		To download all Atari ATR discs from 001 to 443 and the individual files:
#			Command line: bash get-em.sh or ./get-em.sh
#			Choose option 4
#
#		To download from a specific disc set up to set 443, e.g 101 to 443
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
declare -a last_message=('Thu Apr 24, 2025: Welcome to Get-Em! Unable to retrieve the latest message from the website. Please check your internet connection or try again later.' 'Sat Jan 25, 2025: ' 'Fri Mar  8, 2024: ' 'Sun Dec 31, 2023: ' 'Sun Aug 23, 2020: '  )

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


get_em_run() {
	# Check if running in a terminal, if not launch terminal
	if ! tty -s; then
		get_em_launch
	else
		get_em_discs "$@"
	fi
}


get_em_discs() {
	# Local variables for better scope management
	local message="" pre post fallback_message

	if [ "$1" = 'm' ] || [ $# -eq 0 ]; then
		# Fallback message in case website is unreachable
		fallback_message="Welcome to Get-Em! Unable to retrieve the latest message from the website. Please check your internet connection or try again later."
		
		# Try to get the message with timeout to prevent hanging
		if ! message=$(wget --timeout=10 -qO- 'http://www.mushca.com/f/atari/index.php?id' 2>/dev/null | grep 'lsx=0;txt='); then
			printf "\nWarning: Could not retrieve message from website. Using fallback message.\n"
			message="$fallback_message"
		else
			# Extract message content more robustly
			pre='lsx=0;txt="'
			post='";'

			# Process message only if it contains the expected pattern
			if [[ "$message" == *"$pre"* && "$message" == *"$post"* ]]; then
				message=$(sed "s/$pre//g" <<< "$message")
				message=$(sed "s/$post//g" <<< "$message")
				message=$(sed "s/'/\"/g" <<< "$message")
			else
				printf "\nWarning: Message format has changed. Using fallback message.\n"
				message="$fallback_message"
			fi
		fi
		
		printf "%s" "$bold"
		printf "\nNew Message: %s\n" "$today"
		printf "%s" "$normal"

		printf "\n%s\n" "$message"

		if [ "${#last_message[@]}" -gt 0 ]; then
			printf "%s" "$bold"
			printf "\nOld Message(s)\n"
			printf "%s" "$normal"
			
			for msg in "${last_message[@]}"; do
				printf "\n%s" "$msg"
			done
		fi

		printf "%s" "$bold"
		printf "\n\nInformation\n"
		printf "%s" "$normal"
		
		printf "\nVisit http://www.mushca.com/f/atari/index.php from time to time.\n"
		printf "\nDownload Get-Em script updates from https://github.com/VR51/get-em\n"
		printf "\nSend donations to https://paypal.me/vr51\n"

		# Record last message
		sed -i -E "0,/last_message=\((.*)\)/s/last_message=\((.*)\)/last_message=('$today: $message' \1)/" "$0"
		
		printf $bold
		get_em_prompt "Options" "${options[*]}"

		exit 0

	fi

	# Process command line arguments for disk numbers with proper initialization
	local start="" end="" file

	if [ -n "$1" ]; then
		start="$1"
	fi

	if [ -n "$2" ]; then
		end="$2"
	fi

	# Download disk range if start is a number
	if [[ "$start" =~ ^-?[0-9]+$ ]]; then
		printf "\nDownloading Disk(s):\n"
		
		while [ "$start" -le "$end" ]; do
			# Format disk number with leading zeros
			printf -v file "%03d" "$start"
			
			# Download with curl and check for errors
			printf "Downloading GAMES%s.zip..." "$file"
			if curl -s --connect-timeout 10 -e "http://www.mushca.com/f/atari/index.php" \
			        "http://www.mushca.com/f/atari/index.php?dl=$file" \
			        -o "$filepath/GAMES$file.zip"; then
				printf " Success!\n"
			else
				printf " Failed!\n"
			fi
			
			# Increment counter
			((start++))
		done
	fi
	
	# Download all software collections if requested
	if [[ "$start" == 'all' ]]; then
		printf "\nDownloading All Software Collections:\n"
		
		# Download Homesoft Collection with error handling
		printf "Downloading Homesoft Collection..."
		if curl -s --connect-timeout 10 -e "http://www.mushca.com/f/atari/index.php" \
		        "http://www.mushca.com/f/atari/index.php?dl=FAF" \
		        -o "$filepath/homesoft-collection.zip"; then
			printf " Success!\n"
		else
			printf " Failed!\n"
		fi
		
		# Download Homesoft Disks with error handling
		printf "Downloading Homesoft Disks..."
		if curl -s --connect-timeout 10 -e "http://www.mushca.com/f/atari/index.php" \
		        "http://www.mushca.com/f/atari/index.php?dl=FAI" \
		        -o "$filepath/all-disks.zip"; then
			printf " Success!\n"
		else
			printf " Failed!\n"
		fi
	fi
	
	# Handle user input for continuation
	if [ -n "$3" ]; then
		if [ "$3" -eq "$end" ]; then
			printf "\nDownload complete. Press Enter to continue.\n"
			read -r
		fi
	else
		printf "\nDownload complete. Press Enter to continue.\n"
		read -r
	fi

}


get_em_prompt() {

		# Extract newly edited disk number with error handling
		local disk="$message"
		if [ -n "$disk" ]; then
			disk=$(printf "%s" "$disk" | sed -E "s/.*Diskette\s([0-9]{1,3}).*/\1/i" 2>/dev/null)
		fi

		# Update option 1 with disk number if available
		if [ -n "$disk" ] && [[ "$disk" =~ ^[0-9]+$ ]]; then
			options[1]="$(printf "%s" "${options[1]}" | sed "s/#/$disk/i")"
		else
			options[1]="Download latest disk"
		fi
		
		
		printf "\n%s\n\n" "$1"
		printf "%s" "$normal"
		
  while true; do
  
		local n=1
		for opt in "${options[@]}"; do
			printf "%d) %s\n" "$n" "$opt"
			((n++))
		done
		
			printf "\n"
		
		read REPLY
	
		case $REPLY in
		
		1) # Get updated disk
		
			if [ -n "$disk" ] && [ "$disk" -gt 0 ]; then
				get_em_discs "$disk" "$disk"
			else
				printf "\nNo specific disk number found in the message.\n"
				read -r -p "Press Enter to continue"
			fi
			clear

		;;
		
		2) # Get specific disk(s)
		
			printf "\nDisk number(s) to download. Separate multiple disk numbers with a space\n"
			read -a a

			c=${a[-1]}
			for disk_num in "${a[@]}"; do
				get_em_discs "$disk_num" "$disk_num" "$c"
			done
			clear
		;;
		
		3) # Get range
		
			printf "\nFirst disk number\n"
			read a
			printf "\nLast disk number\n"
			read z
			
			get_em_discs "$a" "$z"
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

			printf "%s" "$bold"
			printf "\nPress Enter to continue\n"
			printf "%s" "$normal"
			read -r
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

			printf "%s" "$bold"
			printf "\nPress Enter to continue\n"
			printf "%s" "$normal"
			read -r
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

			printf "%s" "$bold"
			printf "\nPress Enter to continue\n"
			printf "%s" "$normal"
			read -r
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

get_em_launch() {
	# Define an array of common terminal emulators
	local terminal=( konsole gnome-terminal x-terminal-emulator xdg-terminal terminator urxvt rxvt Eterm aterm roxterm xfce4-terminal termite lxterminal xterm )
	local term_found=false
	
	# Try to find an available terminal emulator
	for term in "${terminal[@]}"; do
		if command -v "$term" > /dev/null 2>&1; then
			term_found=true
			printf "Launching in %s terminal...\n" "$term"
			exec "$term" -e "$0"
			# If exec succeeds, we won't reach this point
			break
		fi
	done
	
	# If no terminal was found
	if ! $term_found; then
		printf "\nUnable to automatically determine the correct terminal program.\n"
		printf "Please run this program from the command line.\n"
		read -r -p "Press Enter to exit" 
		exit 1
	fi
}

## Boot

get_em_run "$@"

# Exit is at end of get_em_run()

# FOR DEBUGGING

# declare -p
