#!/usr/bin/python

import PTN
import sys

torrentName = sys.argv[1]
info = PTN.parse(torrentName)
print(info["title"] + " S" + str(info['season']).zfill(2) + "E" + str(info['episode']).zfill(2))
