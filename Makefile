# Create a 75 column wide UTF-8 KJV Bible text file for reading with a
# text editor like Emacs (see site-lisp/kjv-mode.el).  Include
# paragraphs, [italics] and "words of Christ".  Then measure the
# "reading syllables" of the text to generate a yearly reading plan to
# add to the chapter headers.

# by Timothy D Witham <twitham@sbcglobal.net>

# KJV shell for Sword, by twitham
KJV=bin/kjv

# KJV mp3 player and lyric file generator, by twitham
KJVMP3=bin/kjvmp3

# get the text, measure, plan reading, annotate, format bookmarks
all: kjv.txt bookmarks.ps

# format whole KJV from Sword
kjv.tmp:
	${KJV} gen 1-2000 > kjv.tmp

# measure words and syllables of the text
kjv-syb.tmp: kjv.tmp
	${KJVMP3} -s -f kjv.tmp > kjv-syb.tmp

# generate yearly reading plan
yearplan.txt: kjv-syb.tmp
	${KJVMP3} -r 365 -f kjv-syb.tmp > yearplan.tmp
	echo use bin/kjvpng to turn yearplan.tmp into yearplan.txt

# annotate reading plan into kjv.txt
kjv.txt: yearplan.txt kjv.tmp kjv-syb.tmp
	cp kjv.tmp kjv.txt
	cp kjv-syb.tmp kjv-syb.txt
	${KJVMP3} -a -f yearplan.txt kjv.txt kjv-syb.txt

# generate reading schedule bookmarks
bookmarks.txt: yearplan.txt
	${KJVMP3} -b -f yearplan.txt > bookmarks.txt

# reading schedule on a bookmark per month
bookmarks.ps: bookmarks.txt
	a2ps -M Letterdj -r --columns 3 -l 32 -B -o bookmarks.ps bookmarks.txt

# print six bookmarks on two double-sided pages
print: bookmarks.ps
	lpr -o sides=two-sided-long-edge bookmarks.ps

clean:
	rm kjv*.tmp kjv*.txt year*.txt
