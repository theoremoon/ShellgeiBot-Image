# syntax = docker/dockerfile:1.0-experimental
FROM ubuntu:20.04 AS apt-cache

RUN apt-get update

FROM ubuntu:20.04 AS base
ENV DEBIAN_FRONTEND noninteractive
RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/no-install-recommends
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install -y -qq curl git build-essential unzip ca-certificates

## Go
FROM base AS go-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq libmecab-dev
RUN curl -sfSL --retry 3 https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz -o go.tar.gz \
    && tar xzf go.tar.gz -C /usr/local \
    && rm go.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /root/go
RUN --mount=type=cache,target=/root/go/src \
    --mount=type=cache,target=/root/.cache/go-build \
    go get -u -ldflags '-w -s' \
      github.com/golang/dep/cmd/dep \
      github.com/tomnomnom/gron \
      github.com/ericchiang/pup \
      github.com/sugyan/ttyrec2gif \
      github.com/xztaityozx/owari \
      github.com/xztaityozx/kakikokera \
      github.com/jiro4989/align \
      github.com/jiro4989/taishoku \
      github.com/jiro4989/textimg \
      github.com/jiro4989/textchat \
      github.com/jiro4989/ponpe \
      github.com/greymd/ojichat \
      github.com/gyozabu/himechat-cli \
      github.com/ikawaha/nise \
      github.com/jmhobbs/terminal-parrot \
      github.com/ryuichiueda/kkcw \
      github.com/mattn/longcat \
    && CGO_LDFLAGS="`mecab-config --libs`" CGO_CFLAGS="-I`mecab-config --inc-dir`" \
      go get -u -ldflags '-w -s' github.com/ryuichiueda/ke2daira \
    && go get -u -d github.com/YuheiNakasaka/sayhuuzoku \
    && (cd ${GOPATH}/src/github.com/YuheiNakasaka/sayhuuzoku; ${GOPATH}/bin/dep ensure && go build -ldflags '-w -s' -o ${GOPATH}/bin/sayhuuzoku) \
    && find /usr/local/go/src /root/go/src -type f \
      | grep -Ei 'license|readme' \
      | grep -v '.go$' \
      | xargs -I@ echo "mkdir -p /tmp@; cp @ /tmp@" \
      | sed -e 's!/[^/]*;!;!' \
      | bash \
    && mkdir -p /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/db \
              && cp /root/go/src/github.com/YuheiNakasaka/sayhuuzoku/db/data.db \
                /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/db/data.db \
    && mkdir -p /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping \
              && cp /root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/shoplist.txt \
                /tmp/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/shoplist.txt
RUN rm ${GOPATH}/bin/dep
RUN git clone --depth 1 https://github.com/googlefonts/noto-emoji /usr/local/src/noto-emoji

## Ruby
FROM base AS ruby-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq ruby-dev
RUN --mount=type=cache,target=/root/.gem \
    gem install --quiet --no-document cureutils lolcat matsuya takarabako snacknomama rubipara marky_markov zen_to_i
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/hostilefork/whitespacers/master/ruby/whitespace.rb -o /usr/local/bin/whitespace
RUN chmod +x /usr/local/bin/whitespace
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/thisredone/rb/master/rb -o /usr/local/bin/rb && chmod +x /usr/local/bin/rb

## Python
FROM base AS python-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq python3-dev python3-pip python3-setuptools
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --progress-bar=off --no-use-pep517 yq faker sympy numpy scipy matplotlib xonsh pillow asciinema

## Node.js
FROM base AS nodejs-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq nodejs npm
RUN --mount=type=cache,target=/root/.npm \
    npm install -g --silent faker-cli chemi yukichant @amanoese/muscular fx kana2ipa

## .NET
FROM base AS dotnet-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq libicu66
# .NET Core SDK 2.2.402 binary
WORKDIR /downloads
RUN curl -sfSLO --retry 3 https://download.visualstudio.microsoft.com/download/pr/46411df1-f625-45c8-b5e7-08ab736d3daa/0fbc446088b471b0a483f42eb3cbf7a2/dotnet-sdk-2.2.402-linux-x64.tar.gz \
    && mkdir /usr/local/dotnet \
    && tar xf dotnet-sdk-2.2.402-linux-x64.tar.gz -C /usr/local/dotnet
ENV PATH $PATH:/usr/local/dotnet
WORKDIR /
RUN git clone --depth 1 https://github.com/xztaityozx/noc.git
RUN (cd /noc/noc/noc; dotnet build --configuration Release)

## Rust
FROM base AS rust-builder
RUN curl -sfSL --retry 3 https://sh.rustup.rs | sh -s -- -y
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
RUN curl https://nim-lang.org/choosenim/init.sh -sSf > init.sh \
    && sh init.sh -y \
    && choosenim update stable
RUN nimble install rect edens maze gyaric svgo -Y

## General
FROM base AS general-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq lib32ncursesw5-dev

WORKDIR /downloads
# Open-usp-Tukubai
RUN git clone --depth 1 https://github.com/usp-engineers-community/Open-usp-Tukubai.git
# edfsay
RUN git clone --depth 1 https://github.com/jiro4989/edfsay
# no more secrets
RUN git clone --depth 1 https://github.com/bartobri/no-more-secrets.git \
    && (cd no-more-secrets && make nms-ncurses && make sneakers-ncurses)
# shellgei data
RUN git clone --depth 1 https://github.com/ryuichiueda/ShellGeiData.git
# imgout
RUN git clone --depth 1 https://github.com/ryuichiueda/ImageGeneratorForShBot.git
# csvquote
RUN git clone --depth 1 https://github.com/dbro/csvquote.git \
    && (cd csvquote && make)

# unicode data
RUN curl -sfSLO --retry 3 --insecure https://www.unicode.org/Public/UCD/latest/ucd/NormalizationTest.txt
RUN curl -sfSLO --retry 3 --insecure https://www.unicode.org/Public/UCD/latest/ucd/NamesList.txt

# egison
RUN curl -sfSLO --retry 3 https://git.io/egison.x86_64.deb
# egzact
RUN curl -sfSLO --retry 3 https://git.io/egzact.deb
# bat
RUN curl -sfSL --retry 3 https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_amd64.deb -o bat.deb
# osquery
RUN curl -sfSL --retry 3 https://github.com/osquery/osquery/releases/download/4.1.1/osquery_4.1.1_1.linux.amd64.deb -o osquery.deb
# super_unko
RUN curl -sfSLO --retry 3 https://git.io/superunko.deb
# echo-meme
RUN curl -sfSLO --retry 3 https://git.io/echo-meme.deb
# J
RUN curl -sfSL --retry 3 http://www.jsoftware.com/download/j901/install/j901_amd64.deb -o j.deb

# Julia
RUN curl -sfSL --retry 3 https://julialang-s3.julialang.org/bin/linux/x64/1.4/julia-1.4.0-linux-x86_64.tar.gz -o julia.tar.gz
# OpenJDK
RUN curl -sfSL --retry 3 https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz -o openjdk11.tar.gz
# Clojure
RUN curl -sfSL --retry 3 https://download.clojure.org/install/linux-install-1.10.1.469.sh -o clojure_install.sh

# trdsql
RUN curl -sfSLO --retry 3 https://github.com/noborus/trdsql/releases/download/v0.7.5/trdsql_v0.7.5_linux_amd64.zip
# onefetch
RUN curl -sfSLO --retry 3 https://github.com/o2sh/onefetch/releases/download/v2.2.0/onefetch_linux_x86-64.zip
# PowerShell
RUN curl -sfSL --retry 3 https://github.com/PowerShell/PowerShell/releases/download/v7.0.0/powershell-7.0.0-linux-x64.tar.gz -o powershell.tar.gz
# V
RUN curl -sfSLO --retry 3 https://github.com/vlang/v/releases/download/0.1.24/v_linux.zip
# Chromium ref: https://github.com/scheib/chromium-latest-linux/blob/master/update.sh
RUN REVISION=$(curl -sS --retry 3 "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media") \
    && curl -sfSL --retry 3 -o chrome-linux.zip "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${REVISION}%2Fchrome-linux.zip?alt=media"
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
RUN curl -sfSLO --retry 3 https://gist.githubusercontent.com/KeenS/6194e6ef1a151c9ea82536d5850b8bc7/raw/85af9ec757308b8ca4effdf24221f642cb34703b/nameko.svg

# zws
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/kanata2003/ZeroWidthSpace/master/zws -o /usr/local/bin/zws \
    && chmod +x /usr/local/bin/zws

# ivsteg
RUN curl -sfSL --retry 3 https://raintrees.net/attachments/download/698/ivsteg -o /usr/local/bin/ivsteg \
    && chmod +x /usr/local/bin/ivsteg

# funnychar
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/kanata2003/funnychar/master/funnychar -o /usr/local/bin/funnychar \
    && chmod +x /usr/local/bin/funnychar

# sushiro
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/redpeacock78/sushiro/master/sushiro -o /usr/local/bin/sushiro \
    && chmod +x /usr/local/bin/sushiro && sushiro -f

# pokemonsay
RUN git clone --depth 1 http://github.com/possatti/pokemonsay \
    && (cd pokemonsay; ./install.sh ) \
    && rm -r pokemonsay
ENV PATH $PATH:/root/bin

# saizeriya
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/horo17/saizeriya/master/saizeriya -o /usr/local/bin/saizeriya \
    && chmod u+x /usr/local/bin/saizeriya

# fujiaire
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/msr-i386/fujiaire/master/fujiaire -o /usr/local/bin/fujiaire \
    && chmod u+x /usr/local/bin/fujiaire

# horizon
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/msr-i386/horizon/master/horizon -o /usr/local/bin/horizon \
    && chmod u+x /usr/local/bin/horizon

# opy
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/ryuichiueda/opy/master/opy -o /usr/local/bin/opy \
    && chmod u+x /usr/local/bin/opy

# color, rainbow
RUN git clone --depth 1 https://github.com/jiro4989/scripts /tmp/scripts \
    && (cd /tmp/scripts && ./install.sh)

# apt
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install -y -qq \
      ruby\
      ccze\
      screen tmux\
      ttyrec\
      timidity abcmidi\
      r-base\
      boxes\
      ash yash\
      jq\
      vim emacs\
      nkf\
      rs\
      language-pack-ja\
      pwgen\
      bc\
      perl\
      toilet\
      figlet\
      haskell-platform\
      mecab mecab-ipadic mecab-ipadic-utf8\
      bsdgames fortunes cowsay fortunes-off fortune-mod cowsay-off\
      datamash\
      gawk\
      libxml2-utils\
      zsh\
      num-utils\
      apache2-utils\
      fish\
      nyancat\
      imagemagick ghostscript\
      moreutils\
      whiptail\
      pandoc\
      postgresql-common\
      postgresql-client-common\
      icu-devtools\
      tcsh\
      libskk-dev\
      libkkc-utils\
      morsegen\
      dc\
      telnet\
      busybox\
      parallel\
      rename\
      mt-st\
      ffmpeg\
      kakasi\
      dateutils\
      fonts-ipafont fonts-vlgothic\
      gnuplot\
      qrencode\
      fonts-nanum fonts-symbola fonts-noto-color-emoji\
      sl\
      w3m nginx\
      screenfetch\
      firefox\
      lua5.3 php7.4 php7.4-cli php7.4-common\
      nodejs\
      graphviz\
      nim\
      bats\
      libncurses5\
      faketime\
      tree\
      numconv\
      file\
      cmatrix\
      python3-pkg-resources\
      fonts-droid-fallback fonts-lato fonts-liberation fonts-noto-mono fonts-dejavu-core gsfonts fonts-hanazono\
      bf\
      libc++-dev\
      mono-csharp-shell\
      ipcalc\
      librsvg2-bin\
      agrep \
      xvfb xterm x11-apps xdotool \
      libnss3 libgdk3.0-cil\
      clisp

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

# Ruby
COPY --from=ruby-builder /usr/local/bin /usr/local/bin
COPY --from=ruby-builder /var/lib/gems /var/lib/gems

# Python
COPY --from=python-builder /usr/local/bin /usr/local/bin
COPY --from=python-builder /usr/local/lib/python3.8 /usr/local/lib/python3.8
RUN ln -s /usr/bin/python3 /usr/bin/python

# Node.js
COPY --from=nodejs-builder /usr/local/bin /usr/local/bin
COPY --from=nodejs-builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# .NET
RUN --mount=type=bind,target=/downloads,from=dotnet-builder,source=/downloads \
    mkdir /usr/local/dotnet \
    && tar xf /downloads/dotnet-sdk-2.2.402-linux-x64.tar.gz -C /usr/local/dotnet
ENV PATH $PATH:/usr/local/dotnet
COPY --from=dotnet-builder /noc/LICENSE /noc/README.md \
    /noc/noc/noc/bin/Release/netcoreapp2.1/noc.dll \
    /noc/noc/noc/bin/Release/netcoreapp2.1/noc.runtimeconfig.json \
    /usr/local/noc/
RUN echo 'dotnet /usr/local/noc/noc.dll "$@"' > /usr/local/bin/noc \
    && chmod +x /usr/local/bin/noc

# Rust
COPY --from=rust-builder /root/.cargo/bin /root/.cargo/bin
COPY --from=rust-builder /tmp/root /root
ENV PATH $PATH:/root/.cargo/bin

# Nim
COPY --from=nim-builder /root/.nimble /root/.nimble
ENV PATH $PATH:/root/.nimble/bin

# shellgei data
COPY --from=general-builder /downloads/ShellGeiData /ShellGeiData
# imgout, unicode data
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    (cd /downloads/ImageGeneratorForShBot && git archive --format=tar --prefix=imgout/ HEAD) | tar xf - -C /usr/local \
    && cp /downloads/NormalizationTest.txt /downloads/NamesList.txt /
ENV PATH $PATH:/usr/local/imgout:/usr/local/kkcw

# Open-usp-Tukubai, edfsay, no more secrets, csvquote
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    (cd /downloads/Open-usp-Tukubai && make install) \
    && (cd /downloads/edfsay && ./install.sh) \
    && (cd /downloads/no-more-secrets && make install) \
    && (cd /downloads/csvquote && make install)

# egison, egzact, bat, osquery, super_unko, echo-meme, J
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    dpkg -i \
      /downloads/egison.x86_64.deb \
      /downloads/egzact.deb \
      /downloads/bat.deb \
      /downloads/osquery.deb \
      /downloads/superunko.deb \
      /downloads/echo-meme.deb \
      /downloads/j.deb

# Julia, OpenJDK, trdsql (apply sql to csv), onefetch, Clojure, chromium
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    tar xf /downloads/julia.tar.gz -C /usr/local \
    && tar xf /downloads/openjdk11.tar.gz -C /usr/local \
    && unzip /downloads/trdsql_v0.7.5_linux_amd64.zip -d /usr/local \
    && ln -s /usr/local/trdsql_v0.7.5_linux_amd64/trdsql /usr/local/bin \
    && unzip /downloads/onefetch_linux_x86-64.zip -d /usr/local/bin onefetch \
    && /bin/bash /downloads/clojure_install.sh \
    && unzip /downloads/chrome-linux.zip -d /usr/local
ENV PATH $PATH:/usr/local/julia-1.4.0/bin:/usr/local/jdk-11.0.2/bin:/usr/local/chrome-linux
ENV JAVA_HOME /usr/local/jdk-11.0.2
# Clojure が実行時に必要とするパッケージを取得
RUN clojure -e '(println "test")'

# V
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    unzip /downloads/v_linux.zip -d /usr/local/vlang \
    && ln -s /usr/local/vlang/v /usr/local/bin/v

# PowerShell
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    mkdir -p /usr/local/powershell \
    && tar xf /downloads/powershell.tar.gz -C /usr/local/powershell \
    && ln -s /usr/local/powershell/pwsh /usr/local/bin/

# man
RUN mv /usr/bin/man.REAL /usr/bin/man

# reset apt config
RUN rm /etc/apt/apt.conf.d/keep-cache /etc/apt/apt.conf.d/no-install-recommends
COPY --from=ubuntu:20.04 /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/

# ShellgeiBot-Image information
RUN mkdir -p /etc/shellgeibot-image
COPY revision.log /etc/shellgeibot-image
COPY ci_build.log /etc/shellgeibot-image
COPY LICENSE /etc/shellgeibot-image
COPY README.md /etc/shellgeibot-image
COPY bin/shellgeibot-image /usr/local/bin
