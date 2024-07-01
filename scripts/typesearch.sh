#!/bin/bash -
#
# Description:
# Search the file system for a given file type. It prints out the 
# pathname when found
#
# Usage:
# typesearch.sh [-c dir] [-i] [-R|r] <pattern> <path>
#   -c Copy files found to dir
#   -i Ignore case
#   -R|r Recursively search subdirectories
#   <pattern> File type pattern to search for
#   <path> Path to start search
#

DEEPORNOT="-maxdepth 1"             # just the current dir; default

# Parse options arguments
while getopts 'c:irR' opt; do
    case "${opt}" in
        c)  # copy found files to specified directory
            COPY=YES
            DESTDIR="$OPTARG"
            ;;
        i)  # ignore u/l case differences in search
            CASEMATCH='-i'
            ;;
        [Rr])   # recursive
                unset DEEPORNOT ;;
        *)  # unknown/unsupported option
            # error mesg will come from getopts, so just exit
            exit 2 ;;
    esac
done
shift "$((OPTIND - 1))"

PATTERN=${1:-PDF document}

STARTDIR=${2:-.}    # by default start here

find $STARTDIR $DEEPORNOT -type f | while read FN
do
    file $FN | egrep -q $CASEMATCH "$PATTERN"
    if (( $? == 0 )) # found one
    then
        echo $FN
        if [[ $COPY ]]
        then
            cp -p $FN $DESTDIR
        fi
    fi
done
