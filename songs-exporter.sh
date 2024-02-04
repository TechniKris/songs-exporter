#!/bin/bash

# -----------------
# OPTIONS:

# -----------------
# FUNCTIONS:

# -----------------
# HELP
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage:
$0 <beatmaps-dir> <output-dir>"
    exit 0
fi

# -----------------
# MAIN BODY OF THE SCRIPT:

# search through every mapset in the directory
for mapset in "$1"/*; do

    # for every file in a mapset check if it's a beatmap file
    for file in "${mapset}"/*; do
        if [[ "${file}" == *".osu" ]]; then

            # in the beatmap file find the name of the corresponding songfile
            while read -r line; do
                if [[ "${line}" == "AudioFilename:"* ]]; then
                    songfile="${line#"AudioFilename:"}"
                    
                    # in case there was a space at the start (there usually is)
                    if [[ "${songfile}" == " "* ]]; then
                        songfile="${songfile#" "}"
                    fi
                    break
                fi
            done < "${file}"

            # remove Windows's carriage return symbol to make cp work 😮‍💨;
            # this is a Bash script, not a CMD script
            songfile=${songfile//$(echo -e "\r")/}

            # path to the final exported song file
            outputfile="$2${mapset#"$1"}.${songfile#*.}"


            # copy the song file to the target directory, renamed appropriately.
            cp "${mapset}/${songfile}" "${outputfile}"


            # currently only handles a single song per mapset <----- TODO
            break

        fi
    done

done
