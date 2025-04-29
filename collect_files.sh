#!/bin/bash
max_depth=-1 #парсинг параметров
source_dir=""
target_dir=""
if [[ "$1" == "--max_depth" ]];then #обработка глубины
    if [[ $# -ne 4 || ! "$2" =~ ^[0-9]+$ ]];then
        exit 1
    fi
    max_depth="$2"
    source_dir="$3"
    target_dir="$4"
else
    if [[ $# -ne 2 ]];then
        exit 1
    fi
    source_dir="$1"
    target_dir="$2"
fi
#проверка директорий
[[ -d "$source_dir" ]] || exit 1
mkdir -p "$target_dir" || exit 1
process_file(){ #функция обработки
    local file_path="$1"
    local filename=$(basename -- "$file_path")
    local base="${filename%.*}"
    local ext="${filename##*.}"
    if [[ "$base" == "$filename" ]]; then
        ext=""
    else
        ext=".$ext"
    fi
    local target="$target_dir/$base$ext"
    local counter=1
    while [[ -e "$target" ]]; do #разрешение конфликтов имен
        if [[ -z "$ext" ]]; then
            target="$target_dir/${base}_$counter"
        else
            target="$target_dir/${base}_$counter$ext"
        fi
        ((counter++))
    done

    cp -- "$file_path" "$target" 2>/dev/null
}

if (( max_depth >= 0 )); then #Обход файлов
    find "$source_dir" -type f -mindepth 1 -maxdepth "$max_depth" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        process_file "$file"
    done
else
    find "$source_dir" -type f -print0 2>/dev/null | while IFS= read -r -d '' file; do #полная глубина
        process_file "$file"
    done
fi

exit 0