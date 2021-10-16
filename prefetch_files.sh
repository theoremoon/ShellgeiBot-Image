#!/bin/sh
# docker build中のダウンロードに失敗しやすいファイルを事前にダウンロードしておく
# * curl

set -eu

DOWNLOAD_DIR=$(cd "$(dirname "$0")"; pwd)/prefetched

# go
[ -f "$DOWNLOAD_DIR/go.tar.gz" ] || {
  curl -sfSL --retry 5 https://dl.google.com/go/go1.17.2.linux-amd64.tar.gz -o "$DOWNLOAD_DIR/go.tar.gz"
}

# chromium
[ -f "$DOWNLOAD_DIR/chrome-linux.zip" ] || {
  curl -sfSL --retry 5 "https://download-chromium.appspot.com/dl/Linux_x64?type=snapshots" -o "$DOWNLOAD_DIR/chrome-linux.zip"
}

# julia
[ -f "$DOWNLOAD_DIR/julia.tar.gz" ] || {
  curl -sfSL --retry 5 "https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.3-linux-x86_64.tar.gz" -o "$DOWNLOAD_DIR/julia.tar.gz"
}

# openjdk
[ -f "$DOWNLOAD_DIR/openjdk16.tar.gz" ] || {
  curl -sfSL --retry 5 "https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz" -o "$DOWNLOAD_DIR/openjdk17.tar.gz"
}
