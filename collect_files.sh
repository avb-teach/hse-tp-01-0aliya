#!/bin/bash
max_depth=-1 #парсинг параметров
source_dir=""
target_dir=""
if [[ "$1" == "--max_depth" ]]; then #обработка глубины
    if [[ $# -ne 4 || ! "$2" =~ ^[0-9]+$ ]]; then
        exit 1
    fi
    max_depth="$2"
    source_dir="$3"
    target_dir="$4"
else
    if [[ $# -ne 2 ]]; then
        exit 1
    fi
    source_dir="$1"
    target_dir="$2"
fi
#проверка директорий
if [[ ! -d "$source_dir" ]]; then
    exit 1
fi
mkdir -p "$target_dir" || exit 1
process_file(){ #функция обработки
    local file_path="$1"
    local filename=$(basename -- "$file_path")
    local name_without_ext="${filename%.*}"
    local extension="${filename##*.}"
    if [[ "$name_without_ext" == "$filename" ]];then
        extension=""
    else
        extension=".$extension"
    fi
    local target_file="$target_dir/$name_without_ext$extension"
    local counter=1
    while [[ -e "$target_file" ]];do #разрешение конфликтов имен
        if [[ -z "$extension" ]];then
            target_file="$target_dir/${name_without_ext}_$counter"
        else
            target_file="$target_dir/${name_without_ext}_$counter$extension"
        fi
        ((counter++))
    done
    cp -- "$file_path" "$target_file" 2>/dev/null
}
if (( max_depth >= 0 )); then #Обход файлов
    while IFS= read -r -d '' file; do
        process_file "$file"
    done < <(find "$source_dir" -type f -mindepth 1 -maxdepth $((max_depth + 1)) -print0 2>/dev/null)
else
    while IFS= read -r -d '' file; do #полная глубина
        process_file "$file"
    done < <(find "$source_dir" -type f -print0 2>/dev/null)
fi

exit 0