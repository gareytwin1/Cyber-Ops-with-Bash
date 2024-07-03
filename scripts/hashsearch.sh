#!/usr/bin/env bash
#
# hashsearch
#
# Description:
# Recursively search a given directory for a file that 
# matches a given SHA-1 hash
#
# Usage:
# hashsearch <hash> <directory>
#   hash - SHA-1 hash value to file to find
#   directory - Top directory to start search
#

HASH=$1
DIR=${2:-.}     # default is here, cwd

# convert pathname into an absolute path
mkabspath(){
    if [[ $1 == /* ]]; then
        ABS=$1
    else
        ABS="$PWD/$1"
    fi
}

find $DIR -type f | while read fn; do
    THISONE=$(sha1sum "$fn")
    THISONE=${THISONE%% *}
    if [[ $THISONE == $HASH ]]; then
        mkabspath "$fn"
        echo $ABS
    fi
done
