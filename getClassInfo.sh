#!/bin/bash

wget -O tempFile.html -o /dev/null https://www.registrar.upenn.edu/roster/$1.html

courseCode=${1^^}

sem=$(cat tempFile.html | grep -oh "[A-Z][a-z]* 2020")

if [ -z "$sem" ]
then
	sem="the current semester"
fi

cat tempFile.html | sed -n -e "/^\(<p>\)*$courseCode *-$2/,/^ *$/ p" | sed '/^ *$/q' > $1$2.txt

rm tempFile.html

./cleanup.sed $1$2.txt > temp.txt

./refine.sed temp.txt > tempRefined.txt

rm $1$2.txt

rm temp.txt

mv tempRefined.txt $1$2.txt

if [ ! -s $1$2.txt ] 
then
	echo "Course '$1 $2' doesn't exist or is not offered in $sem"
	rm $1$2.txt
else
	wget -O tempFile.html -o /dev/null https://catalog.upenn.edu/courses/$1/
	cat tempFile.html | grep -A1 "<strong>$courseCode $2.*</strong>" | ./cleanup.sed >> temp.txt

	rm tempFile.html

	mv temp.txt info$1$2.txt

	echo "$sem Semester:" >> tempFile

	echo >> tempFile

	cat info$1$2.txt >> tempFile


	cat $1$2.txt | sed 1d >> tempFile

	rm $1$2.txt

	rm info$1$2.txt

	mv tempFile $1$2.txt

fi

wget -O tempFile.html -o /dev/null https://www.registrar.upenn.edu/timetable/$1.html

courseCode=${1^^}

sem=$(cat tempFile.html | grep -oh "[A-Z][a-z]* 2020")

if [ -z "$sem" ]
then
        sem="the next semester"
fi

cat tempFile.html | sed -n -e "/^\(<p>\)*$courseCode *-$2/,/^ *$/ p" | sed '/^ *$/q' >> $1$2NextSem.txt

rm tempFile.html

./cleanup.sed $1$2NextSem.txt > temp.txt

./refine.sed temp.txt > tempRefined.txt

rm $1$2NextSem.txt

rm temp.txt

mv tempRefined.txt $1$2NextSem.txt

if [ ! -s $1$2NextSem.txt ]
then
        echo "Course '$1 $2' doesn't exist or is not offered in $sem"
        rm $1$2NextSem.txt
else
        wget -O tempFile.html -o /dev/null https://catalog.upenn.edu/courses/$1/
        
	cat tempFile.html | grep -A1 "<strong>$courseCode $2.*</strong>" | ./cleanup.sed >> temp.txt

        rm tempFile.html

        mv temp.txt info$1$2.txt

        cat info$1$2.txt >> tempFile

        cat $1$2NextSem.txt | sed 1d >> tempFile

        rm $1$2NextSem.txt

        rm info$1$2.txt

	echo "$sem Semester:" >> $1$2NextSem.txt

        echo >> $1$2NextSem.txt

        cat tempFile >> $1$2NextSem.txt

	rm tempFile

        cat $1$2NextSem.txt >> $1$2.txt

	rm $1$2NextSem.txt

fi
if [ -s $1$2.txt ]
then

	cat $1$2.txt | grep "Section [0-9]*.*\([A-Z]\)*" | sed "s/ Section [0-9]*//g" | sed "s/Lecture //g" | sed "s/Recitation //g" | sed "s/[0-9]\{1,2\}:*[0-9]\{0,2\}-[0-9]\{1,2\}:*[0-9]\{0,2\}[A-Z]*//g" | sed "s/[A-Z][a-z]*days,*//g" | sed "s/[A-Z]* [0-9]\{1,3\}[A-Z]\{0,1\}//g" | sed "s/[A-Z]\{2,\} [A-Z]\{2,\}//g" | sed "s/ \{2,\}//g" > instructorNames.txt

	cat instructorNames.txt | sed "s/STAFF//g" | sed "s/[A-Z]*\/[A-Z]*//g" > temp.txt

	rm instructorNames.txt

	mv temp.txt instructorNames.txt

	sed '/^$/d' instructorNames.txt > temp.txt

	rm instructorNames.txt

	mv temp.txt instructorNames.txt

	exec < instructorNames.txt
	let count=0

	while read LINE; do
   		ARRAY[$count]=$LINE
   		((count++))
	done

	if [ -s instructorNames.txt ]
	then
		wget -O tempFile.html -o /dev/null https://www.seas.upenn.edu/directory/departments.php
	fi

	if [ -f tempFile.html ]
	then
		for i in "${ARRAY[@]}"
		do
   		: 
   			lastName=$(echo $i | grep -oh "[A-Z]\{2,\}")
			lastName=${lastName,,}
			lastName=${lastName^}
   			firstInit=$(echo $i | grep -oh " [A-Z]" | sed "s/ //g")
			cat tempFile.html | grep "$firstInit[a-z]* *[A-Z]*\.* $lastName.*<a href=\"mailto:" > temp.txt
			./scraper.sh -f temp.txt -e
			email=$(cat emails.txt)
			lastName=${lastName^^}
			myTest=$(echo $email | grep -oh "seas.upenn.edu")
			if [ ${#myTest} -gt 14 ] || [ -z $email ]
			then
				rm temp.txt
			else
				cat $1$2.txt | sed "s/$lastName $firstInit/$lastName  $firstInit\n Instructor's Email: $email/g" > temp.txt
				rm $1$2.txt
				mv temp.txt $1$2.txt
			fi
		done
		rm emails.txt
		rm tempFile.html
		rm instructorNames.txt
	fi
fi
if [ -f $1$2.txt ]
then
	cat $1$2.txt
fi
