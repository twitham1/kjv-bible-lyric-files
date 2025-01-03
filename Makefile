# Create KJV lyric files for www.audiotreasure.com KJV mp3 files, by
# Timothy D Witham <twitham@sbcglobal.net>

# generate kjv.txt from Sword, *.lrc from *.mp3, year*txt reading
# schedules based on mp3 length, annotate schedule into *.lrc

WHO:=$(shell pwd | perl -pe 's{.*/}{}')

# KJV shell for Sword, by twitham
KJV=../bin/kjv

# KJV mp3 player and lyric file generator
KJVMP3=../bin/kjvmp3

# get the text, measure, plan reading, annotate, build lyrics
all: lrc.log

# format whole KJV from Sword
kjv.tmp:
	${KJV} gen 1-2000 > kjv.tmp

# measure words and syllables of the text
kjv.syb.tmp: kjv.tmp
	${KJVMP3} -s -t kjv.tmp > kjv.syb.tmp

# generate yearly reading plan
yearplan.txt: kjv.syb.tmp
	${KJVMP3} -r 365 > yearplan.txt
	${KJVMP3} -r 365 -v > yearstat.txt

# annotate reading plan into kjv.txt and summarize
yearsum.txt: yearplan.txt
	cp kjv.tmp kjv.txt
	cp kjv.syb.tmp kjv.syb.txt
	${KJVMP3} -a yearplan.txt kjv.txt kjv.syb.txt
	grep ' 1/' kjv.txt | perl -pe 's/.*\{/\{/; s/Chapter //' > yearsum.txt

# generate lyrics for all *.mp3
lrc.log: yearsum.txt
	${KJVMP3} -l | tee lrc.log

# make a distribution for this set of audio files
dist: lrc.log
	cd .. && \
	egrep -A6 '^DIR:	${WHO}' README.md > ${WHO}/README && \
	cat ./${WHO}/README > README && \
	cat README.md >> README && \
	tar zcvf KJV-${WHO}.tgz README ${WHO}/README \
	${WHO}/*.txt ${WHO}/*.log ${WHO}/*.lrc \
	site-lisp bin

clean:
	rm kjv*.tmp kjv*.txt year*.txt *.lrc lrc.log
