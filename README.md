# kjv-bible-lyric-files

This is King James Bible LRC files to sit alongside KJV audio files
for Scripture display while sound plays in your favorite player.  I
use MythMusic of MythTV.  Other options might be found at

https://en.wikipedia.org/wiki/LRC_(file_format)#Support

These .lrc files automaticlly distribute the time of the audio
recording across the "reading syllables" of the text.  This works well
most of the time with a display within a line or two of the sound.
The sound and text are occasionally off by as many as 4 lines.  My
player shows +/- 5 lines of lyrics so that the text is always visible.

YMMV.

"Reading syllables" are the syllables of the words plus:

* two syllables before and after chapter headers: { }
* two syllables for sentence ending punctuation: . ?
* one syllable for pause punctuation: , ; :
* one syllable for blank line paragraph separator

This yields a better timing than bytes, words or lines since it is
syllables and pauses that take the time.


# INSTALLATION

Simply copy the DIR/*.lrc files to the location of matching *.mp3
files.  Or, copy those matchng *.mp3 to the given DIR here.  AS/OF the
given dates, these options should work, until they don't.

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
YEAR:	1953
SOURCE:	https://www.audiotreasure.com/indexKJV.htm
AS/OF:	2022
NOTE:	soft music, faster


# EMACS

If you use emacs, copy site-lisp/kjv-mode.el to any directory on your
load-path and add something like this to ~/.emacs

   (autoload 'kjv-mode "kjv-mode" nil t)

Now find-file on DIR/kjv.txt should invoke kjv-mode for reading the
bible in emacs.  See C-h m for mode documentation.

copy bin/kjvmp3 to your $PATH for audio playback in emacs


# HOW TO [RE]GENERATE .lrc files for .mp3 files

These .lrc files were generated from the source AS/OF dates above.  If
the source audio changes, or to apply to different audio, the code can
be re-run against new .mp3 content.  This will require:

* the SWORD project and its diatheke command
* perl to run my code in bin/
* exiftool to measure .mp3 audio length
* make to fully automate the process from my Makefile

See Makefile to see the details of how the files are generated:

1. bin/kjv generates kjv.txt from https://crosswire.org/ 's SWORD
project, converting to a simple 75 column wide UTF-8 text format that
still includes italics, paragraphs and Words of Christ in quotes.

2. bin/kjvmp3 -s is used to measure words and syllables of each
chapter, see kjv.syb.txt

3. bin/kjvmp3 -r is used to generate a 365 day reading schedule aiming
for similar syllables per day while breaking between chapters, see
yearstat.txt.

4. bin/kjvmp3 -a is used to annotate the reading schedule into the
chapter headers, see kjv.syb.txt

5. bin/kjvmp3 -l is used to generate a .lrc file per .mp3


# AUTHOR

Timothy D Witham <twitham@sbcglobal.net>


# COPYRIGHT

Code copyright 2005 - 2025

General public license for distribution for any purpose
