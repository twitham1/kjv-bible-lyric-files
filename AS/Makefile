# Create KJV lyric files for KJV mp3 files

# by Timothy D Witham <twitham@sbcglobal.net>

# must be run from a subdir/ holding 1189 .mp3 files:

# cd ARTIST/ && cp ../AS/Makefile Makefile && make

# which artist am I based on directory name
WHO:=$(shell pwd | perl -pe 's{.*/}{}')

# KJV mp3 player and lyric file generator, by twitham
KJVMP3=../bin/kjvmp3

all: lrc.log

# check that all chapters resolve to a .mp3 file here
kjv-mp3-map.txt: ../kjv.txt
	${KJVMP3} -c -f ../kjv.txt > kjv-mp3-map.txt

# generate *.lrc lyrics for all *.mp3
lrc.log: ../kjv-syb.txt kjv-mp3-map.txt
	${KJVMP3} -l -f ../kjv-syb.txt | tee lrc.log

# make a distribution for this set of audio files
dist: lrc.log
	cd .. && \
	egrep -A6 '^DIR:	${WHO}' README.md > ${WHO}/README && \
	cat ./${WHO}/README > README && \
	cat README.md >> README && \
	cd .. && \
	tar zcvf KJV-${WHO}.tgz \
	KJV/README \
	KJV/COPYING \
	KJV/Makefile \
	KJV/*.txt \
	KJV/bookmarks.ps \
	KJV/site-lisp \
	KJV/bin \
	KJV/${WHO}/README \
	KJV/${WHO}/Makefile \
	KJV/${WHO}/*.txt \
	KJV/${WHO}/*.log \
	KJV/${WHO}/*.lrc

clean:
	rm kjv-mp3-map.txt lrc.log *.lrc
