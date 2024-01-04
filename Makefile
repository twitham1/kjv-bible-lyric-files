# Create KJV lyric files for www.audiotreasure.com KJV mp3 files, by
# Timothy D Witham <twitham@sbcglobal.net>

# generate kjv.txt from Sword, *.lrc from *.mp3, year*txt reading
# schedules based on mp3 length, annotate schedule into *.lrc

# KJV shell for Sword, by twitham
KJV=bin/kjv

# KJV mp3 player and lyric file generator
KJVMP3=bin/kjvmp3

all: yearsum.txt

# format whole KJV from Sword
kjv.txt:
	${KJV} gen 1-2000 > kjv.txt

# generate lyrics for all *.mp3, full output is needed for reading plan
lrc.log: kjv.txt
	${KJVMP3} -l | tee lrc.log

# generate yearly reading plan
yearplan.txt: lrc.log
	${KJVMP3} -r 365 > yearplan.txt
	${KJVMP3} -r 365 -v > yearstat.txt

# annotate reading plan into *.lrc and summarize
yearsum.txt: yearplan.txt
	${KJVMP3} -a yearplan.txt *.lrc \
	&& grep ' 1/' *.lrc | perl -pe 's/.*\{/\{/; s/Chapter //' > yearsum.txt

	# && cp kjv.txt kjv-read.txt \
	# && ${KJVMP3} -a yearplan.txt kjv-read.txt \
	# && touch -r kjv.txt kjv-read.txt \
	# && mv kjv-read.txt kjv.txt \
	# && grep ' 1/' kjv.txt | perl -pe 's/.*\{/\{/; s/Chapter //' > yearsum.txt
