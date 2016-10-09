#!/bin/bash
#================================================================
# HEADER bash shell script
#================================================================
#Date 070916
#License: 
#GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
#see license.md  at repo or /usr/share/licenses/cylon/
#
#Written by G lyons  at glyons66@hotmail.com 
#
#Version 2.2-1  See changelog.md at repo for version control
#
#Software repo
#https://github.com/gavinlyonsrepo/cylon
#AUR package name = cylon , at aur.archlinux.org by glyons
#
#Description:
#Arch Linux distro maintenance Bash script. 
#Aur package name = cylon 
#A script to do as much maintenance, backups and system checks in 
#single menu driven optional script Command line program for Arch.  
#This script provides numerous tools to Arch Linux 
#for maintenance, system checks and backups. see readme.md  at repo 
#or usr/share/doc for more info.
#
# Usage
# type cylon in terminal, optional config file cylonCfg.conf 
# at "$HOME/.config/cylon"
#
#optional dependencies
#bleachbit ( (optional) – used for system clean
#clamav  (optional) – used for finding malware
#cower  (optional) – AUR package for AUR work
#gdrive ( (optional) – AUR package for google drive backup
#gnu-netcat (optional) – used for checking network
#lostfiles (optional) – AUR package for finding lost files
#rkhunter (optional) – finds root kits malware
#rmlint ((optional) – Finds lint and other unwanted
#ccrypt (optional)  -  Encrypt and decrypt files
#================================================================
# END_OF_HEADER
#================================================================
#
#=======================VARIABLES SETUP=============================
#colours for printf
RED=$(printf "\033[31;1m")
GREEN=$(printf "\033[32;1m")
BLUE=$(printf "\033[36;1m")
NORMAL=$(printf "\033[0m") 
#make the path for the program output dest3
mkdir -p "$HOME/Documents/Cylon/"
#make the path for the optional config file ,left to user to create it
mkdir -p "$HOME/.config/cylon"
#set the path for the program output
Dest3="$HOME/Documents/Cylon/"
#set the path for optional config file dest5
Dest5="$HOME/.config/cylon"
#set path for readme.md changlog.md dest6
Dest6="/usr/share/doc/cylon"
#prompt for select menus
PS3="${BLUE}Press option number + [ENTER]${NORMAL}"
#====================FUNCTIONS list (13)===============================
#FUNCTION HEADER
# NAME :            msgFunc
# DESCRIPTION :     utility and general purpose function,
#prints line, text and anykey prompts, makes dir for system output,
#checks network and package install
# INPUTS : $1 process name $2 text input $3 text input    
# OUTPUTS : checkpac returns 1 or 0 
# PROCESS :[1]   line [2]    anykey
# [3]   "green , red ,blue , norm" ,                 
# [4]   checkpac [5]   checkNet v
#NOTES :   needs gnu-cat installed for checkNet        
function msgFunc
{
	case "$1" in 
	
		line) #print blue horizontal line of =
			printf '\033[36;1m%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
		;;
		anykey) #any key prompt, appends second text input to prompt
		    printf '%s' "${GREEN}" 
			read -n 1 -r -s -p "Press any key to continue $2"
			printf '%s\n' "${NORMAL}"
		;;
		
		#print passed text string
		green) printf '%s\n' "${GREEN}$2${NORMAL}" ;;
		red) printf '%s\n' "${RED}$2${NORMAL}" ;;
		blue) printf '%s\n' "${BLUE}$2${NORMAL}" ;;
		norm) #print normal text colour
			if [ "$2" = "" ]
				then
				#just change colour to norm if no text sent
				printf '%s' "${NORMAL}"
				return
			fi
			printf '%s\n' "${NORMAL}$2" ;;
			
		dir) #makes dirs for output appends passed text to name
			#check if coming from system backup other path
			if [ "$3" != 1 ]
			then 
			cd "$Dest3" || exitHandlerFunc dest3
			fi
			TODAYSDIR=$(date +%X-%d-%b-%Y)"$2"
			mkdir "$TODAYSDIR"
			cd "$TODAYSDIR" || exitHandlerFunc dest4
			msgFunc norm "Directory for output made at:-"
			pwd	 ;;
			
		checkpac) #check if package(passed text 2) installed 
		          #returns 1 or 0  and appends passed text 3
			x=$(pacman -Qqs "$2")
			if [ -n "$x" ]
			then 
				printf '%s\n' "$2 is Installed $3"
				return 0
			else 
				printf '%s\n' "${RED}$2 is Not installed${NORMAL} $3"
				return 1
			fi ;;
			
		checkNet) #checks network with gnu-netcat exists 
					#This uses netcat (nc) in its port scan mode, 
					#a quick poke (-z is zero-I/O mode [used for 
					#scanning]) with a quick timeout 
					#(-w 1 waits at most one second
					#It checks Google on port 80 (HTTP).
					if nc -zw1 "$2" 80; then
						msgFunc norm   "We have connectivity $2"
					else
						exitHandlerFunc netdown "$2"
					fi
		;;
		*) printf '%s\n' "Error bad input to msgFunc" ;;
	esac
}

#FUNCTION HEADER
# NAME :            HelpFunc
# DESCRIPTION :     two sections one prints various system information the
# other cylon information and the installed readme file
# INPUTS : $1 process name either HELP or SYS    
# OUTPUTS : n/a
# PROCESS :[1] HELP [2] SYS   
function HelpFunc 
{
clear
msgFunc line
	if [ "$1" = "HELP" ]
				then
				msgFunc green "cylon info and readme display" 
				msgFunc line 
				msgFunc norm "Written by G.Lyons, Reports to  <glyons66@hotmail.com>"
				msgFunc norm "AUR package name = cylon, at aur.archlinux.org by glyons."
				msgFunc norm "Version=$(pacman -Qs cylon | head -1 | cut -c 7-20)"
				msgFunc norm "Cylon program location = $(which cylon)"
				msgFunc norm "Folder for Cylon output data = $Dest3"
				msgFunc norm "Location of cylonCfg.conf = $Dest5"
				msgFunc norm "Location of readme.md changlog.md = $Dest6"
				msgFunc norm "Location of License.md = /usr/share/licenses/cylon"
				msgFunc norm "Checking optional dependencies installed..."
				msgFunc checkpac cower "AUR package"
				msgFunc checkpac gdrive "AUR package"
				msgFunc checkpac lostfiles "AUR package"
				msgFunc checkpac rmlint
				msgFunc checkpac rkhunter
				msgFunc checkpac gnu-netcat
				msgFunc checkpac clamav
				msgFunc checkpac bleachbit 
				msgFunc checkpac ccrypt
				msgFunc anykey "and view the readme."
				msgFunc line
				msgFunc green "Displaying cylonReadme.md file at $Dest6"
				cd "$Dest6"  || exitHandlerFunc dest6
				more Readme.md 
				msgFunc green "Done!" 
				msgFunc line
				msgFunc anykey
				clear
				return
			fi
msgFunc green "System Information"
msgFunc line
msgFunc norm  #set colour back
date +%A-Week%U-%d-%B-%Y--%T
msgFunc norm "Uptime = $(uptime -p)"
msgFunc norm "Operating System = $(uname -mo)"
msgFunc norm "Kernel = $(uname -sr)"
msgFunc norm "Network node name = $(uname -n)"
msgFunc norm "Shell = $SHELL"
msgFunc norm "Screen Resolution = $(xrandr |grep "\*" | cut -c 1-15)"
msgFunc norm "CPU $(grep name /proc/cpuinfo  | tail -1)"
mem=($(awk -F ':| kB' '/MemTotal|MemAvail/ {printf $2}' /proc/meminfo))
memused="$((mem[0] - mem[1]))"
memused="$((memused / 1024))"
memtotal="$((mem[0] / 1024))"
memory="${memused}MB / ${memtotal}MB"
msgFunc norm "RAM used/total = ($memory)"
msgFunc norm "Number of All installed  packages = $(pacman -Q | wc -l)"
msgFunc norm "Number of native, explicitly installed packages  = $(pacman -Qgen | wc -l)"
msgFunc norm "Number of foreign installed packages  = $(pacman -Qm | wc -l)"
 #check gnu-cat is installed
msgFunc checkpac gnu-netcat "Accessing Network Database...."
if [ "$?" != 0 ]
then
	msgFunc red "Please install gnu-netcat for complete system infomation check"
	msgFunc anykey 
	return
fi
#check network connectivity if good get updates numbers from arch
msgFunc checkNet "archlinux.org"
msgFunc norm   "Number of Pacman updates ready...> $(checkupdates | wc -l)"
msgFunc checkNet  "aur.archlinux.org"
msgFunc norm "Number of updates for installed AUR packages ready ...> $(cower -u | wc -l)"
msgFunc checkNet  "google.com"
msgFunc anykey
} 


#FUNCTION HEADER
# NAME :            PacmanFunc
# DESCRIPTION :     Pacman package manager options
# PROCESS : See options array      
#NOTE gnu-netcat is neeeded for the first option.      
#CHANGES : rss news feed added in v2.2
function PacmanFunc 
{
			clear
		   #Pacman package manager options:
		   msgFunc line
		   msgFunc green "Pacman package manager. Number of packages installed = $(pacman -Q | wc -l) "
		   msgFunc line
		   msgFunc blue "Pacman package manager options:-"
			options=("Check network and then check for updates (no download)" "pacman -Syu Upgrade packages" \
			 "pacman -Si Display extensive information about a given package" "pacman -S Install Package" \
			 "pacman -Ss Search for packages in the database" \
			 "pacman -Rs Delete Package" "pacman -Qs Search for already installed packages" \
			 "pacman -Qi  Display extensive information for locally installed packages" "paccache -r Prune older packages from cache"\
			 "Write installed package lists to files" "Remove all packages not required as dependencies (orphans)" \
			 "Back-up the local pacman database" "Arch Linux News Rss feed" "Return to main menu")
			select choicep in "${options[@]}"
			do
			case "$choicep" in
					"${options[0]}")
					msgFunc green "Pacman updates ready:-.... "
					#check gnu-netcat is installed
					msgFunc checkpac gnu-netcat "Accessing Network Database...."
					if [ "$?" != 0 ]
					then
						msgFunc anykey 
						return
					fi
					#check network connectivity if good get updates numbers from arch
						msgFunc checkNet "archlinux.org"
						msgFunc norm   "Number of Pacman updates ready...> $(checkupdates | wc -l)"
						checkupdates
					;;
					"${options[1]}") #update pacman
						msgFunc green "Update system with Pacman."
						sudo pacman -Syu
					;;
					"${options[2]}") #pacman -Si Display extensive information about a given package
						msgFunc green "Display information  for Package."
						msgFunc norm "Please enter package name"
						read -r pacString
                        pacman -Si "$pacString"
					;;
					"${options[3]}") #pacman -S Install Package
						msgFunc green "Install package."
						msgFunc norm "Please enter package name"
						read -r pacString
                        sudo pacman -S "$pacString"
					;;
					"${options[4]}")   #pacman -Ss Search Repos for Package
						msgFunc green "Search for packages in the database."
						msgFunc norm "Please enter package name"
						read -r pacString
                        pacman -Ss "$pacString"
					;;
					"${options[5]}") #pacman -Rs Delete Package
						msgFunc green "Delete Package."
						msgFunc norm "Please enter package name"
						read -r pacString
                        sudo pacman -Rs "$pacString"
					;;
					"${options[6]}")   #pacman -Qs Search for already installed packages
						msgFunc green "Search for already installed packages."
						msgFunc norm "Please enter package name"
						read -r pacString
                        pacman -Qs "$pacString"
					;;
					"${options[7]}") #pacman -Qi Display extensive information about a given package(local install)
						msgFunc green "Display information  for Package."
						msgFunc norm "Please enter package name"
						read -r pacString
                        pacman -Qi "$pacString"
					;;
					"${options[8]}")  msgFunc green  "Prune older packages from cache."
					#The paccache script, deletes all cached  package 
						#regardless of whether they're installed or not, 
						#except for the most recent 3, 
							sudo paccache -r
					;;
					"${options[9]}")msgFunc green "Writing installed package lists to files at :"
						msgFunc dir "-INFO"
						#all packages 
						pacman -Q  > pkglistQ.txt
						#native, explicitly installed package
						pacman -Qqen > pkglistQgen.txt
						#foreign installed (AUR etc))
						pacman -Qm > pkglistQm.txt
					;;
					"${options[10]}")   #delete orphans
						msgFunc green "Delete orphans!"
						#Remove all packages not required as dependencies (orphans)
						sudo pacman -Rns "$(pacman -Qtdq)"
					;;
					"${options[11]}") #backup the pacman database
						msgFunc green "Back-up the pacman database to :"
						msgFunc dir "-BACKUPPACMAN"
						tar -v -cjf pacman_database.tar.bz2 /var/lib/pacman/local
					;;
					"${options[12]}") #Arch Linux News Rss feed
						msgFunc green "Arch Linux News Rss feed last 5 items"
						# Set N to be the number of latest news to fetch
						NEWS=$(echo -e $(curl --silent https://www.archlinux.org/feeds/news/  | awk ' NR == 1 {N = 4 ; while (N) {print;getline; if($0 ~ /<\/item>/) N=N-1} ; sub(/<\/item>.*/,"</item>") ;print}'))
						#  THE RSS PARSER Remove some tags 
						NEWS=$(echo -e "$NEWS" | \
						awk '{
						# uncomment to remove first line which is usually not a news item
						sub(/<lastBuildDate[^>]*>([^>]*>)/,"");sub(/<language[^>]*>([^>]*>)/,"");sub(/<title[^>]*>([^>]*>)/,"");sub(/<link[^>]*>([^>]*>)/,""); 
						while (sub(/<guid[^>]*>([^>]*>)/,"")); 
						while (sub(/<dc:creator[^>]*>([^>]*>)/,""));
						while (sub(/<description[^>]*>([^>]*>)/,"")); print }' | \
						sed -e ':a;N;$!ba;s/\n/ /g')
					    echo -e "$(echo -e "$NEWS" | \
						sed -e 's/&amp;/\&/g
						s/&lt;\|&#60;/</g
						s/&gt;\|&#62;/>/g
						s/<\/a>/£/g
						s/href\=\"/§/g
						s/<title>/\\n\\n :: \\e[01;31m/g; s/<\/title>/\\e[00m ::/g
						s/<link>/\\n [ \\e[01;36m/g; s/<\/link>/\\e[00m ]\\n/g
						s/<p\( [^>]*\)\?>\|<br\s*\/\?>/\n/g
						s/<b\( [^>]*\)\?>\|<strong\( [^>]*\)\?>/\\e[01;30m/g; s/<\/b>\|<\/strong>/\\e[00;37m/g
						s/<i\( [^>]*\)\?>\|<em\( [^>]*\)\?>/\\e[41;37m/g; s/<\/i>\|<\/em>/\\e[00;37m/g
						s/<u\( [^>]*\)\?>/\\e[4;37m/g; s/<\/u>/\\e[00;37m/g
						s/<code\( [^>]*\)\?>/\\e[00m/g; s/<\/code>/\\e[00;37m/g
						s/<a[^§|t]*§\([^\"]*\)\"[^>]*>\([^£]*\)[^£]*£/\\e[01;31m\2\\e[00;37m \\e[01;34m[\\e[00;37m \\e[04m\1\\e[00;37m\\e[01;34m ]\\e[00;37m/g
						s/<li\( [^>]*\)\?>/\n \\e[01;34m*\\e[00;37m /g
						s/<!\[CDATA\[\|\]\]>//g
						s/\|>\s*<//g
						s/ *<[^>]\+> */ /g
						s/[<>£§]//g')"    
						;;
						*)  #exit  
						msgFunc green "Done!"	
						return
						;;
			esac
			break
			done
			msgFunc green "Done!"	
			msgFunc anykey 
}
#FUNCTION HEADER
# NAME :            lostfilesFunc
# DESCRIPTION:Search for files which are not 
# part of installed Arch Linux packages    
# PROCESS : lostfiles relaxed and strict scans
#NOTES :   needs lostfiles (AUR) installed)        
function lostfilesFunc
{
	#check if lostfiles installed
	msgFunc checkpac lostfiles
    if [ "$?" != 0 ]
	then
		msgFunc anykey 
	return
	fi
	clear
	msgFunc line
	msgFunc green "Lostfiles :-Search for files which are not part of installed Arch Linux packages"
	msgFunc dir "-INFO"
	msgFunc norm  "Lostfiles strict scan running, outputing to file"
	sudo bash -c "lostfiles strict  > lostfilesStrictlist.txt" 
	msgFunc green "Done!"
	msgFunc norm  "Lostfiles relaxed scan running, outputing to file"
    sudo bash -c  "lostfiles relaxed > lostfilesRelaxedlist.txt" 
	msgFunc green "Done!"
}
#FUNCTION HEADER
# NAME :           readconfigFunc
# DESCRIPTION:read the config file into program if not there   
#use hardcoded defaults config file is for paths for backup function
# OUTPUTS : sets paths for backup function 
# PROCESS : read $Dest5/cylonCfg.conf
#NOTES :   file is optional       
function readconfigFunc
{
	#read cylon.conf for system back up paths 
	msgFunc green "Reading config file cylonCfg.conf at:-"
	msgFunc norm "$Dest5"
	#check if file there if not use defaults.
	if [ ! -f "$Dest5/cylonCfg.conf" ]
		then
		msgFunc red "No config found: Use the default paths"
		#path for an internal hard drive backup
		Destination1="/run/media/$USER/Linux_backup"
		#path for an external hard drive backup
		Destination2="/run/media/$USER/iomeaga_320"
		#default paths for gdrive 
		gdriveSource1="$HOME/Documents"
		gdriveSource2="$HOME/Pictures"
		gdriveDest1="0B3_RVJ50UWFAaGxJSXg3NGJBaXc"
		gdriveDest2="0B3_RVJ50UWFAR3A2T3dZTU9TaTA"
		return
	fi
	cd "$Dest5"  || exitHandlerFunc dest5
	source ./cylonCfg.conf
	msgFunc norm "Custom paths read from file"
}

#FUNCTION HEADER
# NAME :           CowerFunc
# DESCRIPTION:use cower and makepkg utility to mange AUR packages
# downloads, updates and searches
# PROCESS : six options, see optionsC array 
#NOTES :    needs cower(AUR) installed  gnu-netcat is needed for option 5     
function CowerFunc
{
			 #check cower is installed
            msgFunc checkpac cower 
            if [ "$?" != 0 ]
				then
				msgFunc anykey 
				return
			fi
			clear
	         #AUR warning
	         msgFunc red  " AUR WARNING: User Beware"	
	         cat <<-EOF
			 The Arch User Repository (AUR) is a community-driven repository for Arch users
			 Before installing packages or installing updates
			 Please read Arch linux wiki First and learn the AUR system.
			EOF
			msgFunc anykey
			clear
			msgFunc line
		   msgFunc green "AUR packages management by cower. Number of foreign packages installed = $(pacman -Qm | wc -l)"
		   msgFunc line
	        msgFunc blue "AUR package install and updates by cower, options:-"
         	optionsC=("Information for package" "Search for package" \
         	"Download package" "Get updates for installed packages" \
         	"Check network and then check for updates (no download)" "Return")
         	select choiceCower in "${optionsC[@]}"
			do
			case "$choiceCower" in    
						#search AUR with cower with optional install
						"${optionsC[0]}")msgFunc green "${GREEN}Information for AUR package , cower -i"
						  msgFunc norm "Type a AUR package name:-"
					      read -r cowerPac		
						  msgFunc norm " " 
						  cower -i -c "$cowerPac" || return
						  msgFunc anykey
						    ;;
						   
						  "${optionsC[1]}") msgFunc green "${GREEN}Search for AUR package, cower -s"
						  #cower -s 
						  msgFunc norm "Type a AUR package name:-"
					      read -r cowerPac		
						  msgFunc norm " " 
						  cower -s -c "$cowerPac" || return
						  msgFunc anykey
						  ;;
						  
						"${optionsC[2]}")#cower -d Download AUR package with an optional install
							msgFunc green "${GREEN}Download AUR package cower -d with an optional install"
							msgFunc dir "-AUR-DOWNLOAD"
							#build and install packages
							msgFunc norm "Type a AUR package name:-"
							read -r cowerPac		
							cower -d -c	 "$cowerPac" || return
							cd "$cowerPac" || return
							msgFunc green "$cowerPac PKGBUILD: Please read"
							cat PKGBUILD
							msgFunc green "PKGBUILDS displayed above. Install  [Y/n]"
							read -r choiceIU3
							if [ "$choiceIU3" != "n" ]
								then
									msgFunc norm  "Installing package $cowerPac"
									makepkg -si		
							fi
						 ;;
						
						#check for updates cower and optional install 
						"${optionsC[3]}")msgFunc green "Update AUR packages  cower -du  "		
						#make cower update directory
						msgFunc dir "-AUR-UPDATES" 
						cower -d -vuc 
						# look for empty dir (i.e. if no updates) 
						if [ "$(ls -A .)" ] 
						then
							msgFunc norm  "Package builds available"
							ls 
							msgFunc norm " "
						    msgFunc green "Press any key to View package builds or n to quit"
							read -r choiceIU2
								if [ "$choiceIU2" != "n" ]
									then
									msgFunc green " Viewing  PKGBUILDS of updates :-" 
									#cat PKGBUILDs to screen
									find . -name PKGBUILD -exec cat {} \; | more
									msgFunc anykey
									msgFunc line
									msgFunc green "PKGBUILDS displayed above. Install all [Y/n]"  
									read -r choiceIU1
									if [ "$choiceIU1" != "n" ]
										then
											#build and install all donwloaded PKGBUILD files 
											msgFunc norm  "Installing packages"
											find . -name PKGBUILD -execdir makepkg -si \;
									fi			
								fi	
						  else
							msgFunc norm "No updates found for installed AUR packages by Cower."
						  fi	
						;;
						
						 "${optionsC[4]}") #check for updates 
								msgFunc green  "Check network and then check for updates"
								#check gnu-netcat is installed
								msgFunc checkpac gnu-netcat "Accessing Network Database...."
								if [ "$?" != 0 ]
								then
									msgFunc anykey 
									return
								fi
								#check network connectivity if good get updates numbers from arch
								msgFunc checkNet "aur.archlinux.org"
								msgFunc norm "Number of updates available for installed AUR packages :..."
								cower -u | wc -l
								cower -uc
								msgFunc anykey
						  ;;
						 
						 *)  #exit to main menu 
							return
						 ;;
				 esac
				 break
				 done
			     msgFunc green "Done!"
}
#FUNCTION HEADER
# NAME :           SystemMaintFunc
# DESCRIPTION:carries out 5 maintenance checks  
# OUTPUTS : 4 output files 
# PROCESS : systemd , SSD trim , broken syslinks ,journalcontrol errors 
#NOTES :    needs cower(AUR) installed       
function SystemMaintFunc
{
	        #change dir for log files
	        msgFunc dir "-INFO"
			msgFunc norm "Files report will be written to path above -"
	        # -systemd --failed:
			msgFunc green "All Failed Systemd Services"
			systemctl --failed --all
			systemctl --failed --all > Systemderrlog
			msgFunc green "Done!"
			msgFunc green "All Failed Active Systemd Services"
			systemctl --failed
			systemctl --failed >> Systemderrlog
			msgFunc green "Done!"
			
			# -Logfiles:
			msgFunc green "Check log Journalctl for Errors"
			journalctl -p 3 -xb > Journalctlerrlog
			msgFunc green "Done!"
			
			#check if ssd trim functioning  ok in log
			#am I on a sdd drive? , 0 for SDD 1 for HDD from command
			SDX="$(df /boot/ --output=source | tail -1 | cut -c 6-8)"
			SDX=$(grep 0 /sys/block/"$SDX"/queue/rotational) 
			if [ "$SDX" = "0" ] 
				then
				msgFunc green "Check Journalctl for fstrim SSD trim"
				echo "SSD trim" > JournalctlerrSDDlog
				journalctl -u fstrim > JournalctlerrSDDlog
				msgFunc green "Done!"
				else 
				msgFunc red "HDD detected no SSD trim check done"
			fi
			# Checking for broken symlinks:
			msgFunc green "Checking for Broken Symlinks"
            find / -path /proc -prune -o -type l -! -exec test -e {} \; -print 2>/dev/null > symlinkerr
            #version pre-2.1 just for home
            #find "$HOME" -type l -! -exec test -e {} \; -print > symlinkerr
			msgFunc green "Done!"
			msgFunc norm " "
}
#FUNCTION HEADER
# NAME :          SystemBackFunc
# DESCRIPTION:carries out Full system backup + gdrive sync 
#to google drive
# INPUTS:  configfile from readconfigFunc   
# OUTPUTS : backups see OptionsB2 array
# PROCESS : system backup(5 options) + gdrive sync 
#NOTES :    needs gdrive and gnu-netcat installed if using gdrive option
function SystemBackFunc
{
			#get paths from config file if exists
			clear
			readconfigFunc
			msgFunc green "Done!"
			#get user input for backup
			optionsB1=("$Destination1" "$Destination2" "$Dest3" \
			"Custom" "gdrive" "Return")
			#variable to be passed to msgFunc dir : custom path
			local D3=""
			msgFunc blue "Pick destination directory for system backup or gdrive option"
			select  choiceBack in "${optionsB1[@]}"
			#check that paths exist and change path to dest path
			do
			case "$choiceBack" in
			
			"${optionsB1[0]}")  cd "$Destination1" || exitHandlerFunc dest1 
											D3="1";;				
			"${optionsB1[1]}")  cd "$Destination2"   || exitHandlerFunc dest2 
											D3="1";;
			"${optionsB1[2]}")  cd "$Dest3" || exitHandlerFunc dest3;;
			"${optionsB1[3]}")  #custom path read in 
						msgFunc norm "Type a custom destination path:-"
						read -r Path1		
						cd "$Path1" || exitHandlerFunc dest4 
						D3="1"
						;;
			"${optionsB1[4]}")   #gdrive function sync with two dirs in google drive
					msgFunc green "gdrive sync with remote documents directory"
					 #check gnu-cat is installed
					msgFunc checkpac gnu-netcat "Accessing Network ...."
					if [ "$?" != 0 ]
					then
						msgFunc red "Please install gnu-netcat for gdrive function to work"
						msgFunc anykey 
					return
					fi
					#check net up
					msgFunc checkNet "google.com"
					 #check gdrive is installed
					msgFunc checkpac gdrive 
					if [ "$?" != 0 ]
					then
						msgFunc anykey 
					return
					fi
					msgFunc green "gdrive sync with  remote directory path number one:-"
					gdrive sync upload "$gdriveSource1" "$gdriveDest1"
					msgFunc green "Done!"
					msgFunc green "gdrive sync with remote remote directory path number two:-"
					gdrive sync upload  "$gdriveSource2" "$gdriveDest2"
					msgFunc green "Done!"
					return ;;				
			*) return ;;
			esac
			break
			done
			
			#make the backup directory
			msgFunc dir "-BACKUP" "$D3"
			#begin the backup get user choice from user to what to back up
			optionsB2=("Copy of 1st 512 bytes MBR" "Copy of etc dir" \
"Copy of home dir" "Copy of package lists" "Make tarball of all" "ALL" "Return")
			msgFunc blue "Pick a Backup option:-"
			select  choiceBack2 in "${optionsB2[@]}"
			do
			case  "$choiceBack2" in
			"${optionsB2[0]}"|"${optionsB2[5]}") #MBR
				msgFunc green "Make copy of first 512 bytes MBR with dd"
				#get /dev/sdxy where currenty filesystem is mounted 
				myddpath="$(df /boot/ --output=source | tail -1)"
				msgFunc norm "$myddpath"
				sudo dd if="$myddpath" of=hda-mbr.bin bs=512 count=1
				msgFunc green "Done!"
            ;;&
			"${optionsB2[1]}"|"${optionsB2[5]}")#etc
				msgFunc green "Make a copy of etc dir"
				sudo cp -a -v -u /etc .
				msgFunc green "Done!"
            ;;&
            "${optionsB2[2]}"|"${optionsB2[5]}")#home
				msgFunc green "Make a copy of home dir"
				sudo cp -a -v -u /home .
				msgFunc green "Done!"
				sync
			;;&
			"${optionsB2[3]}"|"${optionsB2[5]}")#packages
				msgFunc green "Make copy of package lists"
				pacman -Qqen > pkglistQgenNAT.txt
				pacman -Qm > pkglistQmAUR.txt
				pacman -Q  > pkglistQALL.txt
				msgFunc green "Done!"
            ;;&
            "${optionsB2[4]}"|"${optionsB2[5]}")#tar
				msgFunc green "Make tarball of all except tmp dev proc sys run"
				sudo tar --one-file-system --exclude=/tmp/* --exclude=/dev/* --exclude=/proc/* --exclude=/sys/* --exclude=/run/* -pzcvf RootFS_backup.tar.gz /
				msgFunc green "Done!"
				sync 
				;;&
			  *)#quit
				msgFunc green "ALL Done!"
				return
			;;&
			esac
			break 
			done
}
#FUNCTION HEADER
# NAME :  AntiMalwareFunc 
# DESCRIPTION: Function for ROOTKIT HUNTER software
#anti virus with clamscan
# INPUTS:  $1  CLAMAV or "RKHUNTER"
# OUTPUTS : backups see OptionsB2 array
# PROCESS : clamav and rkhunter full scans
#NOTES :    needs clamav and rkhunter installed  
function AntiMalwareFunc
{
#clamav section
	if [ "$1" = "CLAMAV" ]
				then
            #check clamav is installed
            msgFunc checkpac clamav
            if [ "$?" != 0 ]
				then
				msgFunc anykey 
				return
			fi
			# update clamscan virus definitions:
			msgFunc green "Updating clamavscan Databases"
			sudo freshclam
			msgFunc green "Done!"
			msgFunc green "Scanning with Clamav$"
			# scan entire system
			msgFunc dir "-INFO"
			sudo clamscan -l clamavlogfile --recursive=yes --infected --exclude-dir='^/sys|^/proc|^/dev|^/lib|^/bin|^/sbin' /
			msgFunc green "Done!"			
			return
	fi
			
#Rootkitsection
	#check rkhunter is installed
	msgFunc checkpac rkhunter
	if [ "$?" != 0 ]
	then
		msgFunc anykey 
	return
	fi
	msgFunc green "Checking rkhunter data files"
	sudo rkhunter --update
	msgFunc green "Done!"
	msgFunc green "Fill the file properties database"
	sudo rkhunter --propupd
	msgFunc green "Done!"
	msgFunc green "Running Rootkit hunter"
	sudo rkhunter --check
	msgFunc green "Done!"
	msgFunc anykey
}

#FUNCTION HEADER
# NAME :            ccryptFunc
# DESCRIPTION :      function to use ccrpyt encrypt and decrypt files
# PROCESS :[1]   Encrypt. a file [2] decrypt  
# [3]   view a encrypted file                 
# [4]   view a decrypted file [5]  keychange
#NOTES :   needs ccrypt  installed 
function ccryptFunc
{
	clear
	msgFunc blue "ccrypt - encrypt and decrypt files:-"
	#check if ccrypt installed
	msgFunc checkpac ccrypt
    if [ "$?" != 0 ]
	then
		msgFunc anykey 
	return
	fi
	msgFunc norm "Type a path to the folder you want to work with:-"
	read -r myccfile
	cd "$myccfile" || exitHandlerFunc dest4
	ls -la
	msgFunc norm "Type the file name  you want to work with:-"
	read -r myccfile
	 if [ -f "$myccfile"  ] 
	 then 
		msgFunc norm 'Found file!' 
	 else
		msgFunc red 'File out found!'
		exitHandlerFunc exitout
	 fi
	 msgFunc blue "ccrypt - encrypt and decrypt files Menu options:-"
	optionscc=("Encrypt a file " "Decrypt a file" "View encrypted file" \
"Edit decrypted file with NANO" "Change the key of encrypted file" "Return")
			select choicecc in "${optionscc[@]}"
			do
			case "$choicecc" in 
			 "${optionscc[0]}") #Encrypt.
			   msgFunc green "Decrypt  a files to standard output., ccrypt -e"
				ccrypt -e "$myccfile"
			 ;;
			 "${optionscc[1]}") #Decrypt
			 msgFunc green "Decrypt  a files to standard output., ccrypt -d"
			   ccrypt -d "$myccfile"
			 ;;
			 "${optionscc[2]}") #Decrypt  files to standard output.
				msgFunc green "Decrypt  file to standard output., ccrypt -c"
				 ccrypt -c "$myccfile"
			 ;;
			 "${optionscc[3]}") #Edit a Decrypted file
			    msgFunc green "Edit a Decrypted file with nano text editor, nano"
				nano "$myccfile"
			 ;;
			 "${optionscc[4]}") #Change the key of encrypted data
				msgFunc green "Change the key of encrypted file, ccrypt -x"
				ccrypt -x "$myccfile"
			 ;;
			 *)  #exit  
				     msgFunc green "Done!"	
				     msgFunc anykey
				     clear
					return
					;;
			esac
			break
			done
			msgFunc green "Done!"
}

#FUNCTION HEADER
# NAME :  SystemCleanFunc 
# DESCRIPTION: Function for cleaning programs files and system  
# with bleachbit also deletes trash can and download folder.
# PROCESS : 16 see optionsbb array.
#NOTES :    needs bleachit installed
function SystemCleanFunc
{
		     #check bleachbit is installed
			msgFunc checkpac bleachbit 
			if [ "$?" != 0 ]
			then
				msgFunc anykey 
			return
			fi
		    clear
		   #system clean with bleachbit
		   msgFunc blue "System clean with Bleachbit:-"
			optionsbb=("bash" "Epiphany" "Evolution" "GNOME" "Rhythmbox" "Thumbnails" \
			"Thunderbird" "Transmission" "VIM" "VLC media player" "X11" "deepscan" \
			"flash" "libreoffice" "System" "Firefox" \
			"ALL bleachbit options" "Trash + Download folder clean (non bleachbit)" "Return")
			select choicebb in "${optionsbb[@]}"
			do
			case "$choicebb" in 
				   
				   "${optionsbb[16]}")
				   msgFunc green "ALL - Full Bleachbit clean"
				   ;;&  
				   "${optionsbb[0]}"|"${optionsbb[16]}")
				   msgFunc green "Clean bash"
				   bleachbit --clean bash.*
				   ;;&
				   "${optionsbb[1]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Epiphany"
				   bleachbit --clean epiphany.*
				   ;;&
				   "${optionsbb[2]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Evolution"
				   bleachbit --clean evolution.*
				   ;;&
				   "${optionsbb[3]}"|"${optionsbb[16]}")
				   msgFunc green "Clean GNOME"
				   bleachbit --clean gnome.*
				   ;;&
				   "${optionsbb[4]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Rhythmbox"
				   bleachbit --clean rhythmbox.*
				   ;;&
				   "${optionsbb[5]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Thumbnails"
				   bleachbit --clean thumbnails.*
				   ;;&
				   "${optionsbb[6]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Thunderbird"
				   bleachbit --clean thunderbird.*  
				   ;;&
				   "${optionsbb[7]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Transmission"
				   bleachbit --clean transmission.*
				   ;;&
				   "${optionsbb[8]}"|"${optionsbb[16]}")
				   msgFunc green "Clean VIM"
				   bleachbit --clean vim.*
				   ;;&
				   "${optionsbb[9]}"|"${optionsbb[16]}")
				   msgFunc green "Clean VLC media player"
				   bleachbit --clean vlc.*
				   ;;&
				   "${optionsbb[10]}"|"${optionsbb[16]}")
				   msgFunc green "Clean X11"
				   bleachbit --clean x11.*
				   ;;&
				   "${optionsbb[11]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Deep scan"
				   bleachbit --clean deepscan.*
				   ;;&
				   "${optionsbb[12]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Flash"
				   bleachbit --clean flash.*
				   ;;&
				   "${optionsbb[13]}"|"${optionsbb[16]}")
				   msgFunc green "Clean libreoffice"
				   bleachbit --clean libreoffice.*
				   ;;&
    			   "${optionsbb[14]}"|"${optionsbb[16]}")
    			   msgFunc green "Clean System"
				   sudo bleachbit --clean system.*
				   ;;&
				   "${optionsbb[15]}"|"${optionsbb[16]}")
				   msgFunc green "Clean Firefox"
					bleachbit --clean firefox.*
				   ;;&
				   "${optionsbb[17]}")  msgFunc green "Deleting  Trash + downloads folder"
						 rm -rvf /home/gavin/.local/share/Trash/*
						 rm -rvf "$HOME"/Downloads/*
					;;&
				    *)  #exit  
				     msgFunc green "Done!"	
				     msgFunc anykey
				     clear
					return
					;;
		esac
		done
		#msgFunc green "Done!"	
}

#FUNCTION HEADER
# NAME :  RmLintFunc 
# DESCRIPTION: Function for crmlint - 
#find duplicate files and other space waste efficiently
# PROCESS : rmlint scan 
#NOTES :    needs rmlint installed
function RmLintFunc
{
	clear
	msgFunc green "Running rmlint"
cat <<-EOF
rmlint finds space waste and other broken things on your filesystem.
It then produces a report and a shellscript called rmlint.sh that 
contains readily prepared shell commands to remove duplicates and other 
finds. cylon wrapper  will scan, then optionally show report and then  
optionally execute the rmlint.sh.
EOF
	     #check crmlint is installed
            msgFunc checkpac rmlint
            if [ "$?" != 0 ]
				then
				msgFunc anykey 
				return
			fi
			msgFunc line
			msgFunc norm "Type a  directory path you wish to scan:-"
			read -r rmlintPath	            
		     cd "$rmlintPath" || exitHandlerFunc dest4
			msgFunc norm " "
			msgFunc green "Press g for progress bar any other key for list [g/L]"
			read -r choicermlint
			if [ "$choicermlint" = "g" ]
				then
					# run with progress bar 
					rmlint -g
				else
					rmlint
			fi
			msgFunc line
			msgFunc anykey
			#display the results file option? 
			msgFunc green "Display results file? press Any key or n to quit [Y/n]"
			read -r choicermlint1
			if [ "$choicermlint1" != "n" ]
			then
				msgFunc green  "rmlint output file"
				more rmlint.json		
				msgFunc line
				msgFunc anykey
				#run the shell option?
				msgFunc green "Execute rmlint.sh file? press e or any key to quit [e/N]"
				msgFunc red "Warning rmlint.sh will change your system based on results of the previous scan"
			    read -r choicermlint2
					if [ "$choicermlint2" = "e" ]
					then
						msgFunc green  "running rmlint.sh output file"
						./rmlint.sh -d
					else
						msgFunc green "Done!"
						return
					fi
			else
				msgFunc green "Done!"
				return
			fi
			msgFunc green "Done!"
}

#FUNCTION HEADER
# NAME :  exitHandlerFunc 
# DESCRIPTION: error handler deal with user 
#exists and path not found errors and internet failure 
# INPUTS:  $2 text of internet site down
# PROCESS : exitout dest 1-5 netdown 
function exitHandlerFunc
{
	case "$1" in
			#dest1 = backup path #dest2 = backup path
			#dest3 = program output #dest4 = general
			#dest5 = config file  #dest6  = Documentation
	        exitout) msgFunc norm " " ;;
			dest1) msgFunc red "Path not found to destination directory"	
				  msgFunc norm "$Destination1" ;;
			dest2) msgFunc red "Path not found to destination directory"
				  msgFunc norm "$Destination2" ;;			
			dest3) msgFunc red "Path not found to destination directory"
			     msgFunc norm "$Dest3" ;;
			dest4) msgFunc red "Path not found to directory"  ;;
			dest5) msgFunc red "Path not found to destination directory"
			     msgFunc norm "$Dest5" ;;
			dest6) msgFunc red "Path not found to destination directory"
			     msgFunc norm "$Dest6" ;;
			 netdown) msgFunc red "Internet connectivity test to $2 failed" ;;
	 esac
	msgFunc blue "GOODBYE $USER!!"
	msgFunc anykey "and exit."
	exit
}
#==================MAIN CODE HEADER====================================
clear
#print horizontal line  + title
msgFunc line
msgFunc green "******* $(pacman -Qs cylon | head -1 | cut -c 7-20) (CYbernetic LifefOrm Node)   *******" 
msgFunc line
msgFunc norm
#Program details print
cat <<-EOF
Cylon is an Arch Linux maintenance CLI program written in Bash script.
This program provides numerous tools to Arch Linux users to carry 
out updates, maintenance, system checks and backups. 

EOF
date +%A-Week%U-%d-%B-%Y--%T
msgFunc norm " " 
#main program loop    
while true; do
	cd ~ || exitHandlerFunc dest4
    msgFunc blue "Cylon Main Menu :-"
	optionsM=("Pacman options" "Cower options (AUR)" "System check" \
	 "System backup" "System clean" "System information " "Rmlint scan" \
	 "Lostfiles scan" "Clamav scan" "RootKit hunter scan" "Ccrypt utility"\
	  "Password generator" "Display cylon information" "Exit")
	select choiceMain in "${optionsM[@]}"
	do
    case "$choiceMain" in
		"${optionsM[0]}")   #pacman update
			 PacmanFunc
			  ;;
		"${optionsM[1]}") #cower AUR helper
		    CowerFunc
		     ;;
		"${optionsM[2]}") #system maintenance
			SystemMaintFunc
			;;
		"${optionsM[3]}")  #Full system backup
		   	SystemBackFunc
		   	 ;;
		 "${optionsM[4]}") #system clean with bleachbit
		   SystemCleanFunc
		    ;;
		"${optionsM[5]}") #system info
		   HelpFunc "SYS"
		   ;;
		"${optionsM[6]}") #rmlint 
		   RmLintFunc
		    ;;
		"${optionsM[7]}")#lostfiles(AUR))
		   lostfilesFunc 
		   ;;
		"${optionsM[8]}") 	#Anti-virus clamav
			AntiMalwareFunc "CLAMAV"
			 ;;
		 "${optionsM[9]}")  #rootkit hunter 
			AntiMalwareFunc "RKHUNTER"
			;;
		"${optionsM[10]}")  # ccrypt - encrypt and decrypt files 
			ccryptFunc
			 ;;
		"${optionsM[11]}")  # password generator 
				msgFunc green "Random Password generator"
				msgFunc norm "Enter length:-"
				read -r mylength
				if [ -z "$mylength" ]; then
					mylength=50
				fi
				msgFunc dir "-PG"
			    echo -n "$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c"${1:-$mylength}";)"	> pg	  
				msgFunc green "Done!"
		  ;;
		"${optionsM[12]}")  # cylon info and cat readme file to screen 
			HelpFunc "HELP"
		;;
		*)  #exit  
			exitHandlerFunc exitout ;;
	esac
	break
	done
done
#======================End of MAIN code ===============================

