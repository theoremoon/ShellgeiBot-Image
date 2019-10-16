#!/bin/sh

# get_build_log.sh はCircleCIのビルドログのJSONを取得し、必要な値だけ取り出して
# CSV形式で標準出力する。
#
# 依存ツール
# * curl
# * jq

set -eu

BUILD_LOG_URL="https://circleci.com/api/v1.1/project/github/theoremoon/ShellgeiBot-Image/tree/master?shallow=true&offset=0&limit=30&mine=false"

echo '"build_num","vcs_revision","start_time","stop_time"'
curl -s --connect-timeout 5 --retry 5 "$BUILD_LOG_URL" |
  jq -cr '.[] | [(.build_num | tostring), .vcs_revision, .start_time, .stop_time] | @csv'
