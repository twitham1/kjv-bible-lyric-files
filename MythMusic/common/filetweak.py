# -*- Mode: python; coding: utf-8; indent-tabs-mode: nil; -*-
"""
Scraper for file lyrics
"""

import sys, os, re, chardet
from optparse import OptionParser
from lib.utils import *
from common import *
import subprocess

# A tweaked copy of filelyrics.py.  Adjust leading tabs of my KJV
# lyrics to align well in MythBuntu basemedium font (Ubuntu:size=41).
# See changes near line 45.  -twitham@sbcglobal.net, 2022/10

__author__      = "Paul Harrison, tweaked by Timothy Witham"
__title__       = "FileTweak"
__description__ = "Search the same directory as the track for lyrics, adjust tabs"
__version__     = "0.2"
__priority__    = "80"         # use just before filelyrics.py
__lrc__         = True

debug = False

class LyricsFetcher:
    def __init__(self, *args, **kwargs):
        self.DEBUG = kwargs['debug']
        self.settings = kwargs['settings']

    def get_lyrics(self, song):
        log("%s: searching lyrics for %s - %s - %s" % (__title__, song.artist, song.album, song.title), debug=self.DEBUG)
        lyrics = Lyrics(settings=self.settings)
        lyrics.song = song
        lyrics.source = __title__
        lyrics.lrc = __lrc__

        filename = song.filepath
        filename = os.path.splitext(filename)[0]

        # look for a file ending in .lrc with the same filename as the track minus the extension
        lyricFile = filename + '.lrc'

        # hack!!! uncomment to get test.lrc column testing file:
        # lyricFile = re.sub(r'/[^/]+.lrc$', r'/test.lrc', lyricFile)

        log("%s: searching for lyrics file: %s " % (__title__, lyricFile), debug=self.DEBUG)
        if os.path.exists(lyricFile) and os.path.isfile(lyricFile):
            #load the text file
            with open (lyricFile, "r") as f:
                lines = f.readlines()

            for line in lines:
                match = re.search(r'(\b\w+ \d+[.:]\d+[.:])', line)
                if match:
                    result = subprocess.run([os.path.dirname(os.path.abspath(__file__)) + '/kjvwidth', match.group(1)], capture_output=True, text=True)
                    width = result.stdout
                    if int(width) < 239: # Ubuntu:size=41 width that needs another tab
                        line = re.sub(r'\t', r'\t\t', line, count=1)

                line = re.sub(r'\]\t', r']\t\t', line, count=1) # hack!!! to line up my KJV lyrics
                line = re.sub(r'(\.\d\d\])', r'\1\t', line) # shift right toward center

                # whitespace-only lines cause frontend to spew errors:
                # 2023-10-10 14:24:12.459743 I  Qt: QPainter::begin: Paint device returned engine == 0, type: 3
                # 2023-10-10 14:24:12.459749 E  MythPainter::GetImageFromTextLayout: Invalid canvas.
                # 2023-10-10 14:24:12.459751 D  MythPainter::DrawTextLayout: Rendered image is null.

                # but empty lines work just fine, so drop tab-only indent to empty string:
                line = re.sub(r'(\.\d\d\])\t$', r'\1', line)

                lyrics.lyrics += line

            return lyrics

        return False
