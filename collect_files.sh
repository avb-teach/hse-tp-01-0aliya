#!/bin/bash
max_depth=-1 #парсинг параметров
src=""
dest=""
if [[ "$1" == "--max_depth" ]]; then #обработка глубины
    if [[ $# -ne 4 || ! "$2" =~ ^[0-9]+$ ]]; then
        exit 1
    fi
    max_depth="$2"
    src="$3"
    dest="$4"
else
    if [[ $# -ne 2 ]]; then
        exit 1
    fi
    src="$1"
    dest="$2"
fi
#проверка директорий
[[ -d "$src" ]] || exit 1
mkdir -p "$dest" || exit 1

process_file(){ #функция обработки
    local file="$1"
    local filename=$(basename -- "$file")
    local base="${filename%.*}"
    local ext="${filename##*.}"
    if [[ "$base" == "$filename" ]]; then #обработка файлов без расширения
        ext=""
    else
        ext=".$ext"
    fi
    local target="$dest/$base$ext"
    local counter=1
    while [[ -e "$target"]];do #разрешение конфликтов имен
        if [[ -z "$ext"]]; then
            target="$dest/${base}_$counter"
        else
            target="$dest/${base}_$counter$ext"
        fi
        ((counter++))
    done
    cp -- "$file" "$target" 2>/dev/null
}
if (( max_depth>=0 ));then #Обход файлов
    find "$src" -type f -mindepth 1 -maxdepth $((max_depth + 1)) -print0 2>/dev/null | while IFS= read -r -d '' file;do #ограниченная глубина
        process_file "$file"
    done
else
    find "$src" -type f -print0 2>/dev/null | while IFS= read -r -d '' file;do #полная глубина
        process_file "$file"
    done
fi

exit 0