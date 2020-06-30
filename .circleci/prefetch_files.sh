#!/bin/sh

# docker build中のダウンロードに失敗しやすいファイルを事前にダウンロードしておく
# * curl

curl -sfSL --retry 5 https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz -o go.tar.gz

# Chromium ref: https://github.com/scheib/chromium-latest-linux/blob/master/update.sh
REVISION=$(curl -sS --retry 5 "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media") \
    && curl -sfSL --retry 5 -o chrome-linux.zip "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${REVISION}%2Fchrome-linux.zip?alt=media"
