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

# get the text, measure, plan reading, annotate
all: yearsum.txt

# format whole KJV from Sword
kjv.tmp:
	${KJV} gen 1-2000 > kjv.tmp

# measure words and syllables of the text
kjv-syb.tmp: kjv.tmp
	${KJVMP3} -s -f kjv.tmp > kjv-syb.tmp

# generate yearly reading plan
yearplan.txt: kjv-syb.tmp
	${KJVMP3} -r 365 -f kjv-syb.tmp > yearplan.txt

# annotate reading plan into kjv.txt and summarize
yearsum.txt: yearplan.txt
	cp kjv.tmp kjv.txt
	cp kjv-syb.tmp kjv-syb.txt
	${KJVMP3} -a -f yearplan.txt kjv.txt kjv-syb.txt
	grep ' 1/' kjv.txt | perl -pe 's/.*\{ (.+) Chapter (\d+).*\*\* (.+)\s+(\S+) \*\*/sprintf "%-13s %3s  %s %s", $3, $4, $1, $2/e' > yearsum.txt

clean:
	rm kjv*.tmp kjv*.txt year*.txt
