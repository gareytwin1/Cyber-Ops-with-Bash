#!/usr/bin/env bash
#
# tailcount.sh
# 
# Description:
# Count lines every n seconds
#
# Usage: ./tailcount.sh [filename]
#   filename: passed to looper.sh
#

function usage(){
    echo "Usage: $0 [-i seconds] <input file>"
    echo "  -i seconds: Integer representing the amount of seconds to sleep."
}

# cleanup - the other processes on exit
function cleanup(){
    [[ -n $LOPID ]] && kill $LOPID
}

# Start looper.sh in the background
trap cleanup EXIT

while getopts 'i:'; do
    case $opts in
        i)
            numsecs=$OPTARG
            if ! [[ "$numsecs" =~ ^[0-9]+$ ]] || [ "$numsecs" -lt 1 ]; then
                echo "Error: -i option requires integer greater than 1"
                usage
            ;;
        *)
            usage
            ;;
    esac
done

bash looper.sh $1 &
LOPID=$!

# give it a chance to start up
sleep 3

# Send SIGUSR1 signal to looper.sh every 5 seconds
while true; do
    kill -SIGUSR1 $LOPID
    sleep $numsecs
done >&2
