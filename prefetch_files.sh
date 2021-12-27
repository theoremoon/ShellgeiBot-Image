#!/usr/bin/env bash
# docker build中のダウンロードに失敗しやすいファイルを事前にダウンロードしておく
set -eu

arch="${1:-$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')}"
[ "$arch" != "amd64" ] && [ "$arch" != "arm64" ] && {
  echo "$0: unsupported architecture: $arch"
  exit 1
}

DOWNLOAD_DIR=$(cd "$(dirname "$0")"; pwd)/prefetched/$arch
mkdir -p "$DOWNLOAD_DIR"

download() {
  local url="$1"
  local filename="$2"

  echo "downloading $filename ..."
  [ -f "$DOWNLOAD_DIR/$filename" ] || {
    curl -fSL --retry 5 "$url" -o "$DOWNLOAD_DIR/$filename"
  }
}

# go
[ "$arch" = "amd64" ] && download https://dl.google.com/go/go1.17.2.linux-amd64.tar.gz go.tar.gz
[ "$arch" = "arm64" ] && download https://dl.google.com/go/go1.17.2.linux-arm64.tar.gz go.tar.gz

# chromium (x64 only)
[ "$arch" = "amd64" ] && download "https://download-chromium.appspot.com/dl/Linux_x64?type=snapshots" chrome-linux.zip
[ "$arch" = "arm64" ] && touch "$DOWNLOAD_DIR/chrome-linux.zip"  # dummy

# julia
[ "$arch" = "amd64" ] && download https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.3-linux-amd64.tar.gz       julia.tar.gz
[ "$arch" = "arm64" ] && download https://julialang-s3.julialang.org/bin/linux/aarch64/1.6/julia-1.6.3-linux-aarch64.tar.gz julia.tar.gz

# openjdk
[ "$arch" = "amd64" ] && download https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz     openjdk.tar.gz
[ "$arch" = "arm64" ] && download https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-aarch64_bin.tar.gz openjdk.tar.gz

# nodejs
node_version="$(curl -s https://nodejs.org/dist/index.json | jq -r '[.[]|select(.lts)][0].version')"
[ "$arch" = "amd64" ] && download "https://nodejs.org/dist/$node_version/node-$node_version-linux-x64.tar.gz"   nodejs.tar.gz
[ "$arch" = "arm64" ] && download "https://nodejs.org/dist/$node_version/node-$node_version-linux-arm64.tar.gz" nodejs.tar.gz

# 最後が false にならないように
echo "prefetching completed"
