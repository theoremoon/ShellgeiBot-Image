#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

@test "5ktrillion" {
  run -0 bash -c "5ktrillion -5"
  [ "$output" = '5000兆円欲しい！' ]
}

@test "abcMIDI" {
  run -0 bash -c "abc2midi -ver"
  [[ "$output" =~ abc2midi ]]
}

# glimpse で入る
@test "agrep" {
  run -0 bash -c "echo unko | agrep -2 miko"
  [ "$output" = "unko" ]
}

@test "align" {
  run -0 bash -c "yes シェル芸 | head -4 | awk '{print substr(\$1,1,NR)}' | align center"
  [ "${lines[0]}" = '   シ   ' ]
  [ "${lines[1]}" = '  シェ  ' ]
  [ "${lines[2]}" = ' シェル ' ]
  [ "${lines[3]}" = 'シェル芸' ]
}

# 不要では?
@test "apache2-utils" {
  run -0 ab -V
  [[ "${lines[0]}" =~ "ApacheBench" ]]
}

@test "asciinema" {
  run -0 asciinema --version
  [[ "${lines[0]}" =~ "asciinema " ]]
}

# /bin/ash は /bin/dash へのエイリアス, /usr/bin/ash は /usr/bin/dash へのエイリアスで、両方とも同じ
# apt install ash ではエイリアスが作成されるのみ
@test "ash" {
  run -0 ash -c "echo シェル芸"
  [ "$output" = シェル芸 ]
}

@test "babashka" {
  # コマンドラインではbbコマンド
  run -0 which bb
  run -0 bb -i '(println "Hello")'
}

@test "base85" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "base85 is not installed on aarch64"; fi
  run -0 bash -c 'echo "<~j+=c#Ju@X]X6>GN~>" | base85 -d'
  [ "$output" = "シェル芸" ]
}

@test "bat" {
  run -0 bat --version
  [[ "$output" =~ "bat " ]]
}

@test "bbe" {
  run -0 bbe -?
  [[ "${lines[0]}" =~ "bbe " ]]
}

@test "bc" {
  run -0 bash -c "echo 'print \"シェル芸\n\"' | bc"
  [ "$output" = "シェル芸" ]
}

@test "boxes" {
  run -0 bash -c "echo シェル芸 | boxes"
  [[ "$output" =~ \/\*\ シェル芸\ \*\/ ]]
}

@test "Brainf*ck" {
  run -0 bash -c "echo '+++++++++[>+++++++++<-]>++.<+++++++++[>++<-]>+++.---.+++++++..<+++++++++[>----<-]>-.<+++++++++[>+++<-]>+++.++++.' | hsbrainfuck"
  [ "$output" = 'ShellGei' ]
}

@test "build-essential" {
  run -0 gcc --version
  [[ "${lines[0]}" =~ gcc ]]
}

@test "busybox" {
  run -0 /bin/busybox echo "シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "cal" {
  run -0 cal 12 2020
  [[ "${lines[0]}" =~ "12月 2020" ]]
}

@test "ccze" {
  run -0 bash -c "echo シェル芸 | ccze -A"
  [[ "$output" =~ シェル芸 ]]
}

@test "chemi" {
  run -0 chemi -s H
  [ "${lines[2]}" = 'element     : Hydrogen' ]
}

@test "clisp" {
  run -0 clisp -q -x '(+ 1 2)'
  [ "$output" = '3' ]
}

@test "clojure" {
  run -0 which clojure
  # JAVA_HOME未設定だったりランタイムがないと動かない
  run -0 clojure -M -e '(println "Hello")'
  [ "$output" = 'Hello' ]
}

@test "cmatrix" {
  run -0 cmatrix -h
  [[ "${lines[0]}" =~ 'Usage: cmatrix' ]]
}

@test "color" {
  run -0 bash -c "color 1f"
  [ "$output" = '[30m  \x1b[30m  [m[31m  \x1b[31m  [m[32m  \x1b[32m  [m[33m  \x1b[33m  [m[34m  \x1b[34m  [m[35m  \x1b[35m  [m[36m  \x1b[36m  [m[37m  \x1b[37m  [m' ]
}

@test "concat" {
  run -0 concat 'cat * 2'
  [ "${lines[0]}" = " /\    /  /\    /" ]
  [ "${lines[1]}" = "(' )  (  (' )  ( " ]
  [ "${lines[2]}" = " (  \  )  (  \  )" ]
  [ "${lines[3]}" = " |(__)/   |(__)/ " ]
}

@test "cowsay" {
  run -0 cowsay シェル芸
  [ "${lines[0]}" = ' __________' ]
  [ "${lines[1]}" = '< シェル芸 >' ]
  [ "${lines[2]}" = ' ----------' ]
  [ "${lines[3]}" = '        \   ^__^' ]
  [ "${lines[4]}" = '         \  (oo)\_______' ]
  [ "${lines[5]}" = '            (__)\       )\/\' ]
  [ "${lines[6]}" = '                ||----w |' ]
  [ "${lines[7]}" = '                ||     ||' ]
}

@test "csharp" {
  run -0 csharp -e 'print("シェル芸")'
  [ "$output" = "シェル芸" ]
}

@test "csvquote" {
  run -0 bash -c 'echo -e "unko,\"un,ko\"" | csvquote | cut -d "," -f 2 | csvquote -u'
  [ "$output" = '"un,ko"' ]
}

@test "cureutils" {
  run -0 bash -c "cure girls | head -1"
  [ "$output" = "美墨なぎさ" ]
}

@test "curl" {
  run -0 curl --help
  [ "${lines[0]}" = "Usage: curl [options...] <url>" ]
}

@test "datamash" {
  run -0 datamash --version
  [[ "${lines[0]}" =~ "datamash (GNU datamash)" ]]
}

@test "dateutils" {
  run -0 /usr/bin/dateutils.dtest -V
  [[ "$output" =~ "datetest" ]]
}

@test "dc" {
  run -0 dc -V
  [[ "${lines[0]}" =~ "dc" ]]
}

@test "dotnet" {
  run -0 dotnet --help
  [[ "${lines[0]}" == ".NET 10.0 へようこそ!" ]]
}

@test "eachdo" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "eachdo is not installed on aarch64"; fi
  run -0 eachdo -v
  [[ "$output" =~ "eachdo command" ]]
}

@test "echo-meme" {
  run -0 echo-meme シェル芸
  [[ "$output" =~ "シェル芸" ]]
}

@test "edens" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "edens is not installed on aarch64"; fi
  run -0 edens -h
}

@test "edf" {
  run -0 edf words scientist
}

@test "egison" {
  run -0 egison -e 'foldl (+) 0 (take 10 nats)'
  [ "$output" = "55" ]
}

@test "egzact" {
  run -0 bash -c "echo シェル芸 | dupl 2"
  [ "${lines[0]}" = 'シェル芸' ]
  [ "${lines[1]}" = 'シェル芸' ]
}

@test "eki" {
  run -0 bash -c "eki | grep -q 京急川崎"
  run -0 bash -c "eki line 京急川崎 | grep 大師"
  [ "$output" = '京急大師線' ]
}

@test "faker" {
  run -0 faker name
}

@test "faker-cli" {
  run -0 faker-cli --help
  [ "${lines[0]}" = 'Usage: faker-cli [option]' ]
}

@test "faketime" {
  run -0 faketime --version
  [[ "${lines[0]}" =~ 'faketime: Version' ]]
}

@test "ffmpeg" {
  run -0 ffmpeg -version
  [[ "${lines[0]}" =~ "ffmpeg version" ]]
}

@test "figlet" {
  run -0 bash -c "echo ShellGei | figlet"
  echo "lines[0]: '${lines[0]}'"
  [ "${lines[0]}" = " ____  _          _ _  ____      _ " ]
  [ "${lines[1]}" = "/ ___|| |__   ___| | |/ ___| ___(_)" ]
  [ "${lines[2]}" = "\___ \| '_ \ / _ \ | | |  _ / _ \ |" ]
  [ "${lines[3]}" = " ___) | | | |  __/ | | |_| |  __/ |" ]
  [ "${lines[4]}" = "|____/|_| |_|\___|_|_|\____|\___|_|" ]
}

@test "fish" {
  run -0 fish -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "fonts-ipafont" {
  run -0 bash -c "fc-list | grep ipa | wc -l"
  [ $output -ge 4 ]
}

@test "fonts-nanum" {
  run -0 bash -c "fc-list | grep nanum | wc -l"
  [ $output -ge 10 ]
}

@test "fonts-noto-color-emoji" {
  run -0 bash -c "fc-list | grep NotoColorEmoji | wc -l"
  [ $output -ge 1 ]
}

@test "fonts-symbola" {
  run -0 bash -c "fc-list | grep Symbola | wc -l"
  [ $output -ge 1 ]
}

@test "fonts-vlgothic" {
  run -0 bash -c "fc-list | grep vlgothic | wc -l"
  [ $output -ge 2 ]
}

@test "forest" {
  run -0 bash -c "echo シェル芸 | forest"
  [ "$output" = '└ ─ シェル芸' ]
}

@test "fortune" {
  run -0 fortune
}

@test "fujiaire" {
  run -0 fujiaire フジエアー
  [ "$output" = "フピエアー" ]
}

@test "funnychar" {
  run -0 funnychar -p 3 abcABC
  [ "$output" = '𝑎𝑏𝑐𝐴𝐵𝐶' ]
}

@test "fx" {
  run -0 bash -c "echo '{\"item\": \"unko\"}' | fx 'this.item'"
  [ "$output" = 'unko' ]
}

@test "gawk" {
  run -0 bash -c "echo シェル芸 | gawk '{print \$0}'"
  [ "$output" = "シェル芸" ]
}

@test "gdb" {
  run -0 gdb --help
  [ "${lines[0]}" = "This is the GNU debugger.  Usage:" ]
}

@test "Git" {
  run -0 git version
  [[ "$output" =~ "git version" ]]
}

@test "glue" {
  run -0 bash -c 'echo echo 10 | glue /dev/stdin'
  [[ "$output" =~ '10' ]]
}

@test "glueutils" {
  run -2 bash -c 'flip12 ls aaaaaaaaaaa'
  [ "$output" = "ls: 'aaaaaaaaaaa' にアクセスできません: そのようなファイルやディレクトリはありません" ]
}

@test "gnuplot" {
  run -0 gnuplot -V
  [[ "$output" =~ "gnuplot" ]]
}

@test "graphviz" {
  run -0 dot -V
  [[ "${lines[0]}" =~ 'dot - graphviz' ]]
}

@test "gron" {
  run -0 bash -c "echo '{\"s\":\"シェル芸\"}' | gron -m"
  [ "${lines[1]}" = 'json.s = "シェル芸";' ]
}

@test "gyaric" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "gyaric is not installed on aarch64"; fi
  run -0 gyaric -h
  [ "${lines[0]}" = "gyaric encode/decode a text to unreadable gyaru's text." ]
}

@test "HanazonoMincho" {
  run -0 bash -c "fc-list | grep 花園明朝"
  [ "${lines[0]}" == '/usr/share/fonts/truetype/hanazono/HanaMinA.ttf: 花園明朝A,HanaMinA:style=Regular' ]
  [ "${lines[1]}" == '/usr/share/fonts/truetype/hanazono/HanaMinB.ttf: 花園明朝B,HanaMinB:style=Regular' ]
}

@test "Haskell" {
  run -0 ghc -e 'putStrLn "シェル芸"'
  [ "$output" = "シェル芸" ]
}

@test "himechat-cli" {
  run -0 himechat-cli -V
  [ "$output" = 'https://github.com/gyozabu/himechat-cli' ]
}

@test "home-commands" {
  run -0 echo-sd シェル芸
  [ "${lines[0]}" = '＿人人人人人人＿' ]
  [ "${lines[1]}" = '＞　シェル芸　＜' ]
  [ "${lines[2]}" = '￣Y^Y^Y^Y^Y^Y^￣' ]
}

@test "horizon" {
  run -0 bash -c "echo ⁃‐﹘╸―ⲻ━= | horizon -d"
  [ "$output" = 'unko' ]
}

@test "idn" {
  run -0 idn うんこ.com
  [ "$output" = 'xn--p8j0a9n.com' ]
}

@test "ImageMagick" {
  run -0 convert -version
  [[ "${lines[0]}" =~ "Version: ImageMagick" ]]
}

@test "imgout" {
  run -0 imgout -h
  [ "$output" = 'usage: imgout [-f <font>]' ]
}

@test "ipcalc" {
  run -0 ipcalc 192.168.10.55
  [ "${lines[0]}" = 'Address:   192.168.10.55        11000000.10101000.00001010. 00110111' ]
}

@test "ivsteg" {
  run -0 ivsteg -h
  [ "${lines[0]}" = 'IVS steganography encoder or decode from standard input to standard output.' ]
}

@test "J" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "J is not installed on aarch64"; fi
  run -0 bash -c "echo \"'シェル芸'\" | jconsole"
  [ "${lines[0]}" = 'シェル芸' ]
}

@test "jq" {
  run -0 bash -c "echo シェル芸 | jq -Rr '.'"
  [ "$output" = シェル芸 ]
}

@test "julia" {
  run -0 julia -e 'println("シェル芸")'
  [ "$output" = 'シェル芸' ]
}

@test "kagome" {
  run -0 kagome <<< シェル芸
  [[ "${lines[0]}" =~ "名詞,一般,*,*,*,*,シェル,シェル,シェル" ]]
}

@test "kakasi" {
  run -0 bash -c "echo シェル芸 | nkf -e | kakasi -JH | nkf -w"
  [ "$output" = "シェルげい" ]
}

@test "kakikokera" {
  run -0 bash -c "echo 柿杮杮杮柿杮柿杮柿杮杮柿杮杮杮柿柿杮杮柿杮柿杮杮柿杮杮柿杮杮杮杮 | kakikokera -d"
  [ "$output" = 'unko' ]
}

@test "kana2ipa" {
  run -0 kana2ipa -h
  [ "${lines[0]}" = 'Usage: kana2ipa [text]' ]
}

@test "ke2daira" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "ke2daira is not installed on aarch64"; fi
  run -0 bash -c "echo シェル 芸 | ke2daira -m"
  [ "$output" = 'ゲェル シイ' ]
}

@test "kkc" {
  run -0 kkc help
  [[ "${lines[1]}" =~ "  kkc help" ]]
}

@test "kkcw" {
  run -0 kkcw <<< やまだたろう
  [ "$output" = '山田太郎' ]
}

# 不要?
@test "libskk-dev" {
  run -0 stat /usr/lib/$(uname -m)-linux-gnu/libskk.so
  [ "${lines[0]}" = "  File: /usr/lib/$(uname -m)-linux-gnu/libskk.so -> libskk.so.0.0.0" ]
}

@test "libxml2-utils" {
  run -0 bash -c "echo '<?xml version=\"1.0\"?><e>ShellGei</e>' | xmllint --xpath '/e/text()' -"
  [ "$output" = "ShellGei" ]
}

@test "lolcat" {
  run -0 lolcat --version
  [[ "${lines[0]}" =~ "lolcat" ]]
}

@test "longcat" {
  run -0 longcat -i 4 -o /a.png
  [ -f /a.png ]
}

@test "lua" {
  run -0 lua -e 'print("シェル芸")'
  [ "$output" = "シェル芸" ]
}

@test "man" {
  run -0 bash -c "man シェル芸 |& cat"
  [ "$output" = 'シェル芸 というマニュアルはありません' ]
}

@test "marky_markov" {
  run -0 marky_markov -h
  [ "${lines[0]}" = 'Usage: marky_markov COMMAND [OPTIONS]' ]
}

@test "matplotlib" {
  run -0 python3 -c 'import matplotlib; print(matplotlib.__name__)'
  [ "$output" = "matplotlib" ]
}

@test "matsuya" {
  run -0 matsuya
}

@test "maze" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "maze is not installed on aarch64"; fi
  run -0 maze -h
  run -0 maze -v
  run -0 maze
}

@test "mecab with NEologd" {
  run -0 bash -c "echo シェル芸 | mecab -Owakati"
  [ "$output" = "シェル芸 " ]
}

@test "mono-runtime" {
  run -0 mono --version
  [[ "${lines[0]}" =~ "Mono JIT compiler version" ]]
}

@test "moreutils" {
  run -0 errno 1
  [ "$output" = "EPERM 1 許可されていない操作です" ]
}

@test "morsed" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "morsed is not installed on aarch64"; fi
  run -0 bash -c "morsed -p 名詞 -s 寿司 吾輩は猫である"
  [ "$output" = "寿司は寿司である" ]
}

@test "morsegen" {
  run -0 morsegen <(echo -n shellgei)
  [ "${lines[0]}" = "... .... . .-.. .-.. --. . .." ]
}

@test "mt" {
  run -0 mt -v
  [[ "${lines[0]}" =~ "mt-st" ]]
}

@test "muscular" {
  run -0 bash -c "muscular shout ナイスバルク | grep -P -o '\p{Katakana}'|tr -d '\n'"
  [ "${lines[0]}" = 'ナイスバルク' ]
}

@test "nameko.svg" {
  run -0 file nameko.svg
  [ "$output" = 'nameko.svg: SVG Scalable Vector Graphics image' ]
}

@test "nginx" {
  run -0 nginx -v
  [[ "$output" =~ "nginx version:" ]]
}

@test "nim" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "nim is not installed on aarch64"; fi
  run -0 nim --help
  [[ "${lines[0]}" =~ 'Nim Compiler' ]]
}

@test "nise" {
  run -0 bash -c "echo 私はシェル芸を嗜みます | nise"
  [ "$output" = '我シェル芸嗜了' ]
}

@test "nkf" {
  run -0 bash -c "echo シェル芸 | nkf"
  [ "$output" = シェル芸 ]
}

@test "no-more-secrets" {
  run -0 nms -v
}

@test "noc" {
  run -0 noc --decode 部邊邊󠄓邊󠄓邉邉󠄊邊邊󠄒邊󠄓邊󠄓邉邉󠄊辺邉󠄊邊邊󠄓邊󠄓邉邉󠄎辺邉󠄎邊辺󠄀邉邉󠄈辺邉󠄍邊邊󠄓部
  [ "$output" = 'シェル芸' ]
}

@test "python is python3" {
  run -0 python --version
  [[ "$output" =~ 'Python 3' ]]
}

@test "num-utils" {
  run -0 numaverage -h
  [ "${lines[1]}" = "numaverage : A program for finding the average of numbers." ]
}

@test "numconv" {
  run -0 numconv -b 2 -B 10 <<< 101010
  [ "$output" = "42" ]
}

@test "numpy" {
  run -0 python3 -c 'import numpy; print(numpy.__name__)'
  [ "$output" = "numpy" ]
}

@test "num2words" {
  run -0 num2words 10001
  [ "$output" = "ten thousand and one" ]
}

@test "nyancat" {
  run -0 nyancat -h
  [ "${lines[0]}" = "Terminal Nyancat" ]
}

@test "ocs" {
  run -0 sh -c "seq 10 | ocs 'BEGIN{var sum=0}{sum+=int.Parse(F0)}END{Console.WriteLine(sum)}'"
  [ $output -eq 55 ]
}

@test "ojichat" {
  run -0 ojichat --version
  [[ "${lines[0]}" =~ 'Ojisan Nanchatte (ojichat) command' ]]
}

@test "onefetch" {
  run -0 bash -c "cd /ShellGeiData && onefetch | sed $'s/\033[^m]*m//g'"
  [[ "${lines[2]}" =~ 'Project: ShellGeiData' ]]
}

@test "Open usp Tukubai" {
  run -0 bash -c "echo シェル芸 | grep -o . | tateyoko -"
  [ "$output" = 'シ ェ ル 芸' ]
}

@test "openjdk" {
  run -0 javac -version
  [[ "$output" =~ "javac " ]]
}

@test "opy" {
  run -0 bash -c 'seq 2 | opy "F1%2==1"'
  [ "$output" = "1" ]
}

@test "osquery" {
  run -0 osqueryi --version
  [[ "$output" =~ 'osqueryi version ' ]]
}

@test "owari" {
  run -0 owari
  [[ "$output" =~ '糸冬' ]]
}

@test "pandoc" {
  run -0 pandoc -v
  [[ "${lines[0]}" =~ "pandoc" ]]
}

@test "parallel" {
  run -0 parallel --version
  [[ "${lines[0]}" =~ "GNU parallel" ]]
}

@test "Perl" {
  run -0 bash -c "echo シェル芸 | perl -nle 'print \$_'"
  [ "$output" = "シェル芸" ]
}

@test "php" {
  run -0 php -r 'echo "シェル芸\n";'
  [ "$output" = "シェル芸" ]
}

@test "pillow" {
  run -0 python3 -c 'import PIL; print(PIL.__name__)'
  [ "$output" = "PIL" ]
}

@test "pokemonsay" {
  run -0 pokemonsay --help
  [ "${lines[0]}" = '  Description: Pokemonsay makes a pokémon say something to you.' ]
}

@test "ponpe" {
  run -0 ponpe ponponpain haraita-i
  [ "$output" = 'pͪoͣnͬpͣoͥnͭpͣa͡iͥn' ]
}

@test "postgresql" {
  run -0 which psql
  [ "$output" = "/usr/bin/psql" ]
}

@test "PowerShell" {
  run -0 pwsh -C Write-Host シェル芸
  [ "$output" = 'シェル芸' ]
}

@test "pup" {
  run -0 pup --help
  [ "${lines[1]}" = '    pup [flags] [selectors] [optional display function]' ]
}

@test "pwgen" {
  run -1 bash -c "pwgen -h"
  [[ "$output" =~ pwgen ]]
}

@test "Python3" {
  run -0 python3 --version
  [[ "$output" =~ 'Python 3.' ]]
}

@test "qrencode" {
  run -0 qrencode -V
  [[ "${lines[0]}" =~ "qrencode version" ]]
}

@test "R" {
  run -0 bash -c "echo シェル芸 | R -q -e 'cat(readLines(\"stdin\"))'"
  [[ "$output" =~ シェル芸 ]]
}

@test "rainbow" {
  run -0 bash -c "rainbow -f ansi_f -t text"
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

@test "rargs" {
  run -0 rargs --help
  [[ "${lines[0]}" =~ "Rargs " ]]
  [ "${lines[1]}" = 'Xargs with pattern matching' ]
}

@test "rb" {
  run -0 which rb
  [ "$output" = '/usr/local/bin/rb' ]
}

@test "rect" {
  if [ "$(uname -m)" = "aarch64" ]; then skip "rect is not installed on aarch64"; fi
  run -0 rect --help
  [ "${lines[0]}" = 'rect is a command to crop/paste rectangle text' ]
}

@test "reiwa" {
  run -0 date -d '2019-05-01' '+%Ec'
  [ "$output" = '令和元年05月01日 00時00分00秒' ]
}

@test "rename" {
  run -0 rename -V
  [[ "${lines[0]}" =~ "/usr/bin/rename" ]]
}

@test "rs" {
  run -0 bash -c "echo シェル芸 | grep -o . | rs -T | tr -d ' '"
  [ "$output" = シェル芸 ]
}

@test "rsvg-convert" {
  run -0 rsvg-convert -v
  [[ "${output}" =~ 'rsvg-convert version' ]]
}

@test "rubipara" {
  run -0 rubipara kashikoma
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

@test "Ruby" {
  run -0 bash -c "echo シェル芸 | ruby -nle 'puts \$_'"
  [ "$output" = "シェル芸" ]
}

@test "saizeriya" {
  run -0 saizeriya
}

@test "sayhoozoku shoplist" {
  run -0 stat "/root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/shoplist.txt"
  [ "${lines[0]}" = '  File: /root/go/src/github.com/YuheiNakasaka/sayhuuzoku/scraping/shoplist.txt' ]
}

@test "sayhuuzoku" {
  run -0 sayhuuzoku g
}

@test "scipy" {
  run -0 python3 -c 'import scipy; print(scipy.__name__)'
  [ "$output" = "scipy" ]
}

@test "screen" {
  run -0 bash -c "screen -v"
  [[ "$output" =~ Screen ]]
}

@test "screenfetch" {
  run -0 bash -c "screenfetch -V | sed $'s/\033\[[0-9]m//g'"
  [[ "${lines[0]}" =~ "screenFetch - Version" ]]
}

@test "sel" {
  run -0 bash -c "sel --version"
  [[ "${output}" =~ "sel version" ]]
}

@test "shellgeibot-image" {
  run -0 shellgeibot-image help
  run -0 shellgeibot-image revision
  run -0 shellgeibot-image build-log
  [ "${lines[0]}" = '"build_num","vcs_revision","start_time","stop_time"' ]
  [[ "${lines[1]}" =~ ^.[0-9]+.,.*$ ]]
  [[ "${lines[2]}" =~ ^.[0-9]+.,.*$ ]]
  [[ "${lines[3]}" =~ ^.[0-9]+.,.*$ ]]
}

@test "ShellGeiData" {
  run -0 stat /ShellGeiData/README.md
  [ "${lines[0]}" = '  File: /ShellGeiData/README.md' ]
}

@test "sl" {
  run -0 which sl
  [ "$output" = /usr/games/sl ]
}

@test "snacknomama" {
  run -0 snacknomama
}

@test "super unko" {
  run -0 unko.tower 2
  [ "${lines[0]}" = '　　　　人' ]
  [ "${lines[1]}" = '　　（　　　）' ]
  [ "${lines[2]}" = '　（　　　　　）' ]
}

@test "surge" {
  run -0 surge --version
  [[ "$output" =~ "surge" ]]
}

@test "sushiro" {
  run -0 sushiro -l
  [[ ! "${output}" =~ '/usr/local/share/sushiro_cache' ]]
}

@test "sympy" {
  run -0 python3 -c 'import sympy; print(sympy.__name__)'
  [ "$output" = "sympy" ]
}

@test "taishoku" {
  run -0 taishoku
  [ "${lines[0]}" = '　　　代株　　　　二退こ　　　　　　' ]
}

@test "takarabako" {
  run -0 takarabako
}

@test "tate" {
  run -0 tate
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

@test "tcsh" {
  run -0 tcsh -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "teip" {
  run -0 teip -f2 -- sed 's/.*/芸/' <<< "シェル ゲイ"
  [ "$output" = "シェル 芸" ]
}

@test "telnet" {
  run -0 telnet --help
  [ "${lines[0]}" = "Usage: telnet [OPTION...] [HOST [PORT]]" ]
}

@test "terminal-parrot" {
  run -0 terminal-parrot -h
  [ "${lines[0]}" == 'Usage of terminal-parrot:' ]
}

@test "textchat" {
  run -0 bash -c "textchat -n bob hello"
  [ "${lines[0]}" == ".-----.  .---------.                                                            " ]
  [ "${lines[1]}" == "| bob | <   hello  |                                                            " ]
  [ "${lines[2]}" == "\`-----'  \`---------'                                                            " ]
}

@test "textimg" {
  run -0 textimg --version
  [[ "$output" =~ "textimg version " ]]
}

@test "TiMidity++" {
  run -0 bash -c "timidity -v"
  [[ "$output" =~ TiMidity\+\+ ]]
}

@test "tmux" {
  run -0 tmux -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "toilet" {
  run -0 bash -c "echo シェル芸 | toilet"
  [ "${lines[0]}" = '                                          ' ]
  [ "${lines[1]}" = '   ""m                        m  "m       ' ]
  [ "${lines[2]}" = '  mm                           #  #       ' ]
  [ "${lines[3]}" = '    "    m"      mmm""         #  #   #   ' ]
  [ "${lines[4]}" = '       m"          #mm        m"  # m"    ' ]
  [ "${lines[5]}" = '  "mm""         """"  "      m"   #"      ' ]
  [ "${lines[6]}" = '                                          ' ]
  [ "${lines[7]}" = '                                          ' ]
}

@test "torikizoku" {
  run -0 torikizoku -h
  [[ "${lines[0]}" =~ 'Usage: torikizoku' ]]
}

@test "trdsql" {
  run -0 sh -c "trdsql --version | xxd"
  [[ "$output" =~ "trdsql version" ]]
}

@test "tree" {
  run -0 tree --help
  [[ "${lines[0]}" =~ 'usage: tree' ]]
}

@test "ttyrec" {
  run -1 bash -c "ttyrec -h"
  [[ "$output" =~ ttyrec ]]
}

@test "ttyrec2gif" {
  run -0 ttyrec2gif -help
  [ "${lines[0]}" = 'Usage of ttyrec2gif:' ]
}

@test "uconv" {
  run -0 bash -c "echo 30b730a730eb82b8 | xxd -p -r | uconv -f utf-16be -t utf-8"
  [ "$output" = "シェル芸" ]
}

@test "unicode-data" {
  run -0 stat /usr/share/unicode/ReadMe.txt
  [ "${lines[0]}" = "  File: /usr/share/unicode/ReadMe.txt" ]
}

@test "uniname" {
  run -2 uniname -h 2>&1
  [ "${lines[0]}" = "Name the characters in a Unicode file." ]
}

@test "Vim" {
  run -0 bash -c "echo シェル芸 | vim -es +%p +q! /dev/stdin"
  [ "$output" = シェル芸 ]
}

@test "w3m" {
  run -0 w3m -version
  [[ "$output" =~ 'w3m version' ]]
}

@test "whiptail" {
  run -0 whiptail -v
  [[ "$output" =~ "whiptail" ]]
}

@test "whitespace" {
  run -0 bash -c "echo -e '   \t \t  \t\t\n\t\n     \t\t \t   \n\t\n     \t\t  \t \t\n\t\n     \t\t \t\t  \n\t\n     \t\t \t\t  \n\t\n     \t   \t\t\t\n\t\n     \t\t  \t \t\n\t\n     \t\t \t  \t\n\t\n  \n\n' | whitespace"
  [ "$output" = 'ShellGei' ]
}

@test "wordcloud_cli" {
  run -0 wordcloud_cli --version
  [[ "$output" =~ "wordcloud_cli" ]]
}

@test "x11-apps" {
  run -0 which xwd
  [ "$output" = '/usr/bin/xwd' ]
}

@test "xdotool" {
  run -0 xdotool --version
  [[ "$output" =~ 'xdotool version' ]]
}

@test "xonsh" {
  run -0 xonsh -c 'echo シェル芸'
  [ "$output" = "シェル芸" ]
}

@test "xterm" {
  run -0 xterm -v
  [[ "$output" =~ 'XTerm' ]]
}

@test "xvfb" {
  run -0 Xvfb -help
  [ "${lines[0]}" = 'use: X [:<display>] [option]' ]
}

@test "yash" {
  run -0 yash -c "echo シェル芸"
  [ "$output" = シェル芸 ]
}

@test "yq" {
  run -0 yq --version
  [[ "${lines[0]}" =~ "yq" ]]
}

@test "yukichant" {
  run -0 bash -c "echo -n unko | chant | chant -d"
  [ "$output" = "unko" ]
}

@test "zen_to_i" {
  run -0 bash -c 'ruby -rzen_to_i -pe \$_=\$_.zen_to_i <<< 三十二'
  [ "${lines[0]}" = '32' ]
}

@test "zsh" {
  run -0 zsh -c "echo シェル芸"
  [ "$output" = "シェル芸" ]
}

@test "zws" {
  run -0 bash -c "echo J+KBouKAjeKAi+KBouKAjeKAi+KAi+KAjeKAjeKBouKAjOKBouKBouKAjeKAi+KBouKAjeKAi+KAi+KAjeKAjeKAjeKAjOKBouKBouKAjeKAi+KBouKAjeKAi+KAi+KBouKAjeKAjeKAjeKBouKBouKAjeKAjeKAi+KAjeKAi+KAjeKAjeKAjeKBouKAjeKAi+KAi+KAi+KAjeKAjScK | base64 -d | zws -d"
  [ "$output" = 'シェル芸' ]
}
