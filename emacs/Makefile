# Create a distribution of kjv-mode for emacs

# by Timothy D Witham <twitham@sbcglobal.net>

# which artist am I based on directory name
WHO:=$(shell pwd | perl -pe 's{.*/}{}')

# make a distribution for this set of audio files
dist:
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
	KJV/${WHO}/Makefile

clean:
	rm kjv-mp3-map.txt lrc.log *.lrc
