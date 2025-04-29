#!/bin/bash
d=-1
i=""
o=""
if [["$1"=="--md" ]];then
    (( $#!=4))&& exit 1
    [["$2"=~^[0-9]+$]] || exit 1
    d="$2"
    i="$3"
    o="$4"
else
    (($#!=2)) && exit 1
    i="$1"
    o="$2"
fi
[[-d"$i"]] || exit 1
mkdir -p "$o" 2>/dev/null
fargs=("$i"-type f)
((d!=-1)) && fargs+=(-mindepth 1 -maxdepth $((d+1)))
while IFS= read -r -d '' fp; do
    bn=$(basename -- "$fp")
    n="${bn%.*}"
    x="${bn##*.}"
    [[ "$n"=="$bn" ]] && x="" || x=".$x"
    t="$o/$n$x"
    cnt=1
    while [[-e"$t"]]; do
        t="$o/${n}_$((cnt++))$x"
    done
    cp -- "$fp" "$t" 2>/dev/null
done < <(find "${fargs[@]}" -print0 2>/dev/null)