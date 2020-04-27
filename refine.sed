#!/bin/sed -f

s/ LEC / Lecture /g

s/ REC / Recitation /g

s/ LAB / Lab /g

s/MAX:/CAPACITY:/g

s/MAX W\/CROSS LIST:/CAPACITY WITH CROSS LISTED SECTIONS:/g

s/ TR / Tuesdays, Thursdays /g

s/ MWF / Mondays, Wednesdays, Fridays /g

s/ WF / Wednesdays, Fridays /g

s/ MW / Mondays, Wednesdays /g

s/ M / Mondays /g

s/ T / Tuesdays /g

s/ W / Wednesdays /g

s/ R / Thursdays /g

s/ F / Fridays /g

/CROSS LISTED:\( [A-Z]*-[0-9]*\)*.*/d

s/PREREQUISITE:/Prerequisite:/g

s/ *RECITATION.*/Recitations:/g

s/ *LABORATORY.*/Labs:/g

s/LEC, REC/LECTURE AND RECITATION\nLectures:/g

s/LEC, LAB/LECTURE AND LAB\nLectures:/g

s/^ \([0-9]\{3\}\)\(.*\)*/ Section \1\2/g
