# syntax = docker/dockerfile:latest
FROM ubuntu:24.04 AS apt-cache
RUN apt-get update

FROM ubuntu:24.04 AS base
ENV DEBIAN_FRONTEND noninteractive
RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/no-install-recommends
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install -y -qq build-essential ca-certificates curl git unzip

## Go
FROM base AS go-builder
ARG TARGETARCH
COPY prefetched/$TARGETARCH/go.tar.gz .
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
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/ryuichiueda/kkcw@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/sugyan/ttyrec2gif@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/tomnomnom/gron@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/xztaityozx/kakikokera@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/xztaityozx/owari@latest
RUN --mount=type=cache,target=/root/go/pkg --mount=type=cache,target=/root/.cache/go-build go install github.com/xztaityozx/sel@latest
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
RUN --mount=type=cache,target=/root/.gem \
    gem install --quiet --no-document cureutils lolcat marky_markov matsuya rubipara snacknomama takarabako zen_to_i
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/hostilefork/whitespacers/master/ruby/whitespace.rb -o /usr/local/bin/whitespace
RUN chmod +x /usr/local/bin/whitespace
RUN curl -sfSL --retry 5 https://raw.githubusercontent.com/thisredone/rb/master/rb -o /usr/local/bin/rb && chmod +x /usr/local/bin/rb

## Python
FROM base AS python-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq python3-pip python3-venv
WORKDIR /downloads
RUN git clone --depth 1 https://github.com/yabeenico/concat
RUN (cd /downloads/concat && git archive --format=tar --prefix=concat/ HEAD) | tar xf - -C /usr/local
RUN python3 -m venv /usr/local/concat
RUN /usr/local/concat/bin/pip3 install -r /usr/local/concat/requirements.txt
RUN echo '/usr/local/concat/bin/python3 /usr/local/concat/concat.py "$@"' > /usr/local/bin/concat && chmod +x /usr/local/bin/concat

## Node.js
FROM base AS nodejs-builder
ARG TARGETARCH
COPY prefetched/$TARGETARCH/nodejs.tar.gz .
RUN tar xf nodejs.tar.gz \
    && mv node-* /usr/local/nodejs
ENV PATH $PATH:/usr/local/nodejs/bin
RUN --mount=type=cache,target=/root/.npm \
    npm install -g --silent faker-cli chemi fx yukichant @amanoese/muscular kana2ipa bats

## .NET
FROM base AS dotnet-builder
ARG TARGETARCH
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq dotnet-sdk-8.0
# noc
RUN git clone --depth 1 https://github.com/xztaityozx/noc.git
RUN (cd /noc/noc/noc; dotnet publish --configuration Release -p:PublishSingleFile=true -p:PublishReadyToRun=true --runtime linux-$(echo $TARGETARCH | sed 's/amd64/x64/') --self-contained false)
# ocs
RUN git clone --depth 1 https://github.com/xztaityozx/ocs.git
RUN (cd /ocs/ocs; dotnet publish --configuration Release --runtime linux-$(echo $TARGETARCH | sed 's/amd64/x64/') --self-contained false ocs.csproj)

## Rust
FROM base AS rust-builder
ARG TARGETARCH
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq libmecab-dev mecab cmake
RUN curl -sfSL --retry 5 https://sh.rustup.rs | sh -s -- -y
ENV PATH $PATH:/root/.cargo/bin
RUN cargo install --git https://github.com/lotabout/rargs.git
RUN cargo install --git https://github.com/KoharaKazuya/forest.git
RUN cargo install --git https://github.com/o2sh/onefetch.git --tag 2.18.1
RUN cargo install --git https://github.com/greymd/teip.git
RUN cargo install --git https://github.com/xztaityozx/surge.git
RUN if [ "${TARGETARCH}" = "amd64" ]; then cargo install --git https://github.com/ryuichiueda/ke2daira.git; fi
RUN find /root/.rustup /root/.cargo -type f \
    | grep -Ei 'license|readme' \
    | xargs -I@ echo "mkdir -p /tmp@; cp @ /tmp@" \
    | sed -e 's!/[^/]*;!;!' \
    | bash

## Nim (x86_64 only)
FROM base AS nim-builder
ARG TARGETARCH
RUN mkdir nim \
    && if [ "${TARGETARCH}" = "amd64" ]; then \
      curl -sfSL --retry 5 https://nim-lang.org/download/nim-2.0.4-linux_x64.tar.xz -o nim.tar.xz \
      && tar xf nim.tar.xz --strip-components 1 -C nim \
      && (cd nim/; ./install.sh /usr/local/bin) \
      && cp ./nim/bin/nimble /usr/local/bin/ \
      && cp -r ./nim/lib /usr/local/lib/nim/; \
    fi
RUN if [ "${TARGETARCH}" = "amd64" ]; then nimble install edens gyaric maze rect svgo eachdo -Y; fi

## General
FROM base AS general-builder
ARG TARGETARCH
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq file jq libncursesw5-dev libmecab-dev mecab
WORKDIR /downloads
# Open-usp-Tukubai; uconv は icu-devtools パッケージで入るため、Open-usp-Tukubai の uconv はインストールしない
RUN git clone --depth 1 https://github.com/usp-engineers-community/Open-usp-Tukubai.git \
    && sed -E 's/uconv[\.txt|\.html]?//' -i ./Open-usp-Tukubai/Makefile
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
# egzact
RUN git clone --depth 1 https://github.com/greymd/egzact.git
# super_unko
RUN git clone --depth 1 https://github.com/unkontributors/super_unko.git
# echo-meme
RUN git clone --depth 1 https://github.com/greymd/echo-meme.git
# mecab-ipadic-NEologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd
COPY prefetched/mecab-ipadic/mecab-ipadic-2.7.0-20070801.tar.gz mecab-ipadic-neologd/build/
RUN mkdir mecab-ipadic-neologd-utf8
RUN mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -u -y -p /downloads/mecab-ipadic-neologd-utf8
# bat
RUN curl -sfSL --retry 5 https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_${TARGETARCH}.deb -o bat.deb
# osquery
RUN curl -sfSL --retry 5 https://github.com/osquery/osquery/releases/download/5.12.2/osquery_5.12.2-1.linux_${TARGETARCH}.deb -o osquery.deb
# J
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
      curl -sfSL --retry 5 https://www.jsoftware.com/download/j9.5/install/j9.5_linux64.tar.gz -o j.tar.gz; \
    fi

# Egison
COPY egison/egison-linux-${TARGETARCH}.tar.gz .
RUN if [ "${TARGETARCH}" = "amd64" ]; then curl -sfSL https://github.com/egison/egison-package-builder/releases/download/4.1.3/egison-4.1.3.x86_64.deb -o egison.deb; fi
# Julia
COPY prefetched/$TARGETARCH/julia.tar.gz .
# Clojure
RUN curl -sfSL --retry 5 https://download.clojure.org/install/linux-install-1.11.3.1463.sh -o clojure_install.sh
# trdsql
RUN curl -sfSL --retry 5 https://github.com/noborus/trdsql/releases/download/v1.0.0/trdsql_v1.0.0_linux_${TARGETARCH}.zip -o trdsql.zip
# PowerShell
ENV POWERSHELL_VERSION 7.4.2
RUN case ${TARGETARCH} in \
      amd64) curl -sfSL --retry 5 https://github.com/PowerShell/PowerShell/releases/download/v$POWERSHELL_VERSION/powershell-$POWERSHELL_VERSION-linux-x64.tar.gz   -o powershell.tar.gz ;; \
      arm64) curl -sfSL --retry 5 https://github.com/PowerShell/PowerShell/releases/download/v$POWERSHELL_VERSION/powershell-$POWERSHELL_VERSION-linux-arm64.tar.gz -o powershell.tar.gz ;; \
    esac
# morsed (最新版のreleasesを取得するためjqで最新タグを取得)
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
      curl -s https://api.github.com/repos/jiro4989/morsed/releases \
      | jq -r '.[0].assets[] | select(.name | test("morsed_linux.tar.gz")) | .browser_download_url' \
      | xargs curl -sfSLO --retry 5; \
    fi
WORKDIR /


## Runtime
FROM base AS runtime
ARG TARGETARCH

# Set environments
ENV LANG ja_JP.UTF-8
ENV TZ JST-9
ENV PATH /usr/games:$PATH
# for idn command
ENV CHARSET UTF-8

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
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
      curl -sfSL --retry 5 https://github.com/redpeacock78/base85/releases/download/v0.0.16/base85-linux-x86 -o /usr/local/bin/base85 \
      && chmod u+x /usr/local/bin/base85 ; \
    fi

# torikizoku
RUN curl -sfSL --retry 5 https://codeberg.org/s10a/torikizoku/raw/branch/main/torikizoku -o /usr/local/bin/torikizoku \
    && chmod +x /usr/local/bin/torikizoku \
    && torikizoku -c

# apt
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install -y -q \
     apache2-utils \
     ash yash \
     bbe \
     bc \
     boxes \
     bsdgames fortunes cowsay fortune-mod cowsay-off \
     busybox \
     ccze \
     clisp \
     cmatrix \
     datamash \
     dateutils \
     dc \
     dotnet8 \
     faketime \
     ffmpeg \
     figlet \
     file \
     fish \
     fonts-droid-fallback fonts-lato fonts-liberation fonts-noto-mono fonts-dejavu-core gsfonts fonts-hanazono \
     fonts-ipafont fonts-vlgothic \
     fonts-noto-cjk fonts-noto-cjk-extra \
     fonts-nanum fonts-symbola fonts-noto-color-emoji \
     hsbrainfuck \
     gawk \
     gdb \
     ghc \
     glimpse \
     gnuplot \
     graphviz \
     icu-devtools \
     idn \
     imagemagick ghostscript \
     ipcalc \
     jc \
     jq \
     kakasi \
     language-pack-ja \
     libc++-dev \
     libkkc-utils \
     libncurses6 \
     libnss3 libgdk3.0-cil \
     libmecab-dev \
     librsvg2-bin \
     libskk-dev \
     libxml2-utils \
     lua5.4 php8.3 php8.3-cli php8.3-common \
     mecab mecab-ipadic mecab-ipadic-utf8 \
     mono-csharp-shell \
     moreutils \
     morsegen \
     mt-st \
     ncal \
     nkf \
     num-utils \
     numconv \
     nyancat \
     openjdk-21-jdk \
     pandoc \
     parallel \
     perl \
     postgresql-client-common \
     postgresql-common \
     pwgen \
     asciinema faker python-is-python3 python3-matplotlib python3-numpy python3-num2words python3-pil python3-scipy python3-sympy python3-wordcloud xonsh yq \
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
     vim \
     w3m nginx \
     whiptail \
     xvfb xterm x11-apps xdotool \
     xxd \
     zsh

# kagome
COPY --from=ikawaha/kagome /kagome /usr/local/bin/kagome

# Go
COPY --from=go-builder /usr/local/go/LICENSE /usr/local/go/README.md /usr/local/go/
COPY --from=go-builder /usr/local/go/bin /usr/local/go/bin
COPY --from=go-builder /root/go/bin /root/go/bin
COPY --from=go-builder /tmp/usr/local/go /usr/local/go
COPY --from=go-builder /tmp/root/go /root/go
COPY --from=go-builder /usr/local/src/noto-emoji/png/128/ /usr/local/src/noto-emoji
# https://github.com/golang/go/issues/61921
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin:/root/go/bin
RUN ln -s /root/go/src/github.com/YuheiNakasaka/sayhuuzoku/db /
ENV TEXTIMG_EMOJI_DIR /usr/local/src/noto-emoji
ENV TEXTIMG_OUTPUT_DIR /images

# Ruby
COPY --from=ruby-builder /usr/local/bin /usr/local/bin
COPY --from=ruby-builder /var/lib/gems /var/lib/gems

# Python
COPY --from=python-builder /usr/local/concat /usr/local/concat
COPY --from=python-builder /usr/local/bin/concat /usr/local/bin/concat

# Node.js
COPY --from=nodejs-builder /usr/local/nodejs /usr/local/nodejs
ENV PATH $PATH:/usr/local/nodejs/bin

# .NET
COPY --from=dotnet-builder /noc/LICENSE /noc/README.md /noc/noc/noc/bin/Release/net8.0/linux-*/publish/noc /usr/local/noc/
RUN ln -s /usr/local/noc/noc /usr/local/bin/noc
COPY --from=dotnet-builder /ocs/LICENSE /ocs/README.md /ocs/ocs/bin/Release/net8.0/linux-*/publish/ /usr/local/ocs/
RUN ln -s /usr/local/ocs/ocs /usr/local/bin/ocs

# Rust
COPY --from=rust-builder /root/.cargo/bin /root/.cargo/bin
COPY --from=rust-builder /tmp/root /root
ENV PATH $PATH:/root/.cargo/bin

# Nim (x86_64 only)
RUN --mount=type=bind,target=/mnt,from=nim-builder,source=/nim \
    if [ "${TARGETARCH}" = "amd64" ]; then (cd /mnt && ./install.sh /usr/local/bin); fi
RUN --mount=type=bind,target=/mnt,from=nim-builder,source=/root \
    if [ "${TARGETARCH}" = "amd64" ]; then cp -r /mnt/.nimble /root/.nimble; fi
ENV PATH $PATH:/root/.nimble/bin

# shellgei data
COPY --from=general-builder /downloads/ShellGeiData /ShellGeiData

# eki
COPY --from=general-builder /downloads/eki/eki /eki
COPY --from=general-builder /downloads/eki/bin /usr/local/bin

# Egison
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    case ${TARGETARCH} in \
      amd64) dpkg -i /downloads/egison.deb ;; \
      arm64) mkdir /usr/lib/egison; tar xf /downloads/egison-*.tar.gz -C /usr/lib/egison --strip-components 1 ;; \
    esac
ENV PATH $PATH:/usr/lib/egison/bin

# imgout
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    (cd /downloads/ImageGeneratorForShBot && git archive --format=tar --prefix=imgout/ HEAD) | tar xf - -C /usr/local
ENV PATH $PATH:/usr/local/imgout:/usr/local/kkcw

# Open-usp-Tukubai, edfsay, color, rainbow, no more secrets, csvquote, GlueLang, NEologd, egzact, super_unko, echo-meme
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    (cd /downloads/Open-usp-Tukubai && make install) \
    && (cd /downloads/edfsay && ./install.sh) \
    && (cd /downloads/scripts && ./install.sh) \
    && (cd /downloads/no-more-secrets && make install) \
    && (cd /downloads/csvquote && make install) \
    && (cd /downloads/GlueLang && install -m 755 glue /usr/local/bin) \
    && (cd /downloads/glueutils/bin && install -m 755 * /usr/local/bin/) \
    && cp -r /downloads/mecab-ipadic-neologd-utf8/* /var/lib/mecab/dic/ipadic-utf8/ \
    && /downloads/egzact/install.sh \
    && /downloads/super_unko/install.sh \
    && /downloads/echo-meme/install.sh

# J
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    if [ "${TARGETARCH}" = "amd64" ]; then \
      mkdir /usr/local/jsoftware \
      && tar xf /downloads/j.tar.gz -C /usr/local/jsoftware --strip-components 1; \
    fi
ENV PATH /usr/local/jsoftware/bin:$PATH

# bat, osquery
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    dpkg --install /downloads/bat.deb /downloads/osquery.deb

# Julia, trdsql (apply sql to csv), Clojure
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    tar xf /downloads/julia.tar.gz -C /usr/local \
    && unzip /downloads/trdsql.zip -d /usr/local \
    && ln -s /usr/local/trdsql_v1.0.0_linux_*/trdsql /usr/local/bin \
    && /bin/bash /downloads/clojure_install.sh
ENV PATH $PATH:/usr/local/julia-1.10.4/bin
# Clojure が実行時に必要とするパッケージを取得
RUN clojure -e '(println "test")'
# Clojure ワンライナー
RUN curl -s --retry 5 https://raw.githubusercontent.com/borkdude/babashka/master/install | bash

# PowerShell
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    mkdir -p /usr/local/powershell \
    && tar xf /downloads/powershell.tar.gz -C /usr/local/powershell \
    && ln -s /usr/local/powershell/pwsh /usr/local/bin/

# morsed
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    if [ "${TARGETARCH}" = "amd64" ]; then \
      tar xf /downloads/morsed_linux.tar.gz -C /usr/local/ \
      && ln -s /usr/local/morsed_linux/morsed /usr/local/bin/; \
    fi

# man
RUN mv /usr/bin/man.REAL /usr/bin/man

# reset apt config
RUN rm /etc/apt/apt.conf.d/keep-cache /etc/apt/apt.conf.d/no-install-recommends
COPY --from=ubuntu:24.04 /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/

# ShellgeiBot-Image information
RUN mkdir -p /etc/shellgeibot-image
COPY revision.log /etc/shellgeibot-image
COPY ci_build.log /etc/shellgeibot-image
COPY LICENSE /etc/shellgeibot-image
COPY README.md /etc/shellgeibot-image
COPY bin/shellgeibot-image /usr/local/bin
