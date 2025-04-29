#!/bin/bash
max_depth=-1
src=""
dest=""
if [[ "$1" == "--max_depth" ]];then
    if [[ $# -ne 4 || ! "$2" =~ ^[0-9]+$ ]];then
        exit 1
    fi
    max_depth=$2
    src=$3
    dest=$4
else
    if [[ $# -ne 2 ]];then
        exit 1
    fi
    src=$1
    dest=$2
fi

[[ -d "$src" ]] || exit 1
mkdir -p "$dest" 2>/dev/null || exit 1
process_file() {
    local full_path="$1"
    local filename=$(basename -- "$full_path")
    local base="${filename%.*}"
    local ext="${filename##*.}"
    [[ "$base"=="$filename" ]] && ext="" || ext=".$ext"
    local counter=1
    local target="${dest}/${base}${ext}"
    while [[ -e "${target}" ]]; do
        target="${dest}/${base}_${counter}${ext}"
        ((counter++))
    done
    cp -- "$full_path" "$target" 2>/dev/null
}
if (( max_depth >= 0 ));then
    depth=$((max_depth + 1))
    find "$src" -type f -mindepth 1 -maxdepth "$depth" -print0 2>/dev/null | while IFS= read -r -d '' file;do
        process_file "$file"
    done
else
    find "$src" -type f -print0 2>/dev/null | while IFS= read -r -d '' file;do
        process_file "$file"
    done
fi