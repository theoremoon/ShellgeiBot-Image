#!/usr/bin/env bash
# docker build中のダウンロードに失敗しやすいファイルを事前にダウンロードしておく
# * curl

set -eu

DOWNLOAD_DIR=$(cd "$(dirname "$0")"; pwd)/prefetched

# go
[ -f "$DOWNLOAD_DIR/go.tar.gz" ] || {
  curl -sfSL --retry 5 https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz -o "$DOWNLOAD_DIR/go.tar.gz"
}

# chromium
[ -f "$DOWNLOAD_DIR/chrome-linux.zip" ] || {
  curl -sfSL --retry 5 "https://download-chromium.appspot.com/dl/Linux_x64?type=snapshots" -o "$DOWNLOAD_DIR/chrome-linux.zip"
}
