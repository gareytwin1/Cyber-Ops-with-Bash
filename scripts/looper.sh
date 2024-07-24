#!/usr/bin/env bash
#
# looper.sh
#
# Description:
# Count the lines in a file being tailed -f
# Report the count interval on every SIGUSR1
#
# Usage: ./looper.sh [filename]
#   filename of file to be tailed, default: log.file
#

interval(){
    echo $(date '+%y%m%d %H%M%S') $cnt
    cnt=0
}


declare -i cnt=0
trap interval SIGUSR1

log_file=${1:-log.file}
if [[ ! -f "$log_file" ]]; then
    echo "Error: Log file '$log_file' does not exist."
    exit 1
    fi

# Enable lastpipe option
shopt -s lastpipe

tail -f --pid=$$ ${1:-log.file} | while read -r aline; do
    let cnt++
done

