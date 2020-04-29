#!/usr/local/Cellar/gnu-sed/4.8/bin/gsed -f

s/\(<p class="courseblocktitle noindent">\)\(<strong>\)*//

s/\(<p class="courseblockextra noindent">\)//

s/\(<a href="\/search\/?P=[A-Z]*%[0-9]*" title="\)\([A-Z]*\)\ \([0-9]*\)\(" class="bubblelink code" onclick="return showCourse(this, '[A-Z]* [0-9]*');">[A-Z]* [0-9]*<\/a>\)/\2 \3/

s/<a href="\/search\/?P=[A-Z]*%[0-9]*" title="\([A-Z]* [0-9]*\)" class="bubblelink code" onclick="return showCourse(this, '[A-Z]* [0-9]*');">[A-Z]* *[0-9]*<\/a>/\1/g

s/<p class="courseblockextra noindent">/\n/g

s/<\/div><div class="courseblock">/\n/g

s/<\/div><\/div><\/div><!--end #textcontainer -->//g

s/<\/p>//g

s/<\/strong>//g

s/Course usually offered in [a-z]* term//g

s/Notes: .*\.//g
