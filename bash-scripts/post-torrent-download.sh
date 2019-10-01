#!/bin/bash

TORRENT_PATH=$TR_TORRENT_DIR/$TR_TORRENT_NAME
if [ -z "$TR_TORRENT_DIR" ]
then
   echo "Env TR_TORRENT_DIR is empty, exiting " >> ~/post-torrent-download-error.log
   exit 1
fi

if [[ -d "$TORRENT_PATH" ]]; then
    echo "$TORRENT_PATH is a directory"
elif [[ -f "$TORRENT_PATH" ]]; then
    echo "$TORRENT_PATH is a file"
else
    echo "$TORRENT_PATH is not valid" >> ~/post-torrent-download-error.log
    exit 1
fi

echo "Creating kodi dir for $TORRENT_PATH"
TMP=/tmp/transmission-kodi-temp
rm -rf $TMP
mkdir -p $TMP

if [[ "$TR_TORRENT_DIR" == *movies ]]; then
    DIR_NAME=$(/home/pi/python-scripts/parse-movie-dir-name.py "$TR_TORRENT_NAME")
    echo "dir name : $DIR_NAME"
    TARGET_DIR="$TMP/$DIR_NAME"
    echo "Target dir : $TARGET_DIR"
    mkdir "$TARGET_DIR"

    if [[ -d "$TORRENT_PATH" ]]; then
        ln -s "$TORRENT_PATH"/* "$TARGET_DIR/"
    elif [[ -f "$TORRENT_PATH" ]]; then
        ln -s "$TORRENT_PATH" "$TARGET_DIR/$TR_TORRENT_NAME"
    fi
    mv "$TARGET_DIR" /media/pi/sudheera_wd/movies
elif [[ "$TR_TORRENT_DIR" == *tv ]]; then
	SHOW_DIR=$(/home/pi/python-scripts/parse-tv-show-dir-name.py "$TR_TORRENT_NAME")	
	echo "Show dir name : $SHOW_DIR"
	SHOW_PATH="/media/pi/sudheera_wd/tv/$SHOW_DIR"
	echo "Show path : $SHOW_PATH"
	if [ ! -d "$SHOW_PATH" ]; then
		mkdir "$SHOW_PATH"
	fi
	SEASON_DIR=$(/home/pi/python-scripts/parse-tv-season-dir-name.py "$TR_TORRENT_NAME")
	echo "Season dir name : $SEASON_DIR"
	SEASON_PATH="$SHOW_PATH/$SEASON_DIR"
	echo "Season path : $SEASON_PATH"
	if [ ! -d "$SEASON_PATH" ]; then
        mkdir "$SEASON_PATH"
    fi
	EPISODE_DIR=$(/home/pi/python-scripts/parse-tv-episode-dir-name.py "$TR_TORRENT_NAME")
	echo "Episode name : $EPISODE_DIR"

	TARGET_DIR="$TMP/$EPISODE_DIR"
    echo "Target dir : $TARGET_DIR"
    mkdir "$TARGET_DIR"

    if [[ -d "$TORRENT_PATH" ]]; then
        ln -s "$TORRENT_PATH"/* "$TARGET_DIR/"
    elif [[ -f "$TORRENT_PATH" ]]; then
        ln -s "$TORRENT_PATH" "$TARGET_DIR/$TR_TORRENT_NAME"
    fi
    mv "$TARGET_DIR" "$SEASON_PATH"
else
   echo "$TR_TORRENT_DIR : path not ending with either 'tv' nor 'movies'" >> ~/post-torrent-download-error.log
fi

