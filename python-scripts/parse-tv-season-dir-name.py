#!/usr/bin/python

import PTN
import sys

torrentName = sys.argv[1]
info = PTN.parse(torrentName)
print(info["title"] + " - Season " + str(info['season']))
