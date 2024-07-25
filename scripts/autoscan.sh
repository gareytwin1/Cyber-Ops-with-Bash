#!/usr/bin/env bash
#
# autoscan.sh
# Description: 
# Automatically performs a port scan (using scan.sh)
# Compares output to previous results, and emails user
# Assumes that scan.sh and fd2.sh is in the current direcotry
#

./scan.sh < hostlist

FILELIST=$(ls scan_* | tail -2)
FILES=( $FILELIST )

TMPFILE=$(tempfile)

./fd2.sh ${FILE[0]} ${FILE[1]} > $TMPFILE

if [[ -s $TMPFILE ]]; then # Non-empty
    echo "Mailing today's port differences to ${USER}"
    mail -s "Today's port differences" $USER < $TMPFILE
fi

# clean up
rm -f $TMPFILE
