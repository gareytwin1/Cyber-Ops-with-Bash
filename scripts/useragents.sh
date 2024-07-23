#!/usr/bin/env bash
# 
# Description:
# Read through a log looking for unknow user agents
# 
# Usage: ./useragents.sh < inputfile 
# <inputfile> Apache access log

# mismatch search through the array of known names
# returns 1 (false) if it finds a match
# returns 0 (true) if there is no match

function mismatch(){
    local -i i
    for((i=0; i<$KNSIZE; i++)); do
        [[ "$1" =~ .*${KNOWN[$i]}.* ]] && return 1
    done
    return 0
}

usage(){
    echo "Usage: $0 [-f] <input file>" >&2
    return 1;
}

while getopts f: opt; do
    case $opt in
        f)
            if ! [-f $OPTARG]; then
                usage 
            fi 
            readarray -t KNOWN < $OPTARG ;;
       \?)  
           usage ;;
    esac
done
shift = $((OPTIND -1))

if [ $# -lt 2 ]; then
    readarray -t KNOWN < "$HOME/Projects/Practice/bash_scripts/files/useragents.txt"
fi

KNSIZE=${#KNOWN[@]}
for item in "${KNOWN[@]}"; do
    echo "$item"
done

# preprocess logfile (stdin) to pick out ipaddr and user agents
awk -F'"' '{print $1, $6}' |\
while read ipaddr dash1 dash2 dtstamp delta useragent; do
    if mismatch "$useragent"; then
        echo "${RED}anomaly: $ipaddr $useragent${NORMAL}" 
    fi
done
