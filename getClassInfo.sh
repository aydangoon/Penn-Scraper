#!/bin/bash

wget -O tempFile.html -o /dev/null https://www.registrar.upenn.edu/roster/$1.html

courseCode=${1^^}

cat tempFile.html | sed -n -e "/^\(<p>\)*$courseCode *-$2/,/^ *$/ p" | sed '/^ *$/q' >> $1$2.txt

rm tempFile.html

./cleanup.sed $1$2.txt > temp.txt

./refine.sed temp.txt > tempRefined.txt

rm $1$2.txt

rm temp.txt

mv tempRefined.txt $1$2.txt

if [ ! -s $1$2.txt ] 
then
	echo "Course '$1 $2' doesn't exist or not offered"
	rm $1$2.txt
else
	wget -O tempFile.html -o /dev/null https://catalog.upenn.edu/courses/$1/
	cat tempFile.html | grep -A1 "<strong>$courseCode $2.*</strong>" >> $1$2Description.txt

	rm tempFile.html

	sed -i "s|</p>.*\"courseblock\">$||" $1$2Description.txt 

	./cleanup.sed $1$2Description.txt  > temp.txt

	rm $1$2Description.txt

	mv temp.txt info$1$2.txt

	cat info$1$2.txt >> tempFile

	echo >> tempFile

	cat $1$2.txt | sed 1d >> tempFile

	rm $1$2.txt

	rm info$1$2.txt

	mv tempFile $1$2.txt

	cat $1$2.txt

fi
