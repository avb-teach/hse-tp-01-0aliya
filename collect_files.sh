#!/bin/bash
input_dir="$1"
output_dir="$2"
mkdir -p "$output_dir"
function copy_files(){
    find "$input_dir" -maxdepth 1 -type f -exec cp {} "$output_dir/" \;
    find "$input_dir" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
        find "$subdir" -maxdepth 1 -type f -exec cp {} "$output_dir/" \;
    done
}