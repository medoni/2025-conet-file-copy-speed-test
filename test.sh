#!/bin/bash

source_file_remote="https://github.com/torvalds/linux/archive/refs/heads/master.zip"
source_file="${BASH_SOURCE%/*}/source.zip"
source_folder="${BASH_SOURCE%/*}/source"
tmp_folder="${BASH_SOURCE%/*}/tmp"

main() {
    get_source
    # test_dockerfile
    test_copy_files
}

get_source() {
    if [ -d "$source_folder" ]; then
        return
    fi
    mkdir -p "$source_folder"

    if [ ! -f "$source_file" ]; then
        curl -L "$source_file_remote" -o "$source_file"
        unzip "$source_file" -d "$source_folder"
    fi
}

test_dockerfile() {
    docker build --no-cache -f "${BASH_SOURCE%/*}/test.Dockerfile" "${BASH_SOURCE%/*}"
}

test_copy_files() {
    target_dir="$tmp_folder/$(uuidgen)"
    mkdir -p "$target_dir"

    echo "test copying files ..."
    time cp -r "$source_folder" "$target_dir"

    echo "$(find $target_dir | wc -l) files copied."
}

main