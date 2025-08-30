# kjv-bible-lyric-files

SOURCE:	https://github.com/twitham1/kjv-bible-lyric-files

The King James Holy Bible in 1189 Lyric format files (*.lrc)

This code generates LRC text files to sit alongside KJV audio files
for scripture display while corresponding audio plays in your favorite
player.  I use MythMusic of MythTV.  Other options might be found at:

https://en.wikipedia.org/wiki/LRC_(file_format)#Support

Grab a release file from github to get a full set of .lrc files for
compatible .mp3 files, see INSTALL options below.

Text to audio synchronization is not perfect.  Rather, the time of the
audio recording is automatically distributed across the "reading
syllables" of the text.  This yields a display within a line or two of
the sound most of the time.  Displaying 1 line at a time will not
work.  The sound and text occasionally drift by up to +/- 5 lines so
displaying 11 or more lines of context is recommended.

"Reading syllables" are the syllables of the words plus:

* two syllables around a chapter header: { }
* two syllables for sentence ending punctuation: . ? !
* one syllable for pause punctuation: , ; :
* one syllable for blank line paragraph separator

This yields a better timing than bytes, words or lines.


# INSTALLATION

Simply copy the DIR/*.lrc files to the location of matching *.mp3
files.  Or, copy those matching *.mp3 to the given DIR here.  AS/OF
the given dates, these options worked for me, YMMV.

DIR:	AS/
ARTIST:	Alexander Scourby
YEAR:	1953
SOURCE:	https://earnestlycontendingforthefaith.com/ListenToTheKingJamesBible.html
AS/OF:	2024
NOTE:	the original KJV audio was on 169 LP records!

DIR:	DW/
ARTIST:	Rev Dan Wagner
YEAR:	1999
SOURCE:	https://www.audiotreasure.com/AT_KJVA.htm
AS/OF:	2022
NOTE:	voice only, slower

DIR:	SJ/
ARTIST:	Stephen Johnston
YEAR:	1999
SOURCE:	https://www.audiotreasure.com/indexKJV.htm
AS/OF:	2022
NOTE:	soft music, faster

DIR:	emacs/
ARTIST:	Timothy D Witham
YEAR:	2005
SOURCE:	./site-lisp/kjv-mode.el ./bin/kjvmp3
AS/OF:	2005
NOTE:	No .lrc at all but rather a scripture reading mode for Emacs


# EMACS

If you use emacs, copy site-lisp/kjv-mode.el to any directory on your
emacs load-path and add something like this to ~/.emacs

   (autoload 'kjv-mode "kjv-mode" nil t)

Now M-x find-file on ./kjv.txt should invoke kjv-mode for reading the
Bible in emacs.  See C-h m for mode documentation.

Symlink the directory of your *.mp3 to ~/.kjv, something like:

	ln -s /usr/local/share/doc/KJV/AS ~/.kjv

then copy bin/kjvmp3 to your $PATH for audio playback in emacs.  This
feature requires mplayer to also be installed on $PATH.


# Optional Yearly Reading Schedule

The header line of each .lrc file shows a date.  If all chapters are
read on these dates, this will read the whole bible from cover to
cover in a year.  Of course this date can simply be ignored when not
reading by this plan.

If used, this schedule aims for minimum range and standard deviation
of the reading syllables per day.  See yearplan.png for a graphical
view of this reading schedule.  See bookmarks.ps for this schedule in
bookmark format suitable for printing (try "make print").


# Optional Reformating of the Left Margin or Verse References

The left margin includes a full book, chapter, verse reference
followed by one ASII tab character before the text.  The continued
lines of the verse are prefixed with two tabs.  If your text alignment
is wrong or you prefer shorter verse references or different left
margin, please see ./README-TABS for alternate left margin options.


# Optional Text to Audio Synchronization Points

Every chapter audio has a playing duration and its text has a known
length in syllables.  This determines the average reading speed in
syllables per second.  The time of each line is then syllables so far
divided by the speed.  These average reading rates are automatically
calculated and logged in lrc.log.

As natural reading speed changes throughout a long chapter this causes
the synchronization to drift.  Drift can be reduced by introducing
synchronization points between verses.  Any verse could be manually
synchronized but so far this is being done only for the Alexander
Scourby files, mostly between paragraphs.  (This should be finished by
April 2026).  These sync points are indicated by the :verse: changing
its punctuation to .verse. and the sync count is appended in the file
(footer).  The lrc.log lists all reading rates between these sync
points.  See ./AS/.kjvmp3.pl for how sync points are recorded.


# Thoughts on .mp3 Bible Chapter METADATA

How do you keep track of 1189 chapters in your audio player?  DW and
SJ used filenames that sort in order via chapter number prefixes, so
that might be sufficient.  My copy of AS however did not do this so an
alphabetical sort of the files is not in biblical order.

What I do in either case is use a tool like puddletag (or mp3tag) to
give all files one Album name, like KJV-AS, and Artist and year.  Then
I assign 66 Disc numbers to the 66 books in order.  Then I assign the
chapters of the books as Track numbers of the Disc.  My player sorts
albums by disc and track, so this keeps the whole Bible in order even
if the file names don't sort well.

However, Disc can have no more than 99 tracks so Psalms can't fit in a
single Disc.  The solution is to combine Psalms and Proverbs into two
Discs and split them in half as follows:

* Psalm 1-90 stay on Disc 19
* Psalm 91-150 are reassigned to Disc 20 and Track 1-60
* Proverbs 1-31 stay on Disc 20 but move to Track 61-91

This way everything is in order and in 66 Discs matching 66 books,
with the above exceptions in only 2 books.  Psalms on Disc 20 are 90
more than their track number while Proverbs are 60 less.


# HOW TO [RE]GENERATE .lrc files for .mp3 files

These .lrc files were generated from the source AS/OF dates above.  If
the source audio changes, or to apply to different audio, the code can
be re-run against new .mp3 content.  This will require:

* SWORD project and its diatheke command (optional, to update kjv.txt)
* perl to run my code in bin/
* exiftool to measure .mp3 audio length
* make to fully automate the process from my Makefiles
* WHO/.kjvmp3.pl to describe the new audio, see */.kjvmp3.pl examples

See Makefile to see the details of how the files are generated:

1. bin/kjv generates kjv.txt from https://crosswire.org/ 's SWORD
project, converting to a 75 column UTF-8 text format that still
includes [italics], paragraphs and "Words of Christ".

2. bin/kjvmp3 -s is used to measure words and syllables of each line
and chapter, see kjv-syb.txt

3. bin/kjvmp3 -r is used to generate a 365 day reading schedule aiming
for similar syllables per day while breaking only between chapters,
see yearplan.txt.  This is then manually tweaked to perfection by
bin/kjvpng which keeps track of best plan ever found.

4. bin/kjvmp3 -a is used to annotate the reading schedule into the
chapter headers, see kjv.txt

5. bin/kjvmp3 -l is used to generate a .lrc file per .mp3, 1189 total


# AUTHOR

Timothy D Witham <twitham@sbcglobal.net>


# COPYRIGHT / LICENSE

My code is Copyright 2005-2025 under the GPLv3, see COPYING

The KJV text is module version 3.1 for SWORD which states:

It is in this spirit that we in turn offer the KJV2003 Project text
freely for any purpose.  Any copyright that might be obtained for this
effort is held by CrossWire Bible Society © 2003-2023 and CrossWire
Bible Society hereby grants a general public license to use this text
for any purpose.

Inquiries and comments may be directed to:
CrossWire Bible Society
modules@crosswire.org
http://www.crosswire.org

