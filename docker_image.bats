#!/usr/bin/env bats

@test "Ruby" {
  run bash -c "echo シェル芸 | ruby -nle 'puts \$_'"
  [ "$output" = "シェル芸" ]
}

@test "ccze" {
  run bash -c "echo シェル芸 | ccze -A"
  [[ "$output" =~ シェル芸 ]]
}

@test "screen" {
  run bash -c "screen -v"
  [[ "$output" =~ Screen ]]
}

@test "tmux" {
  run tmux -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "ttyrec" {
  run bash -c "ttyrec -h"
  [[ "$output" =~ ttyrec ]]
}

@test "TiMidity++" {
  run bash -c "timidity -v"
  [[ "$output" =~ TiMidity\+\+ ]]
}

@test "abcMIDI" {
  run bash -c "abc2midi -ver"
  [[ "$output" =~ abc2midi ]]
}

@test "R" {
  run bash -c "echo シェル芸 | R -q -e 'cat(readLines(\"stdin\"))'"
  [[ "$output" =~ シェル芸 ]]
}

@test "boxes" {
  run bash -c "echo シェル芸 | boxes"
  [[ "$output" =~ \/\*\ シェル芸\ \*\/ ]]
}

# /bin/ash は /bin/dash へのエイリアス, /usr/bin/ash は /usr/bin/dash へのエイリアスで、両方とも同じ
# apt install ash ではエイリアスが作成されるのみ
@test "ash" {
  run ash -c "echo シェル芸"
  [ "$output" = シェル芸 ]
}

@test "yash" {
  run yash -c "echo シェル芸"
  [ "$output" = シェル芸 ]
}

@test "jq" {
  run bash -c "echo シェル芸 | jq -Rr '.'"
  [ "$output" = シェル芸 ]
}

@test "Vim" {
  run bash -c "echo シェル芸 | vim -es +%p +q! /dev/stdin"
  [ "$output" = シェル芸 ]
}

@test "Emacs" {
  run bash -c "echo シェル芸 | emacs -Q --batch --insert /dev/stdin --eval='(princ (buffer-string))'"
  [ "$output" = シェル芸 ]
}

@test "Not python2" {
  run python --version
  [[ ! "$output" =~ 'Python 2.' ]]
}

@test "Python3" {
  run python3 --version
  [[ "$output" =~ 'Python 3.' ]]
}

@test "nkf" {
  run bash -c "echo シェル芸 | nkf"
  [ "$output" = シェル芸 ]
}

@test "rs" {
  run bash -c "echo シェル芸 | grep -o . | rs -T | tr -d ' '"
  [ "$output" = シェル芸 ]
}

@test "pwgen" {
  run bash -c "pwgen -h"
  [ $status -eq 1 ]
  [[ "$output" =~ pwgen ]]
}

@test "bc" {
  run bash -c "echo 'print \"シェル芸\n\"' | bc"
  [ "$output" = "シェル芸" ]
}

@test "Perl" {
  run bash -c "echo シェル芸 | perl -nle 'print \$_'"
  [ "$output" = "シェル芸" ]
}

@test "toilet" {
  run bash -c "echo シェル芸 | toilet"
  [ "${lines[0]}" = '                                          ' ]
  [ "${lines[1]}" = '   ""m                        m  "m       ' ]
  [ "${lines[2]}" = '  mm                           #  #       ' ]
  [ "${lines[3]}" = '    "    m"      mmm""         #  #   #   ' ]
  [ "${lines[4]}" = '       m"          #mm        m"  # m"    ' ]
  [ "${lines[5]}" = '  "mm""         """"  "      m"   #"      ' ]
  [ "${lines[6]}" = '                                          ' ]
  [ "${lines[7]}" = '                                          ' ]
}

@test "figlet" {
  run bash -c "echo ShellGei | figlet"
  echo "lines[0]: '${lines[0]}'"
  [ "${lines[0]}" = " ____  _          _ _  ____      _ " ]
  [ "${lines[1]}" = "/ ___|| |__   ___| | |/ ___| ___(_)" ]
  [ "${lines[2]}" = "\___ \| '_ \ / _ \ | | |  _ / _ \ |" ]
  [ "${lines[3]}" = " ___) | | | |  __/ | | |_| |  __/ |" ]
  [ "${lines[4]}" = "|____/|_| |_|\___|_|_|\____|\___|_|" ]
}

@test "Haskell" {
  run ghc -e 'putStrLn "シェル芸"'
  [ "$output" = "シェル芸" ]
}

@test "Git" {
  run git version
  [[ "$output" =~ "git version" ]]
}

@test "build-essential" {
  run gcc --version
  [[ "${lines[0]}" =~ gcc ]]
}

@test "mecab" {
  run bash -c "echo シェル芸 | mecab -Owakati"
  [ "$output" = "シェル 芸 " ]
}

@test "curl" {
  run curl --help
  [ "${lines[0]}" = "Usage: curl [options...] <url>" ]
}

@test "bsdgames" {
  run bash -c "echo '... .... . .-.. .-.. --. . ..  ...-.-' | morse -d"
  [ "$output" = "SHELLGEI" ]
}

@test "fortune" {
  run fortune
  [ $status -eq 0 ]
}

@test "cowsay" {
  run cowsay シェル芸
  [ "${lines[0]}" = ' __________' ]
  [ "${lines[1]}" = '< シェル芸 >' ]
  [ "${lines[2]}" = ' ----------' ]
  [ "${lines[3]}" = '        \   ^__^' ]
  [ "${lines[4]}" = '         \  (oo)\_______' ]
  [ "${lines[5]}" = '            (__)\       )\/\' ]
  [ "${lines[6]}" = '                ||----w |' ]
  [ "${lines[7]}" = '                ||     ||' ]
}

@test "datamash" {
  run datamash --version
  [[ "${lines[0]}" =~ "datamash (GNU datamash)" ]]
}

@test "gawk" {
  run bash -c "echo シェル芸 | gawk '{print \$0}'"
  [ "$output" = "シェル芸" ]
}

@test "libxml2-utils" {
  run bash -c "echo '<?xml version=\"1.0\"?><e>ShellGei</e>' | xmllint --xpath '/e/text()' -"
  [ "$output" = "ShellGei" ]
}

@test "zsh" {
  run zsh -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "num-utils" {
  run numaverage -h
  [ "${lines[1]}" = "numaverage : A program for finding the average of numbers." ]
}

# 不要では?
@test "apache2-utils" {
  run ab -V
  [[ "${lines[0]}" =~ "ApacheBench" ]]
}

@test "fish" {
  run fish -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "lolcat" {
  run lolcat --version
  [[ "${lines[0]}" =~ "lolcat" ]]
}

@test "nyancat" {
  run nyancat -h
  [ "${lines[0]}" = "Terminal Nyancat" ]
}

@test "ImageMagick" {
  run convert -version
  [[ "${lines[0]}" =~ "Version: ImageMagick" ]]
}

@test "moreutils" {
  run errno 1
  [ "$output" = "EPERM 1 許可されていない操作です" ]
}

@test "whiptail" {
  run whiptail -v
  [[ "$output" =~ "whiptail" ]]
}

@test "pandoc" {
  run pandoc -v
  [[ "${lines[0]}" =~ "pandoc" ]]
}

@test "postgresql" {
  run which psql
  [ "$output" = "/usr/bin/psql" ]
}

@test "uconv" {
  run bash -c "echo 30b730a730eb82b8 | xxd -p -r | uconv -f utf-16be -t utf-8"
  [ "$output" = "シェル芸" ]
}

@test "tcsh" {
  run tcsh -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

# 不要?
@test "libskk-dev" {
  run stat /usr/lib/x86_64-linux-gnu/libskk.so
  [ "${lines[0]}" = "  File: /usr/lib/x86_64-linux-gnu/libskk.so -> libskk.so.0.0.0" ]
}

@test "kkc" {
  run kkc help
  [[ "${lines[1]}" =~ "  kkc help" ]]
}

@test "morsegen" {
  run morsegen
  [ $status -eq 1 ]
  [[ "${lines[1]}" =~ "Morse Generator." ]]
}

@test "dc" {
  run dc -V
  [[ "${lines[0]}" =~ "dc" ]]
}

@test "telnet" {
  run telnet -h
  [ $status -eq 1 ]
  [ "${lines[0]}" = "telnet: invalid option -- 'h'" ]
}

@test "busybox" {
  run /bin/busybox echo "シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "parallel" {
  run parallel --version
  [[ "${lines[0]}" =~ "GNU parallel" ]]
}

@test "rename" {
  run rename -V
  [[ "${lines[0]}" =~ "/usr/bin/rename" ]]
}

@test "mt" {
  run mt -v
  [[ "${lines[0]}" =~ "mt-st" ]]
}

@test "ffmpeg" {
  run ffmpeg -version
  [[ "${lines[0]}" =~ "ffmpeg version" ]]
}

@test "kakasi" {
  run bash -c "echo シェル芸 | nkf -e | kakasi -JH | nkf -w"
  [ "$output" = "シェルげい" ]
}

@test "dateutils" {
  run /usr/bin/dateutils.dtest -V
  [[ "$output" =~ "datetest" ]]
}

@test "fonts-ipafont" {
  run bash -c "fc-list | grep ipa | wc -l"
  [ $output -ge 4 ]
}

@test "fonts-vlgothic" {
  run bash -c "fc-list | grep vlgothic | wc -l"
  [ $output -ge 2 ]
}

@test "gnuplot" {
  run gnuplot -V
  [[ "$output" =~ "gnuplot" ]]
}

@test "qrencode" {
  run qrencode -V
  [[ "${lines[0]}" =~ "qrencode version" ]]
}

@test "fonts-nanum" {
  run bash -c "fc-list | grep nanum | wc -l"
  [ $output -ge 10 ]
}

@test "fonts-symbola" {
  run bash -c "fc-list | grep Symbola | wc -l"
  [ $output -ge 1 ]
}

@test "fonts-noto-color-emoji" {
  run bash -c "fc-list | grep NotoColorEmoji | wc -l"
  [ $output -ge 1 ]
}

@test "sl" {
  run which sl
  [ "$output" = /usr/games/sl ]
}

@test "chromium" {
  run chrome --version
  [[ "$output" =~ "Chromium" ]]
}

@test "nginx" {
  run nginx -v
  [[ "$output" =~ "nginx version:" ]]
}

@test "screenfetch" {
  run bash -c "screenfetch -V | sed $'s/\033\[[0-9]m//g'"
  [[ "${lines[0]}" =~ "screenFetch - Version" ]]
}

@test "mono-runtime" {
  run mono --version
  [[ "${lines[0]}" =~ "Mono JIT compiler version" ]]
}

@test "firefox" {
  run firefox --version
  [[ "$output" =~ "Mozilla Firefox" ]]
}

@test "lua" {
  run lua -e 'print("シェル芸")'
  [ "$output" = "シェル芸" ]
}

@test "php" {
  run php -r 'echo "シェル芸\n";'
  [ "$output" = "シェル芸" ]
}

@test "cureutils" {
  run bash -c "cure girls | head -1"
  [ "$output" = "美墨なぎさ" ]
}

@test "matsuya" {
  run matsuya
  [ $status -eq 0 ]
}

@test "takarabako" {
  run takarabako
  [ $status -eq 0 ]
}

@test "snacknomama" {
  run snacknomama
  [ $status -eq 0 ]
}

@test "rubipara" {
  run rubipara kashikoma
  [ "${lines[0]}"  = '                 ／^v ＼'                                      ]
  [ "${lines[1]}"  = '               _{ / |-.(`_￣}__'                               ]
  [ "${lines[2]}"  = "        _人_  〃⌒ ﾝ'八{   ｀ノト､\`ヽ"                           ]
  [ "${lines[3]}"  = '        `Ｙ´  {l／ / /    / Ｖﾉ } ﾉ    (     Kashikoma!     )'  ]
  [ "${lines[4]}"  = '          ,-ｍ彡-ｧ Ｌﾒ､_彡ｲ } }＜く   O'                         ]
  [ "${lines[5]}"  = "         / _Uヽ⊂ﾆ{J:}  '⌒Ｖ  {  l| o"                          ]
  [ "${lines[6]}"  = "       ／  r‐='V(｢\`¨,  r=≪,/ { .ﾉﾉ"                           ]
  [ "${lines[7]}"  = '      /   /_xヘ 人 丶-  _彡ｲ ∧〉'                               ]
  [ "${lines[8]}"  = '      (  ノ¨ﾌ’  ｀^> ‐ｧｧ ＜¨ﾌｲ'                                 ]
  [ "${lines[9]}"  = "       --＝〉_丶/ﾉ { 彡' '|           Everyone loves Pripara!"  ]
  [ "${lines[10]}" = "           ^  '7^ O〉|’ ,丿"                                   ]
  [ "${lines[11]}" = '＿＿＿＿ ___ __ _{’O 乙,_r[_ __ ___ __________________________' ]
}

@test "zen_to_i" {
  run bash -c 'ruby -rzen_to_i -pe \$_=\$_.zen_to_i <<< 三十二'
  [ "${lines[0]}" = '32' ]
}

@test "marky_markov" {
  run marky_markov -h
  [ "${lines[0]}" = 'Usage: marky_markov COMMAND [OPTIONS]' ]
}

@test "yq" {
  run yq --version
  [[ "${lines[0]}" =~ "yq" ]]
}

@test "faker" {
  run faker name
  [ $status -eq 0 ]
}

@test "sympy" {
  run python3 -c 'import sympy; print(sympy.__name__)'
  [ "$output" = "sympy" ]
}

@test "numpy" {
  run python3 -c 'import numpy; print(numpy.__name__)'
  [ "$output" = "numpy" ]
}

@test "scipy" {
  run python3 -c 'import scipy; print(scipy.__name__)'
  [ "$output" = "scipy" ]
}

@test "matplotlib" {
  run python3 -c 'import matplotlib; print(matplotlib.__name__)'
  [ "$output" = "matplotlib" ]
}

@test "xonsh" {
  run xonsh -c 'echo シェル芸'
  [ "$output" = "シェル芸" ]
}

@test "pillow" {
  run python3 -c 'import PIL; print(PIL.__name__)'
  [ "$output" = "PIL" ]
}

@test "asciinema" {
  run asciinema --version
  [[ "${lines[0]}" =~ "asciinema " ]]
}

@test "egison" {
  run egison -e '(foldl + 0 (take 10 nats))'
  [ "$output" = "55" ]
}

@test "egzact" {
  run bash -c "echo シェル芸 | dupl 2"
  [ "${lines[0]}" = 'シェル芸' ]
  [ "${lines[1]}" = 'シェル芸' ]
}

@test "faker-cli" {
  run faker-cli --help
  [ "${lines[0]}" = 'Usage: faker-cli [option]' ]
}

@test "chemi" {
  run chemi -s H
  [ "${lines[2]}" = 'element     : Hydrogen' ]
}

@test "home-commands" {
  run echo-sd シェル芸
  [ "${lines[0]}" = '＿人人人人人人＿' ]
  [ "${lines[1]}" = '＞　シェル芸　＜' ]
  [ "${lines[2]}" = '￣Y^Y^Y^Y^Y^Y^￣' ]
}

@test "tate" {
  run tate
  [ "${lines[0]}" = 'ご そ ツ 気' ]
  [ "${lines[1]}" = '提 ん イ 軽' ]
  [ "${lines[2]}" = '供 な ｜ に' ]
  [ "${lines[3]}" = '！ 素 ト ﹁' ]
  [ "${lines[4]}" = '︵ 敵 で う' ]
  [ "${lines[5]}" = '無 な き ん' ]
  [ "${lines[6]}" = '保 ソ る こ' ]
  [ "${lines[7]}" = '証 リ ︑ ﹂' ]
  [ "${lines[8]}" = '︶ ュ 　 と' ]
  [ "${lines[9]}" = '　 ｜' ]
  [ "${lines[10]}" = '　 シ' ]
  [ "${lines[11]}" = '　 ョ' ]
  [ "${lines[12]}" = '　 ン' ]
  [ "${lines[13]}" = '　 を' ]
}

@test "J" {
  run bash -c "echo \"'シェル芸'\" | jconsole"
  echo "'${lines[0]}'"
  [ "${lines[0]}" = '   シェル芸' ]
}

@test "trdsql" {
  run trdsql -help 2>&1
  [ "${lines[1]}" = 'Usage: trdsql [OPTIONS] [SQL(SELECT...)]' ]
}

@test "openjdk11" {
  run javac -version
  [[ "${output}" =~ "javac " ]]
}

@test "super unko" {
  run unko.tower 2
  [ "${lines[0]}" = '　　　　人' ]
  [ "${lines[1]}" = '　　（　　　）' ]
  [ "${lines[2]}" = '　（　　　　　）' ]
}

@test "nameko.svg" {
  run file nameko.svg
  [ "$output" = 'nameko.svg: SVG Scalable Vector Graphics image' ]
}

@test "sayhuuzoku" {
  run sayhuuzoku g
  [ $status -eq 0 ]
}

@test "sayhoozoku shoplist" {
  run stat "/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/shoplist.txt"
  [ "${lines[0]}" = '  File: /root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/shoplist.txt' ]
}

@test "gron" {
  run bash -c "echo '{\"s\":\"シェル芸\"}' | gron -m"
  [ "${lines[1]}" = 'json.s = "シェル芸";' ]
}

@test "pup" {
  run pup --help
  [ "${lines[1]}" = '    pup [flags] [selectors] [optional display function]' ]
}

@test "ttyrec2gif" {
  run ttyrec2gif -help
  [ "${lines[0]}" = 'Usage of ttyrec2gif:' ]
}

@test "owari" {
  run owari -w 20
  [ "${lines[0]}" = '        糸冬' ]
}

@test "align" {
  run bash -c "yes シェル芸 | head -4 | awk '{print substr(\$1,1,NR)}' | align center"
  [ "${lines[0]}" = '   シ   ' ]
  [ "${lines[1]}" = '  シェ  ' ]
  [ "${lines[2]}" = ' シェル ' ]
  [ "${lines[3]}" = 'シェル芸' ]
}

@test "taishoku" {
  run taishoku
  [ "${lines[0]}" = '　　　代株　　　　二退こ　　　　　　' ]
}

@test "textimg" {
  run textimg --version
  [[ "$output" =~ "textimg version " ]]
}

@test "whitespace" {
  run bash -c "echo -e '   \t \t  \t\t\n\t\n     \t\t \t   \n\t\n     \t\t  \t \t\n\t\n     \t\t \t\t  \n\t\n     \t\t \t\t  \n\t\n     \t   \t\t\t\n\t\n     \t\t  \t \t\n\t\n     \t\t \t  \t\n\t\n  \n\n' | whitespace"
  [ "$output" = 'ShellGei' ]
}

@test "Open usp Tukubai" {
  run bash -c "echo シェル芸 | grep -o . | tateyoko"
  [ "$output" = 'シ ェ ル 芸' ]
}

@test "julia" {
  run julia -e 'println("シェル芸")'
  [ "$output" = 'シェル芸' ]
}

@test "rustc" {
  run rustc --help
  [ $status -ne 0 ]
  [ "$output" = 'error: no default toolchain configured' ]
}

@test "rustup" {
  run rustup --help
  [ $status -eq 0 ]
  [ "${lines[1]}" = 'The Rust toolchain installer' ]
}

@test "rargs" {
  run rargs --help
  [[ "${lines[0]}" =~ "Rargs " ]]
  [ "${lines[2]}" = 'Xargs with pattern matching' ]
}

@test "ShellGeiData" {
  run stat /ShellGeiData/README.md
  [ "${lines[0]}" = '  File: /ShellGeiData/README.md' ]
}

@test "imgout" {
  run imgout -h
  [ "$output" = 'usage: imgout [-f <font>]' ]
}

@test "kkcw" {
  run kkcw <<< やまだたろう
  [ "$output" = '山田太郎' ]
}

@test "zws" {
  run bash -c "echo J+KBouKAjeKAi+KBouKAjeKAi+KAi+KAjeKAjeKBouKAjOKBouKBouKAjeKAi+KBouKAjeKAi+KAi+KAjeKAjeKAjeKAjOKBouKBouKAjeKAi+KBouKAjeKAi+KAi+KBouKAjeKAjeKAjeKBouKBouKAjeKAjeKAi+KAjeKAi+KAjeKAjeKAjeKBouKAjeKAi+KAi+KAi+KAjeKAjScK | base64 -d | zws -d"
  [ "$output" = 'シェル芸' ]
}

@test "osquery" {
  run osqueryi --version
  [[ "$output" =~ 'osqueryi version ' ]]
}

@test "onefetch" {
  run bash -c "cd /ShellGeiData && onefetch | sed $'s/\033[^m]*m//g'"
  [[ "${lines[0]}" =~ 'Project: ShellGeiData' ]]
}

@test "sushiro" {
  run sushiro -l
  [ $status -eq 0 ]
  [[ ! "${output}" =~ '/usr/local/share/sushiro_cache' ]]
}

@test "noc" {
  run noc --decode 部邊邊󠄓邊󠄓邉邉󠄊邊邊󠄒邊󠄓邊󠄓邉邉󠄊辺邉󠄊邊邊󠄓邊󠄓邉邉󠄎辺邉󠄎邊辺󠄀邉邉󠄈辺邉󠄍邊邊󠄓部
  [ "$output" = 'シェル芸' ]
}

@test "bat" {
  run bat --version
  [[ "$output" =~ "bat " ]]
}

@test "echo-meme" {
  run echo-meme シェル芸
  [[ "$output" =~ "シェル芸" ]]
}

@test "bash 5.0" {
  run bash --version
  [[ "${lines[0]}" =~ "GNU bash, バージョン 5.0" ]]
}

@test "awk 5.0" {
  run /usr/local/bin/awk --version
  [[ "${lines[0]}" =~ "GNU Awk 5.0" ]]
}

@test "reiwa" {
  run date -d '2019-05-01' '+%Ec'
  [ "$output" = '令和元年05月01日 00時00分00秒' ]
}

@test "NormalizationTest.txt" {
  run stat NormalizationTest.txt
  [ "${lines[0]}" = '  File: NormalizationTest.txt' ]
}

@test "NamesList.txt" {
  run stat NamesList.txt
  [ "${lines[0]}" = '  File: NamesList.txt' ]
}

@test "ke2daira" {
  run bash -c "echo シェル 芸 | ke2daira"
  [ "$output" = 'ゲェル シイ' ]
}

@test "man" {
  run bash -c "man シェル芸 |& cat"
  [ "$output" = 'シェル芸 というマニュアルはありません' ]
}

@test "graphviz" {
  run dot -V
  [[ "${lines[0]}" =~ 'dot - graphviz' ]]
}

@test "nim" {
  run nim --help
  [[ "${lines[0]}" =~ 'Nim Compiler' ]]
}

@test "rect" {
  run rect --help
  [ "${lines[0]}" = 'rect is a command to crop/paste rectangle text' ]
}

@test "pokemonsay" {
  run pokemonsay --help
  [ "${lines[0]}" = '  Description: Pokemonsay makes a pokémon say something to you.' ]
}

@test "saizeriya" {
  run saizeriya
  [ $status -eq 0 ]
}

@test "edf" {
  run edf words scientist
  [ $status -eq 0 ]
}

@test "no-more-secrets" {
  run nms -v
  [ $status -eq 0 ]
}

@test "ojichat" {
  run ojichat --version
  [[ "${lines[0]}" =~ 'Ojisan Nanchatte (ojichat) command' ]]
}

@test "faketime" {
  run faketime --version
  [[ "${lines[0]}" =~ 'faketime: Version' ]]
}

@test "tree" {
  run tree --help
  [[ "${lines[0]}" =~ 'usage: tree' ]]
}

@test "forest" {
  run bash -c "echo シェル芸 | forest"
  [ "$output" = '└ ─ シェル芸' ]
}

@test "fujiaire" {
  run fujiaire フジエアー
  [ "$output" = "フピエアー" ]
}

@test "opy" {
  run bash -c 'seq 2 | opy "F1%2==1"'
  [ "$output" = "1" ]
}

@test "numconv" {
  run numconv -h
  [ "${lines[0]}" = 'Filter to convert integers from one number system to another.' ]
}

@test "w3m" {
  run w3m -version
  [[ "$output" =~ 'w3m version' ]]
}

@test "kagome" {
  run kagome -h
  [ "${lines[0]}" = 'Japanese Morphological Analyzer -- github.com/ikawaha/kagome' ]
}

@test "V" {
  run v version
  [[ "$output" =~ 'V ' ]]
}

@test "Brainf*ck" {
  run bash -c "echo '+++++++++[>+++++++++<-]>++.<+++++++++[>++<-]>+++.---.+++++++..<+++++++++[>----<-]>-.<+++++++++[>+++<-]>+++.++++.' | bf /dev/stdin"
  [ "$output" = 'ShellGei' ]
}

@test "nise" {
  run bash -c "echo 私はシェル芸を嗜みます | nise"
  [ "$output" = '我シェル芸嗜了' ]
}

@test "PowerShell" {
  run pwsh -C Write-Host シェル芸
  [ "$output" = 'シェル芸' ]
}

@test "color" {
  run bash -c "color 1f"
  [ "$output" = '[30m  \x1b[30m  [m[31m  \x1b[31m  [m[32m  \x1b[32m  [m[33m  \x1b[33m  [m[34m  \x1b[34m  [m[35m  \x1b[35m  [m[36m  \x1b[36m  [m[37m  \x1b[37m  [m' ]
}

@test "rainbow" {
  run bash -c "rainbow -f ansi_f -t text"
  [ "$output" = '[38;2;255;0;0mtext[m
[38;2;255;13;0mtext[m
[38;2;255;26;0mtext[m
[38;2;255;39;0mtext[m
[38;2;255;52;0mtext[m
[38;2;255;69;0mtext[m
[38;2;255;106;0mtext[m
[38;2;255;143;0mtext[m
[38;2;255;180;0mtext[m
[38;2;255;217;0mtext[m
[38;2;255;255;0mtext[m
[38;2;204;230;0mtext[m
[38;2;153;205;0mtext[m
[38;2;102;180;0mtext[m
[38;2;51;155;0mtext[m
[38;2;0;128;0mtext[m
[38;2;0;103;51mtext[m
[38;2;0;78;102mtext[m
[38;2;0;53;153mtext[m
[38;2;0;28;204mtext[m
[38;2;0;0;255mtext[m
[38;2;15;0;230mtext[m
[38;2;30;0;205mtext[m
[38;2;45;0;180mtext[m
[38;2;60;0;155mtext[m
[38;2;75;0;130mtext[m
[38;2;107;26;151mtext[m
[38;2;139;52;172mtext[m
[38;2;171;78;193mtext[m
[38;2;203;104;214mtext[m
[38;2;238;130;238mtext[m
[38;2;241;104;191mtext[m
[38;2;244;78;144mtext[m
[38;2;247;52;97mtext[m
[38;2;250;26;50mtext[m' ]
}

@test "csharp" {
  run csharp -e 'print("シェル芸")'
  [ "$output" = "シェル芸" ]
}

@test "5ktrillion" {
  run bash -c "5ktrillion -5"
  [ "$output" = '5000兆円欲しい！' ]
}

@test "terminal-parrot" {
  run terminal-parrot -h
  [ $status -eq 2 ]
  [ "${lines[0]}" == 'Usage of terminal-parrot:' ]
}

@test "cmatrix" {
  run cmatrix -h
  [[ "${lines[0]}" =~ 'Usage: cmatrix' ]]
}

@test "textchat" {
  run bash -c "textchat -n bob hello"
  [ "${lines[0]}" == ".-----.  .---------.                                                            " ]
  [ "${lines[1]}" == "| bob | <   hello  |                                                            " ]
  [ "${lines[2]}" == "\`-----'  \`---------'                                                            " ]
}

@test "HanazonoMincho" {
  run bash -c "fc-list | grep 花園明朝"
  [ "${lines[0]}" == '/usr/share/fonts/truetype/hanazono/HanaMinA.ttf: 花園明朝A,HanaMinA:style=Regular' ]
  [ "${lines[1]}" == '/usr/share/fonts/truetype/hanazono/HanaMinB.ttf: 花園明朝B,HanaMinB:style=Regular' ]
}

@test "ipcalc" {
  run ipcalc 192.168.10.55
  [ "${lines[0]}" = 'Address:   192.168.10.55        11000000.10101000.00001010. 00110111' ]
}

@test "yukichant" {
  run bash -c "echo -n unko | chant | chant -d"
  [ "$output" = "unko" ]
}

@test "rsvg-convert" {
  run rsvg-convert -v
  [[ "${output}" =~ 'rsvg-convert version' ]]
}

@test "agrep" {
  run bash -c "echo unko | agrep -2 miko"
  [ "$output" = "unko" ]
}

@test "xvfb" {
  run Xvfb -help
  [ "${lines[0]}" = 'use: X [:<display>] [option]' ]
}

@test "xterm" {
  run xterm -v
  [[ "$output" =~ 'XTerm' ]]
}

@test "x11-apps" {
  run which xwd
  [ "$output" = '/usr/bin/xwd' ]
}

@test "xdotool" {
  run xdotool --version
  [[ "$output" =~ 'xdotool version' ]]
}

@test "shellgeibot-image" {
  run shellgeibot-image help
  [ $status -eq 0 ]

  run shellgeibot-image revision
  [ $status -eq 0 ]

  run shellgeibot-image build-log
  [ $status -eq 0 ]
  [ "${lines[0]}" = '"build_num","vcs_revision","start_time","stop_time"' ]
  [[ "${lines[1]}" =~ ^.[0-9]+.,.*$ ]]
  [[ "${lines[2]}" =~ ^.[0-9]+.,.*$ ]]
  [[ "${lines[3]}" =~ ^.[0-9]+.,.*$ ]]
}

@test "dotnet" {
  run dotnet --version
  [[ "$output" == 2.2.* ]]
}

@test "muscular" {
  run bash -c "muscular shout ナイスバルク | grep -P -o '\p{Katakana}'|tr -d '\n'"
  [ "${lines[0]}" = 'ナイスバルク' ]
}

@test "ponpe" {
  run ponpe ponponpain haraita-i
  [ "$output" = 'pͪoͣnͬpͣoͥnͭpͣa͡iͥn' ]
}

@test "rb" {
  run which rb
  [ "$output" = '/usr/local/bin/rb' ]
}

@test "clojure" {
  run which clojure
  [ "$status" -eq 0 ]

  # JAVA_HOME未設定だったりランタイムがないと動かない
  run clojure -e '(println "Hello")'
  [ "$status" -eq 0 ]
  [ "$output" = 'Hello' ]
}

@test "longcat" {
  run longcat -i 4 -o /a.png
  [ -f /a.png ]
}

@test "kakikokera" {
  run bash -c "echo 柿杮杮杮柿杮柿杮柿杮杮柿杮杮杮柿柿杮杮柿杮柿杮杮柿杮杮柿杮杮杮杮 | kakikokera -d"
  [ "$output" = 'unko' ]
}

@test "horizon" {
  run bash -c "echo ⁃‐﹘╸―ⲻ━= | horizon -d"
  [ "$output" = 'unko' ]
}

@test "fx" {
  run bash -c "echo '{\"item\": \"unko\"}' | fx 'this.item'"
  [ "$output" = 'unko' ]
}

@test "csvquote" {
  run bash -c 'echo -e "unko,\"un,ko\"" | csvquote | cut -d "," -f 2 | csvquote -u'
  [ "$output" = '"un,ko"' ]
}

@test "maze" {
  run maze -h
  [ "$status" -eq 0 ]

  run maze -v
  [ "$status" -eq 0 ]

  run maze
  [ "$status" -eq 0 ]
}
