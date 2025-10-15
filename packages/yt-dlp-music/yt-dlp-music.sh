#!/usr/bin/env bash

REQUIRED_ARGS=(
    --audio-format --audio-quality --extract-audio --embed-thumbnail --convert-thumbnails
    --exec --parse-metadata --replace-in-metadata --add-metadata -o
)

YT_DLP_HELP=$(yt-dlp --help)

for ARG in "${REQUIRED_ARGS[@]}"; do
    if ! echo "$YT_DLP_HELP" | grep -q -- "$ARG"; then
        echo -e "\033[33mwarning: yt-dlp does not have a '$ARG' argument\033[0m" >&2
    fi
done

TEMP=$(mktemp -d /tmp/yt-dlp-music-XXXXXX)

yt-dlp \
    --audio-format opus \
    --audio-quality 0 \
    --extract-audio \
    --embed-thumbnail \
    --convert-thumbnails jpg \
    --exec "before_dl: \
        ffmpeg \
            -i \"%(thumbnails.-1.filepath)s\" \
            -vf crop=\"'if(gt(ih,iw),iw,ih):if(gt(iw,ih),ih,iw)'\" \
            -vframes 1 \
            -nostats \
            -loglevel 0 \
            \"%(thumbnails.-1.filepath.:-4)s_cropped.jpg\" \
    " \
    --exec "before_dl: \
        mv \"%(thumbnails.-1.filepath.:-4)s_cropped.jpg\" \"%(thumbnails.-1.filepath)s\"
    " \
    --parse-metadata ":(?P<webpage_url>)(?P<meta_synopsis>)(?P<description>)(?P<meta_duration>)(?P<album_artists>)" \
    --parse-metadata "%(release_date>%Y-%m-%d)s:%(meta_date)s" \
    --parse-metadata "%(artists.0,artist)s:%(meta_artist)s" \
    --parse-metadata "%(artist)s:%(meta_artists)s" \
    --parse-metadata "%(track,title)s:%(meta_title)s" \
    --replace-in-metadata "meta_title" "\s+\(feat\.\s.+\)" "" \
    --parse-metadata "%(album|)s<SEP>%(title)s<SEP2>%(playlist_index)d:%(meta_album)s" \
    --replace-in-metadata "meta_album" "(?:^(.+)<SEP>\1<SEP2>NA$)|(?:^(.*)<SEP>.*$)" "\g<2>" \
    --parse-metadata "%(playlist_index)d<SEP3>%(meta_album)s:%(album_folder)s" \
    --replace-in-metadata "album_folder" "(?:^\d+<SEP3>(.*)$)|(?:NA<SEP3>(.*)$)" "\g<1>" \
    --replace-in-metadata "meta_album" "^$" "Singles" \
    --parse-metadata "%(playlist_index)02d :%(filename_prefix)s" \
    --replace-in-metadata "filename_prefix" "^NA $" "" \
    --add-metadata \
    -o "$TEMP/%(meta_artist|Other)s/%(album_folder|)s%(filename_prefix|)s%(meta_title)s.%(ext)s" \
    "$@"

find "$TEMP" -type f -name '*.opus' | while read -r file; do
    mv "$file" "${file%.opus}.ogg"
done

rsync -a --ignore-existing --info=SKIP "$TEMP/" "$XDG_MUSIC_DIR/" |
    sed "s/^\(.*\) exists$/\x1b[33mwarning: skipping '\1' (already exists)\x1b[0m/"

rm -rf "$TEMP"
