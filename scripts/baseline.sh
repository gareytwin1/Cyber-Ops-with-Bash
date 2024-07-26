#!/usr/bin/env bash
#
# baseline.sh
#
# Description:
# Creates a file system baseline or compares current
# file system to previous baseline
#
# Usage: ./baseline.sh [-d path] <file1> [<file2>]
# [<file 2>] Previous baseline file to compare
#

function usageErr(){
    echo 'Usage: baseline.sh [-d path] <file1> [<file2>]'
    echo 'Creates or compares a baseline from path'
    echo 'default for path is / or otherwise specified'
    exit 2
} >&2

function dosumming(){
    find "${DIR[@]}" -type f 2>/dev/null | xargs -d '\n' sha1sum
} >&2

# ==================================
# Main

# Capture the start time
START_TIME=$(date +%s)


declare -a DIR

# ------------ parse the arguments

while getopts "d:" MYOPT; do
    # no check for MYOPT since there is only one choice
    DIR+=( "$OPTARG" )
done
shift $((OPTIND-1))

# no arguments? too many?
(( $# == 0 || $# > 2)) && usageErr

# if no directory specified, use root
(( ${#DIR[*]} == 0 )) && DIR=( "/" )

# create either a baseline (only 1 filename provided)
# or a secondary summary (when two filenames are provided)

BASE="$1"
B2ND="$2"

# IF only 1 file is provided, check if the file exist and prompt the
# user to overwrite it if it does
if (( $# == 1 )); then
    if [[ -e "$BASE" ]]; then
        read -p "The file $BASE already exists. Do you want to overwrite it? (y/n): " answer
        if [[ $answer == "y" ]]; then
            dosumming > "$BASE"
            echo "Baseline file $BASE created."
        else
            echo "Operation cancelled. Exiting..."
            exit 0
        fi
    else
        dosumming > "$BASE"
        echo "Baseline file $BASE created."
    fi
    exit
fi

if (( $# == 1)); then     # only 1 arg
    # creating "$BASE"
    dosumming > "$BASE"
    # all done for baseline
    exit
fi

if [[ ! -r "$BASE" ]]; then
    usageErr
fi

# ------------- on to the actual work

# if 2nd file exists just compare the two
# else create/fill it
if [[ ! -e "$B2ND" ]]; then
    echo Creating "$B2ND"
    dosumming > "$B2ND"
fi

# now we have: 2 files created by sha1sum
declare -A BYPATH BYHASH INUSE # assoc. arrays

# load up the first file as the baseline
while read HNUM FN; do
    BYPATH["$FN"]=$HNUM
    BYHASH[$HNUM]="$FN"
    INUSE["$FN"]="X"
done < "$BASE"

# ------ now begin the output
# see if each filename listed in the 2nd file is in 
# the sample place (path) as in 1st (the baseline)

printf '<filesystem host="%s" dir="%s">\n' "$(hostname)" "${DIR[*]}"

while read HNUM FN; do
    WASHASH="${BYPATH[${FN}]}"
    # did it find one? if not, it will be null
    if [[ -z $WASHASH ]]; then # new file
        ALTFN="${BYHASH[$HNUM]}"
        if [[ -z $ALTFN ]]; then # new file
            printf '    <new>%s</new>\n' "$FN"
        else    # relocated
            printf '    <relocated orig="%s">%s</relocated>\n' "$ALTFN" "$FN"
            INUSE["$ALTFN"]='_' # mark this as seen
        fi
    else
        INUSE["$FN"]='_'    # mark this as seen, file exists in baseline
        if [[ $HNUM == $WASHASH ]]; then    # no change
            continue;       # nothing changed
        else    # changed
            printf '    <changed>%s</changed>\n' "$FN"
        fi # end of hash comparison
    fi # end of file comparison
done < "$B2ND"

for FN in "${!INUSE[@]}"; do
    if [[ "${INUSE[$FN]}" == 'X' ]]; then
        printf '    <removed>%s</removed>\n' "$FN"
    fi
done
printf '</filesystem>\n'

# Capture the end time
END_TIME=$(date +%s)

# Calculate the elapsed time
DURATION=$((END_TIME - START_TIME))

echo "Elapsed time: $DURATION seconds"