# -*- Mode: python; coding: utf-8; indent-tabs-mode: nil; -*-

import os
from common import culrcwrap
from            common.filetweak import LyricsFetcher
# make sure this-------^^^^^^^^^ matches this file's basename

info = {
    'name':        '*FileTweak',
    'description': 'Search the same directory as the track for lyrics, adjust tabs',
    'author':      'Paul Harrison and Tim Witham',
    'priority':    '80',       # after embeded, before filelyrics
    'version':     '2.0',
    'syncronized': True,
    'artist':      'Robb Benson',
    'title':       'Lone Rock',
    'album':       'Demo Tracks',
    'filename':    os.path.dirname(os.path.abspath(__file__)) + '/examples/filelyrics.mp3',
}

if __name__ == '__main__':
    culrcwrap.main(__file__, info, LyricsFetcher)

# most of the code moved to common/filetweak.py
