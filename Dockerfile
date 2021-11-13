# syntax = docker/dockerfile:1.2
FROM ubuntu:21.10 AS apt-cache
RUN apt-get update

FROM ubuntu:21.10 AS base
ENV DEBIAN_FRONTEND noninteractive
RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/no-install-recommends
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install -y -qq build-essential ca-certificates curl git unzip

## Go
FROM base AS go-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq libmecab-dev
## use prefetched file
COPY prefetched/go.tar.gz .
RUN tar xzf go.tar.gz -C /usr/local && rm go.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /root/go
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/ericchiang/pup@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/greymd/ojichat@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/gyozabu/himechat-cli@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/ikawaha/nise@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/jiro4989/align@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/jiro4989/ponpe@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/jiro4989/taishoku@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/jiro4989/textchat@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/jiro4989/textimg/v3@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/jmhobbs/terminal-parrot@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/mattn/longcat@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build CGO_LDFLAGS="`mecab-config --libs`" CGO_CFLAGS="-I`mecab-config --inc-dir`" go install github.com/ryuichiueda/ke2daira@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/ryuichiueda/kkcw@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/sugyan/ttyrec2gif@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/tomnomnom/gron@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/xztaityozx/kakikokera@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/xztaityozx/owari@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/YuheiNakasaka/sayhuuzoku@latest
RUN --mount=type=cache,target=/root/go/pkg \
    find /usr/local/go/src /root/go/pkg/mod -type f \
    | grep -Ei 'license|readme' \
    | grep -v '.go$' \
    | xargs -I@ echo "mkdir -p /tmp@; cp @ /tmp@" \
    | sed -e 's!/[^/]*;!;!' \
    | bash
RUN mkdir -p /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/db \
    && curl -sfSL --retry 5 https://raw.githubusercontent.com/YuheiNakasaka/sayhuuzoku/master/db/data.db \
    -o /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/db/data.db
RUN mkdir -p /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/ \
    && curl -sfSL --retry 5 https://raw.githubusercontent.com/YuheiNakasaka/sayhuuzoku/master/scraping/shoplist.txt \
    -o /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/shoplist.txt
RUN git clone --depth 1 https://github.com/googlefonts/noto-emoji /usr/local/src/noto-emoji

## Ruby
FROM base AS ruby-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq ruby-dev
# TODO: ruby 3.x に対応してmatsuyaのバージョン固定を外す
RUN --mount=type=cache,target=/root/.gem \
    gem install --quiet --no-document cureutils lolcat marky_markov matsuya:0.3 rubipara snacknomama takarabako zen_to_i
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/hostilefork/whitespacers/master/ruby/whitespace.rb -o /usr/local/bin/whitespace
RUN chmod +x /usr/local/bin/whitespace
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/thisredone/rb/master/rb -o /usr/local/bin/rb && chmod +x /usr/local/bin/rb

## Python
FROM base AS python-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq python3-dev python3-pip python3-setuptools
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --progress-bar=off --no-use-pep517 asciinema faker matplotlib numpy num2words pillow scipy sympy wordcloud xonsh yq

## Node.js
FROM base AS nodejs-builder
ARG NODE_VERSION
RUN curl -sfSO --retry 5 https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz \
    && tar xf node-${NODE_VERSION}-linux-x64.tar.gz -C /usr/local \
    && rm node-${NODE_VERSION}-linux-x64.tar.gz
ENV PATH $PATH:/usr/local/node-${NODE_VERSION}-linux-x64/bin
RUN --mount=type=cache,target=/root/.npm \
    npm install -g --silent faker-cli chemi fx yukichant @amanoese/muscular kana2ipa

## .NET
FROM base AS dotnet-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq apt-transport-https
RUN curl -sfSLO --retry 5 https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists,rw \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update && apt-get install -y -qq dotnet-sdk-3.1
# noc
RUN git clone --depth 1 https://github.com/xztaityozx/noc.git
RUN (cd /noc/noc/noc; dotnet publish --configuration Release -p:PublishSingleFile=true -p:PublishReadyToRun=true -r linux-x64 --self-contained false)
# ocs
RUN git clone --depth 1 https://github.com/xztaityozx/ocs.git
RUN (cd /ocs/ocs; dotnet publish --configuration Release -p:PublishSingleFile=true -p:PublishReadyToRun=true -r linux-x64 --self-contained false)

## Rust
FROM base AS rust-builder
RUN curl -sfSL --retry 5 https://sh.rustup.rs | sh -s -- -y
ENV PATH $PATH:/root/.cargo/bin
RUN cargo install --git https://github.com/lotabout/rargs.git
RUN cargo install --git https://github.com/KoharaKazuya/forest.git
RUN find /root/.rustup /root/.cargo -type f \
    | grep -Ei 'license|readme' \
    | xargs -I@ echo "mkdir -p /tmp@; cp @ /tmp@" \
    | sed -e 's!/[^/]*;!;!' \
    | bash

## Nim
FROM base AS nim-builder
ENV PATH $PATH:/root/.nimble/bin
RUN curl -sfSLO --retry 5 https://nim-lang.org/choosenim/init.sh
RUN bash init.sh -y
RUN choosenim update stable
RUN nimble install edens gyaric maze rect svgo eachdo -Y

## General
FROM base AS general-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq file jq lib32ncursesw5-dev libmecab-dev mecab

WORKDIR /downloads
# Open-usp-Tukubai
RUN git clone --depth 1 https://github.com/usp-engineers-community/Open-usp-Tukubai.git
# edfsay
RUN git clone --depth 1 https://github.com/jiro4989/edfsay.git
# color, rainbow
RUN git clone --depth 1 https://github.com/jiro4989/scripts.git
# no more secrets
RUN git clone --depth 1 https://github.com/bartobri/no-more-secrets.git \
    && (cd no-more-secrets && make nms-ncurses && make sneakers-ncurses)
# shellgei data
RUN git clone --depth 1 https://github.com/ryuichiueda/ShellGeiData.git
# eki
RUN git clone --depth 1 https://github.com/ryuichiueda/eki.git
# imgout
RUN git clone --depth 1 https://github.com/ryuichiueda/ImageGeneratorForShBot.git
# csvquote
RUN git clone --depth 1 https://github.com/dbro/csvquote.git \
    && (cd csvquote && make)
# GlueLang
RUN git clone --depth 1 https://github.com/ryuichiueda/GlueLang.git \
    && (cd GlueLang && make)
RUN git clone --depth 1 https://github.com/ryuichiueda/glueutils.git \
    && (cd glueutils && mkdir -p bin && make)
# mecab-ipadic-NEologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd \
    && (cd mecab-ipadic-neologd && ./bin/install-mecab-ipadic-neologd -u -y -p $PWD/ipadic-utf8)

# egison
RUN curl -sfSLO --retry 5 https://github.com/egison/egison-package-builder/releases/download/4.1.2/egison-4.1.2.x86_64.deb
# egzact
RUN curl -sfSLO --retry 5 https://github.com/greymd/egzact/releases/download/v2.1.1/egzact-2.1.1.deb
# bat
RUN curl -sfSL --retry 5 https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb -o bat.deb
# osquery
RUN curl -sfSL --retry 5 https://github.com/osquery/osquery/releases/download/5.0.1/osquery_5.0.1-1.linux_amd64.deb -o osquery.deb
# super_unko
RUN curl -sfSLO --retry 5 https://git.io/superunko.linux.deb
# echo-meme
RUN curl -sfSLO --retry 5 https://git.io/echo-meme.deb
# J
RUN curl -sfSL --retry 5 http://www.jsoftware.com/download/j902/install/j902_amd64.deb -o j.deb
# teip
RUN curl -sfSL --retry 5 https://git.io/teip-1.2.1.x86_64.deb -o teip.deb

# Julia
COPY prefetched/julia.tar.gz .
# OpenJDK
COPY prefetched/openjdk17.tar.gz .
# Clojure
RUN curl -sfSL --retry 5 https://download.clojure.org/install/linux-install-1.10.3.855.sh -o clojure_install.sh

# trdsql
RUN curl -sfSLO --retry 5 https://github.com/noborus/trdsql/releases/download/v0.9.0/trdsql_v0.9.0_linux_amd64.zip
# onefetch
RUN curl -sfSLO --retry 5 https://github.com/o2sh/onefetch/releases/download/v2.10.2/onefetch-linux.tar.gz
# PowerShell
RUN curl -sfSL --retry 5 https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/powershell-7.1.5-linux-x64.tar.gz -o powershell.tar.gz
# V
RUN curl -sfSLO --retry 5 https://github.com/vlang/v/releases/download/0.2.4/v_linux.zip
## use prefetched file
COPY prefetched/chrome-linux.zip .
# morsed (最新版のreleasesを取得するためjqで最新タグを取得)
RUN curl -s https://api.github.com/repos/jiro4989/morsed/releases \
    | jq -r '.[0].assets[] | select(.name | test("morsed_linux.tar.gz")) | .browser_download_url' \
    | xargs curl -sfSLO --retry 5

WORKDIR /


## Runtime
FROM base AS runtime

# Set environments
ENV LANG ja_JP.UTF-8
ENV TZ JST-9
ENV PATH /usr/games:$PATH

# home-commands (echo-sd)
RUN git clone --depth 1 https://github.com/fumiyas/home-commands /usr/local/home-commands && sed -i 's/殺す/うんこ/' /usr/local/home-commands/tate
ENV PATH $PATH:/usr/local/home-commands

# nameko.svg
RUN curl -sfSLO --retry 5 https://gist.githubusercontent.com/KeenS/6194e6ef1a151c9ea82536d5850b8bc7/raw/85af9ec757308b8ca4effdf24221f642cb34703b/nameko.svg

# zws
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/kanata2003/ZeroWidthSpace/master/zws -o /usr/local/bin/zws \
    && chmod +x /usr/local/bin/zws

# ivsteg
RUN curl -sfSL --retry 5 https://raintrees.net/attachments/download/698/ivsteg -o /usr/local/bin/ivsteg \
    && chmod +x /usr/local/bin/ivsteg

# funnychar
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/kanata2003/funnychar/master/funnychar -o /usr/local/bin/funnychar \
    && chmod +x /usr/local/bin/funnychar

# sushiro
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/redpeacock78/sushiro/master/sushiro -o /usr/local/bin/sushiro \
    && chmod +x /usr/local/bin/sushiro && sushiro -f

# pokemonsay
RUN git clone --depth 1 http://github.com/possatti/pokemonsay \
    && (cd pokemonsay; ./install.sh ) \
    && rm -r pokemonsay
ENV PATH $PATH:/root/bin

# saizeriya
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/3socha/saizeriya/master/saizeriya -o /usr/local/bin/saizeriya \
    && chmod u+x /usr/local/bin/saizeriya

# fujiaire
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/msr-i386/fujiaire/master/fujiaire -o /usr/local/bin/fujiaire \
    && chmod u+x /usr/local/bin/fujiaire

# horizon
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/msr-i386/horizon/master/horizon -o /usr/local/bin/horizon \
    && chmod u+x /usr/local/bin/horizon

# opy
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/ryuichiueda/opy/master/opy -o /usr/local/bin/opy \
    && chmod u+x /usr/local/bin/opy

# base85
RUN curl -sfSL --retry 5 https://github.com/redpeacock78/base85/releases/download/v0.0.11/base85-linux-x86 -o /usr/local/bin/base85 \
    && chmod u+x /usr/local/bin/base85

# apt
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install -y -qq \
     agrep \
     apache2-utils \
     ash yash \
     bats \
     bbe \
     bc \
     bf \
     boxes \
     bsdgames fortunes cowsay fortunes-off fortune-mod cowsay-off \
     busybox \
     ccze \
     clisp \
     cmatrix \
     datamash \
     dateutils \
     dc \
     faketime \
     ffmpeg \
     figlet \
     file \
     firefox \
     fish \
     fonts-droid-fallback fonts-lato fonts-liberation fonts-noto-mono fonts-dejavu-core gsfonts fonts-hanazono \
     fonts-ipafont fonts-vlgothic \
     fonts-noto-cjk fonts-noto-cjk-extra \
     fonts-nanum fonts-symbola fonts-noto-color-emoji \
     gawk \
     gnuplot \
     graphviz \
     haskell-platform \
     icu-devtools \
     idn \
     imagemagick ghostscript \
     ipcalc \
     jq \
     kakasi \
     language-pack-ja \
     libc++-dev \
     libkkc-utils \
     libncurses5 \
     libnss3 libgdk3.0-cil \
     libmecab-dev \
     librsvg2-bin \
     libskk-dev \
     libxml2-utils \
     lua5.4 php8.0 php8.0-cli php8.0-common \
     mecab mecab-ipadic mecab-ipadic-utf8 \
     mono-csharp-shell \
     moreutils \
     morsegen \
     mt-st \
     ncal \
     nim \
     nkf \
     num-utils \
     numconv \
     nyancat \
     pandoc \
     parallel \
     perl \
     postgresql-client-common \
     postgresql-common \
     pwgen \
     python3-pkg-resources \
     qrencode \
     r-base \
     rename \
     rs \
     ruby \
     screen tmux \
     screenfetch \
     sl \
     tcsh \
     telnet \
     timidity abcmidi \
     toilet \
     tree \
     ttyrec \
     unicode-data uniutils \
     vim emacs-nox \
     w3m nginx \
     whiptail \
     xvfb xterm x11-apps xdotool \
     zsh

# kagome
COPY --from=ikawaha/kagome /usr/local/bin/kagome /usr/local/bin/kagome

# Go
COPY --from=go-builder /usr/local/go/LICENSE /usr/local/go/README.md /usr/local/go/
COPY --from=go-builder /usr/local/go/bin /usr/local/go/bin
COPY --from=go-builder /root/go/bin /root/go/bin
COPY --from=go-builder /tmp/usr/local/go /usr/local/go
COPY --from=go-builder /tmp/root/go /root/go
COPY --from=go-builder /usr/local/src/noto-emoji/png/128/ /usr/local/src/noto-emoji
ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin:/root/go/bin
RUN ln -s /root/go/src/github.com/YuheiNakasaka/sayhuuzoku/db /
ENV TEXTIMG_EMOJI_DIR /usr/local/src/noto-emoji
ENV TEXTIMG_OUTPUT_DIR /images

# Ruby
COPY --from=ruby-builder /usr/local/bin /usr/local/bin
COPY --from=ruby-builder /var/lib/gems /var/lib/gems

# Python
COPY --from=python-builder /usr/local/bin /usr/local/bin
COPY --from=python-builder /usr/local/lib/python3.9 /usr/local/lib/python3.9
RUN ln -s /usr/bin/python3 /usr/bin/python

# Node.js
ARG NODE_VERSION
COPY --from=nodejs-builder /usr/local/node-${NODE_VERSION}-linux-x64 /usr/local/node-${NODE_VERSION}-linux-x64
ENV PATH $PATH:/usr/local/node-${NODE_VERSION}-linux-x64/bin

# .NET
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq apt-transport-https
RUN curl -sfSLO --retry 5 https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists,rw \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update && apt-get install -y -qq dotnet-runtime-3.1
COPY --from=dotnet-builder /noc/LICENSE /noc/README.md \
    /noc/noc/noc/bin/Release/netcoreapp3.1/linux-x64/publish/noc \
    /usr/local/noc/
RUN ln -s /usr/local/noc/noc /usr/local/bin/noc
COPY --from=dotnet-builder /ocs/LICENSE /ocs/README.md \
    /ocs/ocs/bin/Release/netcoreapp3.1/linux-x64/publish/ocs \
    /usr/local/ocs/
RUN ln -s /usr/local/ocs/ocs /usr/local/bin/ocs

# Rust
COPY --from=rust-builder /root/.cargo/bin /root/.cargo/bin
COPY --from=rust-builder /tmp/root /root
ENV PATH $PATH:/root/.cargo/bin

# Nim
COPY --from=nim-builder /root/.nimble /root/.nimble
ENV PATH $PATH:/root/.nimble/bin

# shellgei data
COPY --from=general-builder /downloads/ShellGeiData /ShellGeiData
# eki
COPY --from=general-builder /downloads/eki/eki /eki
COPY --from=general-builder /downloads/eki/bin /usr/local/bin
# imgout
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    (cd /downloads/ImageGeneratorForShBot && git archive --format=tar --prefix=imgout/ HEAD) | tar xf - -C /usr/local
ENV PATH $PATH:/usr/local/imgout:/usr/local/kkcw

# Open-usp-Tukubai, edfsay, color, rainbow, no more secrets, csvquote, GlueLang, NEologd
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    (cd /downloads/Open-usp-Tukubai && make install) \
    && (cd /downloads/edfsay && ./install.sh) \
    && (cd /downloads/scripts && ./install.sh) \
    && (cd /downloads/no-more-secrets && make install) \
    && (cd /downloads/csvquote && make install) \
    && (cd /downloads/GlueLang && install -m 755 glue /usr/local/bin) \
    && (cd /downloads/glueutils/bin && install -m 755 * /usr/local/bin/) \
    && (cp -rf /downloads/mecab-ipadic-neologd/ipadic-utf8 /var/lib/mecab/dic)

# egison, egzact, bat, osquery, super_unko, echo-meme, J
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    dpkg -i \
      /downloads/egison-4.1.2.x86_64.deb \
      /downloads/egzact-2.1.1.deb \
      /downloads/bat.deb \
      /downloads/osquery.deb \
      /downloads/superunko.linux.deb \
      /downloads/echo-meme.deb \
      /downloads/j.deb \
      /downloads/teip.deb

# Julia, OpenJDK, trdsql (apply sql to csv), onefetch, Clojure, chromium
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    tar xf /downloads/julia.tar.gz -C /usr/local \
    && tar xf /downloads/openjdk17.tar.gz -C /usr/local \
    && unzip /downloads/trdsql_v0.9.0_linux_amd64.zip -d /usr/local \
    && ln -s /usr/local/trdsql_v0.9.0_linux_amd64/trdsql /usr/local/bin \
    && tar xf /downloads/onefetch-linux.tar.gz -C /usr/local/bin \
    && /bin/bash /downloads/clojure_install.sh \
    && unzip /downloads/chrome-linux.zip -d /usr/local
ENV PATH $PATH:/usr/local/julia-1.6.3/bin:/usr/local/jdk-17/bin:/usr/local/chrome-linux
ENV JAVA_HOME /usr/local/jdk-17
# Clojure が実行時に必要とするパッケージを取得
RUN clojure -e '(println "test")'
# Clojure ワンライナー
RUN curl -s --retry 5 https://raw.githubusercontent.com/borkdude/babashka/master/install | bash

# V
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    unzip /downloads/v_linux.zip -d /usr/local \
    && ln -s /usr/local/v/v /usr/local/bin/v

# PowerShell
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    mkdir -p /usr/local/powershell \
    && tar xf /downloads/powershell.tar.gz -C /usr/local/powershell \
    && ln -s /usr/local/powershell/pwsh /usr/local/bin/

# morsed
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    tar xf /downloads/morsed_linux.tar.gz -C /usr/local/ \
    && ln -s /usr/local/morsed_linux/morsed /usr/local/bin/

# man
RUN mv /usr/bin/man.REAL /usr/bin/man

# reset apt config
RUN rm /etc/apt/apt.conf.d/keep-cache /etc/apt/apt.conf.d/no-install-recommends
COPY --from=ubuntu:21.10 /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/

# ShellgeiBot-Image information
RUN mkdir -p /etc/shellgeibot-image
COPY revision.log /etc/shellgeibot-image
COPY ci_build.log /etc/shellgeibot-image
COPY LICENSE /etc/shellgeibot-image
COPY README.md /etc/shellgeibot-image
COPY bin/shellgeibot-image /usr/local/bin
