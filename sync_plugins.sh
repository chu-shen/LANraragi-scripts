#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/chu-shen/LANraragi/feat-ratingAndcomment/lib/LANraragi/Plugin/"

TARGET_FILES=(
    "Metadata/Comment.pm"
    "Metadata/Rating.pm"
    "Metadata/TranslateTitleByAI.pm"
    "Scripts/addEhentaiMetadata.pm"
    "Scripts/DuplicateFinder.pm"
)

LOCAL_PATH="plugins"

for file in "${TARGET_FILES[@]}"; do
    remote_file_url="${BASE_URL}${file}"
    local_file_path="${LOCAL_PATH}/${file}"

    mkdir -p "$(dirname "${local_file_path}")"
    
    if ! curl -fsSL "${remote_file_url}" -o "${local_file_path}"; then
      echo "failed to download: ${remote_file_url}"
      exit 1
    fi
done