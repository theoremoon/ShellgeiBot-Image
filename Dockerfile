# syntax = docker/dockerfile:1.0-experimental
FROM ubuntu:19.04 AS apt-cache
RUN apt-get update

FROM ubuntu:19.04 AS base
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
RUN curl -sfSL --retry 3 https://dl.google.com/go/go1.12.linux-amd64.tar.gz -o go.tar.gz \
    && tar xzf go.tar.gz -C /usr/local \
    && rm go.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /root/go
RUN --mount=type=cache,target=/root/go/src \
    --mount=type=cache,target=/root/.cache/go-build \
    go get -u -ldflags '-w -s' \
      github.com/YuheiNakasaka/sayhuuzoku \
      github.com/tomnomnom/gron \
      github.com/ericchiang/pup \
      github.com/sugyan/ttyrec2gif \
      github.com/xztaityozx/owari \
      github.com/jiro4989/align \
      github.com/jiro4989/taishoku \
      github.com/jiro4989/textimg \
      github.com/greymd/ojichat \
    && CGO_LDFLAGS="`mecab-config --libs`" CGO_CFLAGS="-I`mecab-config --inc-dir`" \
      go get -u -ldflags '-w -s' github.com/ryuichiueda/ke2daira \
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
RUN git clone --depth 1 https://github.com/googlefonts/noto-emoji /usr/local/src/noto-emoji

## Ruby
FROM base AS ruby-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq ruby-dev
RUN --mount=type=cache,target=/root/.gem \
    gem install --quiet --no-ri --no-rdoc cureutils matsuya takarabako snacknomama rubipara marky_markov
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/hostilefork/whitespacers/master/ruby/whitespace.rb -o /usr/local/bin/whitespace
RUN chmod +x /usr/local/bin/whitespace

## Python
FROM base AS python-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq python3-dev python3-pip python3-setuptools
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --progress-bar=off yq faker sympy numpy scipy matplotlib xonsh pillow asciinema

## Node.js
FROM base AS nodejs-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq nodejs npm
RUN --mount=type=cache,target=/root/.npm \
    npm install -g --silent faker-cli chemi

## .NET
FROM base AS dotnet-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq mono-mcs
RUN git clone --depth 1 https://github.com/xztaityozx/noc.git
RUN mcs noc/noc/noc/Program.cs

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
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq nim
RUN nimble install rect -Y

## V
FROM base AS v-builder
RUN mkdir -p /root/code
RUN git clone --depth 1 https://github.com/vlang/v /root/code/v
WORKDIR /root/code/v/compiler
RUN curl -sfSLO https://vlang.io/v.c
RUN cc -w -o vc v.c
RUN ./vc -o v .

## General
FROM base AS general-builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y -qq lib32ncursesw5-dev

# gawk 5.0
RUN curl -sfSLO https://ftp.gnu.org/gnu/gawk/gawk-5.0.0.tar.gz
RUN tar xf gawk-5.0.0.tar.gz
WORKDIR /gawk-5.0.0
RUN ./configure --program-suffix="-5.0.0"
RUN make
RUN make install
WORKDIR /

# Open-usp-Tukubai
RUN git clone --depth 1 https://github.com/usp-engineers-community/Open-usp-Tukubai.git
WORKDIR /Open-usp-Tukubai
RUN make install
WORKDIR /

# edfsay
RUN git clone --depth 1 https://github.com/jiro4989/edfsay
WORKDIR /edfsay
RUN ./install.sh
WORKDIR /

# no more secrets
RUN git clone --depth 1 https://github.com/bartobri/no-more-secrets.git
WORKDIR /no-more-secrets
RUN make nms-ncurses && make sneakers-ncurses && make install
WORKDIR /

# shellgei data
RUN git clone --depth 1 https://github.com/ryuichiueda/ShellGeiData.git

# unicode data
RUN curl -sfSLO --retry 3 https://www.unicode.org/Public/UCD/latest/ucd/NormalizationTest.txt
RUN curl -sfSLO --retry 3 https://www.unicode.org/Public/UCD/latest/ucd/NamesList.txt

WORKDIR /downloads
# egison
RUN curl -sfSLO --retry 3 https://git.io/egison-3.7.14.x86_64.deb
# egzact
RUN curl -sfSLO --retry 3 https://git.io/egzact-1.3.1.deb
# J
RUN curl -sfSL --retry 3 http://www.jsoftware.com/download/j807/install/j807_linux64_nonavx.tar.gz -o j.tar.gz
# Julia
RUN curl -sfSL --retry 3 https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1.0-linux-x86_64.tar.gz -o julia.tar.gz
# OpenJDK
RUN curl -sfSL --retry 3 https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz -o openjdk11.tar.gz
# trdsql
RUN curl -sfSLO --retry 3 https://github.com/noborus/trdsql/releases/download/v0.5.0/trdsql_linux_amd64.zip
# bat
RUN curl -sfSLO --retry 3 https://github.com/sharkdp/bat/releases/download/v0.10.0/bat_0.10.0_amd64.deb
# onefetch
RUN curl -sfSLO --retry 3 https://github.com/o2sh/onefetch/releases/download/v1.5.2/onefetch_linux_x86-64.zip
# osquery
RUN curl -sfSL --retry 3 https://pkg.osquery.io/deb/osquery_3.3.2_1.linux.amd64.deb -o osquery.deb
WORKDIR /


## Runtime
FROM base AS runtime

# Set environments
ENV LANG ja_JP.UTF-8
ENV TZ JST-9
ENV PATH /usr/games:$PATH

# home-commands (echo-sd)
WORKDIR /root
RUN git clone --depth 1 https://github.com/fumiyas/home-commands.git \
    && cd home-commands \
    && git archive --format=tar --prefix=home-commands/ HEAD | (cd / && tar xf -) \
    && rm -rf /root/home-commands
ENV PATH /home-commands:$PATH
WORKDIR /

# super_unko
RUN curl -sfSLO --retry 3 https://git.io/superunko.deb \
    && dpkg -i superunko.deb \
    && rm superunko.deb

# nameko.svg
RUN curl -sfSLO --retry 3 https://gist.githubusercontent.com/KeenS/6194e6ef1a151c9ea82536d5850b8bc7/raw/85af9ec757308b8ca4effdf24221f642cb34703b/nameko.svg

# imgout
RUN git clone --depth 1 https://github.com/ryuichiueda/ImageGeneratorForShBot.git
ENV PATH /ImageGeneratorForShBot:$PATH

# zws
RUN curl -sfSLO --retry 3 https://raintrees.net/attachments/download/486/zws \
    && chmod +x zws

# sushiro
RUN curl -sfSL --retry 3 https://raw.githubusercontent.com/redpeacock78/sushiro/master/sushiro -o /usr/local/bin/sushiro \
    && chmod +x /usr/local/bin/sushiro

# echo-meme
RUN curl -sfSLO --retry 3 https://git.io/echo-meme.deb \
    && dpkg -i echo-meme.deb \
    && rm echo-meme.deb

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
      lolcat\
      nyancat\
      imagemagick ghostscript\
      moreutils\
      strace\
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
      chromium-browser chromium-chromedriver w3m nginx\
      screenfetch\
      mono-runtime\
      firefox\
      lua5.3 php7.2 php7.2-cli php7.2-common\
      nodejs\
      graphviz\
      nim\
      bats\
      libncurses5\
      faketime\
      tree\
      numconv\
      file\
      python3-pkg-resources\
      fonts-droid-fallback fonts-lato fonts-liberation fonts-noto-mono fonts-dejavu-core gsfonts

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
COPY --from=python-builder /usr/local/lib/python3.7 /usr/local/lib/python3.7
RUN ln -s /usr/bin/python3 /usr/bin/python

# Node.js
COPY --from=nodejs-builder /usr/local/bin /usr/local/bin
COPY --from=nodejs-builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# .NET
COPY --from=dotnet-builder /noc/noc/noc/Program.exe /usr/local/noc/noc
COPY --from=dotnet-builder /noc/LICENSE /noc/README.md /usr/local/noc/
RUN echo 'mono /usr/local/noc/noc "$@"' > /usr/local/bin/noc && chmod +x /usr/local/bin/noc

# Rust
COPY --from=rust-builder /root/.cargo/bin /root/.cargo/bin
COPY --from=rust-builder /tmp/root /root
ENV PATH $PATH:/root/.cargo/bin

# Nim
COPY --from=nim-builder /root/.nimble /root/.nimble
ENV PATH $PATH:/root/.nimble/bin

# V
RUN --mount=type=bind,target=/tmp/code/v,from=v-builder,source=/root/code/v \
    mkdir -p /root/code/v \
    && (cd /tmp/code/v && git archive --format=tar HEAD) | (cd /root/code/v && tar xf -) \
    && cp /tmp/code/v/compiler/v /root/code/v/compiler/v \
    && ln -s /root/code/v/compiler/v /usr/local/bin/v

# gawk 5.0 / Open-usp-Tukubai / edfsay / no more secrets
COPY --from=general-builder /usr/local /usr/local

# shellgei data
COPY --from=general-builder /ShellGeiData /ShellGeiData

# unicode data
COPY --from=general-builder /NormalizationTest.txt /NamesList.txt /

# egison, egzact, bat, osquery
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    dpkg -i \
      /downloads/egison-3.7.14.x86_64.deb \
      /downloads/egzact-1.3.1.deb \
      /downloads/bat_0.10.0_amd64.deb \
      /downloads/osquery.deb

# J
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    tar xf /downloads/j.tar.gz
ENV PATH $PATH:/j64-807/bin

# Julia
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    tar xf /downloads/julia.tar.gz \
    && ln -s $(realpath $(ls | grep -E "^julia") )/bin/julia /usr/local/bin/julia

# OpenJDK
# jconsole コマンドが OpenJDK と J で重複するため、J の PATH を優先
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    tar xf /downloads/openjdk11.tar.gz
ENV PATH $PATH:/jdk-11.0.2/bin

# trdsql (apply sql to csv)
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    unzip /downloads/trdsql_linux_amd64.zip
ENV PATH $PATH:/trdsql_linux_amd64

# onefetch
RUN --mount=type=bind,target=/downloads,from=general-builder,source=/downloads \
    unzip /downloads/onefetch_linux_x86-64.zip -d /usr/local/bin onefetch

# man
RUN mv /usr/bin/man.REAL /usr/bin/man

# reset apt config
RUN rm /etc/apt/apt.conf.d/keep-cache /etc/apt/apt.conf.d/no-install-recommends
COPY --from=ubuntu:19.04 /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/

CMD /bin/bash
