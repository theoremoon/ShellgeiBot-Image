#!/usr/bin/env bash
# docker build中のダウンロードに失敗しやすいファイルを事前にダウンロードしておく
set -eu

arch="${1:-$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')}"
[ "$arch" != "amd64" ] && [ "$arch" != "arm64" ] && {
  echo "$0: unsupported architecture: $arch"
  exit 1
}

DOWNLOAD_DIR=$(cd "$(dirname "$0")"; pwd)/prefetched
mkdir -p "$DOWNLOAD_DIR/$arch"

download() {
  local url="$1"
  local filename="$2"

  echo "downloading $filename ..."
  [ -f "$DOWNLOAD_DIR/$arch/$filename" ] || {
    curl -fSL --retry 5 "$url" -o "$DOWNLOAD_DIR/$arch/$filename"
  }
}

# go
if [ "$arch" = "amd64" ]; then download https://dl.google.com/go/go1.18.1.linux-amd64.tar.gz go.tar.gz; fi
if [ "$arch" = "arm64" ]; then download https://dl.google.com/go/go1.18.1.linux-arm64.tar.gz go.tar.gz; fi

# chromium (x64 only)
if [ "$arch" = "amd64" ]; then download "https://download-chromium.appspot.com/dl/Linux_x64?type=snapshots" chrome-linux.zip; fi
if [ "$arch" = "arm64" ]; then touch "$DOWNLOAD_DIR/$arch/chrome-linux.zip" ; fi  # dummy

# julia
if [ "$arch" = "amd64" ]; then download https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.6-linux-x86_64.tar.gz      julia.tar.gz; fi
if [ "$arch" = "arm64" ]; then download https://julialang-s3.julialang.org/bin/linux/aarch64/1.6/julia-1.6.6-linux-aarch64.tar.gz julia.tar.gz; fi

# openjdk
if [ "$arch" = "amd64" ]; then download https://download.java.net/java/GA/jdk18.0.1/3f48cabb83014f9fab465e280ccf630b/10/GPL/openjdk-18.0.1_linux-x64_bin.tar.gz     openjdk.tar.gz; fi
if [ "$arch" = "arm64" ]; then download https://download.java.net/java/GA/jdk18.0.1/3f48cabb83014f9fab465e280ccf630b/10/GPL/openjdk-18.0.1_linux-aarch64_bin.tar.gz openjdk.tar.gz; fi

# nodejs
node_version="$(curl -s https://nodejs.org/dist/index.json | jq -r '[.[]|select(.lts)][0].version')"
if [ "$arch" = "amd64" ]; then download "https://nodejs.org/dist/$node_version/node-$node_version-linux-x64.tar.gz"   nodejs.tar.gz; fi
if [ "$arch" = "arm64" ]; then download "https://nodejs.org/dist/$node_version/node-$node_version-linux-arm64.tar.gz" nodejs.tar.gz; fi

# mecab-ipadic (for NEologd)
(cd "${DOWNLOAD_DIR}/mecab-ipadic/"; sha1sum -c sha1sum.txt || curl -SfL "https://ja.osdn.net/frs/g_redir.php?m=kent&f=mecab/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz" -o mecab-ipadic-2.7.0-20070801.tar.gz)
