#!/bin/bash

# Songs exporter
# version:
se_version="0.0.1"

# -----------------
# OPTIONS:

# tag files (default=true)
# ^ will overwrite files' existing tags (artist name, title, etc.) with osu!'s;
# recommended since osu!'s tags are usually more consistent
tag=true

# allow for Unicode tags (default=false)  <---------------- WIP
# ^ enable if you know Japanese KEKW
useUnicode=false

# -----------------
# FUNCTIONS:
# TODO .osu metadata/tags extractor

# -----------------
# MAIN BODY OF THE SCRIPT:

# help and version
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage:
$0 <beatmaps-dir> <output-dir>"
    exit 0
elif [ "$1" == "--version" ] || [ "$1" == "-v" ]; then
    echo "Songs-Exporter v${se_version}"
    exit 0
fi

# search through every mapset in the directory
for mapset in "$1"/*; do

    # for every file in a mapset check if it's a beatmap file
    for file in "${mapset}"/*; do
        if [[ "${file}" == *".osu" ]]; then

            # in the beatmap file find the name of the corresponding songfile

            # STARTING SPACE HANDLING <---------------------------------- TODO (usually with space; hardcoded for now)
            songfile=$(sed 's/AudioFilename: //;t;d' "${file}")
#            # non-sed equivalent for reference, in case I want to use it instead
#            while read -r line; do
#                if [[ "${line}" == "AudioFilename: "* ]]; then
#                    songfile="${line#"AudioFilename: "}"
#                    break
#                fi
#            done < "${file}"

            # remove Windows's carriage return symbol to make cp work 😮‍💨;
            # this is a Bash script, not a CMD script
            songfile=${songfile//$(echo -e "\r")/}

            # path to the final exported song file
            outputfile="$2${mapset#"$1"}.${songfile#*.}"

#            # DEBUG
#            echo "Dir path:                      $1"
#            echo "Map path:                      ${mapset}"
#            # ^ might contain double slashes, depending on $1
#            echo "Songfile:                      ${songfile}"
#            echo "Extension:                     ${songfile#*.}"
#            echo "Map name (with leading slash): ${mapset#"$1"}"
#            echo "Target dir:                    $2"
#            echo "Output file:                   ${outputfile}"
#            # ^ might contain double slashes, depending on $2
#            echo ""


            # copy the song file to the target directory, renamed appropriately.
            cp "${mapset}/${songfile}" "${outputfile}"


#            # songfile tagging: <---------------- WIP
#            if [ "${tag}" == true ]; then
#
#                # in the beatmap file find the author and title of the song...
#                # STARTING SPACE HANDLING <---------------------------------- TODO (usually no space; hardcoded for now)
#                title=$(sed 's/Title://;t;d' "${file}")
#                artist=$(sed 's/Artist://;t;d' "${file}")
#
#                # Unicode version check
#                titleUnicode=
#                artistUnicode=
#                if [ "${useUnicode}" == true ]; then
#                    titleUnicode=$(sed 's/TitleUnicode://;t;d' "${file}")
#                    artistUnicode=$(sed 's/ArtistUnicode://;t;d' "${file}")
#
#                    if [ -n "${titleUnicode}" ]; then
#                        title="${titleUnicode}"
#                    fi
#                    if [ -n "${artistUnicode}" ]; then
#                        artist="${artistUnicode}"
#                    fi
#                fi
#
#
#                # ...and set these as tags for the output song file, using mid3v2 <---------------- TODO
#                echo "Title:  ${title}"
#
#
#                echo "Artist: ${artist}"
#            fi

            # currently only handles a single song per mapset <---------------- TODO
            break

        fi
    done

done
