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

mismatch(){
    local -i i
    for((i=0; i<$KNSIZE; i++)); do
        [[ "$1" =~ .*${KNOWN[$i]}.* ]] && return 1
    done
    return 0
}

usage(){
    echo "Usage: $0 [-u] <useragent file> [-f] <access log file>" >&2
    exit 1;
}

while getopts u:f: opt; do
    case $opt in
        u)
            known_agents=$OPTARG
            ;;

        f)  file=$OPTARG
           ;;

        *)  
           usage ;;
    esac
done
shift=$((OPTIND -1))

if ! [ -f $file ]; then
    echo "File not found: ${file}. Try using access.log" >&2
    usage
fi

if [ ! -f $known_agents ]; then
    echo "Know agents file not found: $known_agents. Try using useragents.txt" >&2
    usage
fi

readarray -t KNOWN < "$known_agents"


KNSIZE=${#KNOWN[@]}

awk -F'"' '{print $1, $6}' $file | while read ipaddr dash1 dash2 dtstamp delta useragent; do
    if mismatch "$useragent"; then
        echo "${RED}Anomaly: $ipaddr $useragent${NORMAL}" 
    fi
done 

