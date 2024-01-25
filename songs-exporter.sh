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

# -----------------
# MAIN BODY OF THE SCRIPT:

# search through every mapset in the directory
for mapset in "$1"/*; do

    # for every file in a mapset check if it's a beatmap file
    for file in "${mapset}"/*; do
        if [[ "${file}" == *".osu" ]]; then

            # in the beatmap file find the name of the corresponding songfile

            # STARTING SPACE HANDLING <----- TODO (usually with space; hardcoded for now)
            while read -r line; do
                if [[ "${line}" == "AudioFilename: "* ]]; then
                    songfile="${line#"AudioFilename: "}"
                    break
                fi
            done < "${file}"

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


            # currently only handles a single song per mapset <----- TODO
            break

        fi
    done

done
