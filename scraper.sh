#!/bin/bash
MODE=0
EMAIL=1
PHONE=1
SOURCE=
COUNTER=0
for ARG in "$@"
do
	COUNTER=$(( $x+1 ))
	case $ARG in
		-h|--help) echo "~~~~~~~~~~~~~~~~~~~~~~~~~SCRAPER V.0.0.1~~~~~~~~~~~~~~~~~~~~~~~~"
			echo
			echo "This program takes in a URL or a file address, extracts all the emails and phone numbers and saves them in emails.txt and phonenumbers.txt respectively."
			echo
			echo
			echo "USAGE: ./scraper.sh [OPTION] [URL/FILE]"
			echo
			echo "-h, --help"
			echo "	displays this screen containing info on how to use the program"
			echo "-f, --file"
			echo "	allows you to use a filename instead of a URL"
			echo "-e, --email"
			echo "	only scrapes the email addresses; doesn't bother with the phone numbers"
			echo "-p, --phone"
			echo "	only scrapes the phone numbers; doesn't bother with the email addresses"
			echo
			echo
			echo "if no arguments are used, the program retrieves both phone numbers and email addresses from a website."
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			MODE=-1
		;;
		-f|--file)
			MODE=1
			SOURCE=$COUNTER
			SOURCE=$(( $SOURCE+1 ))
			SOURCE=${!SOURCE}
		;;
		-e|--email)
			PHONE=0
		;;
		-p|--phone)
			EMAIL=0
		;;
		*)
			if [ -z $SOURCE ]; then
				SOURCE=$ARG
			fi
		;;
	esac
done

if [ $# -eq 0 ]; then
	echo "USAGE: ./scraper.sh [OPTION] [URL/FILE]"
	echo "try './scraper.sh -h' or './scraper.sh --help' for more information."
	MODE=-1
fi

if [ $EMAIL -eq 0 ] && [ $PHONE -eq 0 ]; then
	EMAIL=1
	PHONE=1
fi

if [ $MODE -eq 0 ] || [ $MODE -eq 1 ]; then
	if [ -z $SOURCE ]; then 
		echo "Argument missing: FILE/URL" 1>&2
		exit
	fi
	if [ $MODE -eq 0 ]; then
		wget -O temp.html $SOURCE
		SOURCE=temp.html
	elif [ ! -e $SOURCE ]; then
		echo "File $SOURCE doesn't exist!" 1>&2
		exit
	fi
	if [ $PHONE -eq 1 ]; then
		cat $SOURCE | grep -o '[0-9]\{3\}-[0-9]\{3\}-[0-9]\{4\}' | cat > phonenumbers.txt
		cat $SOURCE | grep -o '([0-9]\{3\}) [0-9]\{3\}-[0-9]\{4\}' | cat >> phonenumbers.txt
		cat $SOURCE | grep -o '([0-9]\{3\})[0-9]\{3\}-[0-9]\{4\}' | cat >> phonenumbers.txt
		cat phonenumbers.txt | sed -r 's/(\()([0-9]{3})(\)) ([0-9]{3}-[0-9]{4})/\2-\4/g' | sed -r 's/(\()([0-9]{3})(\))([0-9]{3}-[0-9]{4})/\2-\4/g' | cat > phonenumbersTemp.txt
		mv -f phonenumbersTemp.txt phonenumbers.txt
	fi
	if [ $EMAIL -eq 1 ]; then
		cat $SOURCE | grep -oE "[a-zA-Z0-9._!#$%&*\+\-\/=?^{|}~]+@([a-zA-Z0-9_&\+\-]+\.)+[a-zA-Z0-9_&\+\-]{2,3}" | cat > emails.txt
	fi
	if [ $MODE -eq 0 ]; then
		rm $SOURCE
	fi
fi
