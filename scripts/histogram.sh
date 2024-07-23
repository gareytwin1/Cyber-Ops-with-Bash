#!/usr/bin/env bash
#
# histogram.sh
#
# Description:
# Generate a horizontal bar chart of specified data
#
# Usage: ./histogram.sh
#   input format: label value
#
usage(){
    echo "Usage: $0 [-s] <input file>" >&2
    return 1
}

function pr_bar(){
    local  -i i raw maxraw scaled
    raw=$1
    maxraw=$2
    ((scaled=(MAXBAR*raw)/maxraw))
    # min size guarantee
    ((raw > 0 && scaled == 0)) && scaled=1

    for((i=0; i<scaled; i++)) ; do printf '#'; done
    printf '%10d\n' "$raw"
} # pr_bar

# "main"
declare -A RA
declare -i MAXBAR max
max=0
MAXBAR=50           # how largest bar should be

while getopts s: opt; do
    case $opt in
        s)
            MAXBAR=$OPTARG
            if ! [[ "$MAXBAR" =~ ^[0-9]+$ ]] || [ $MAXBAR -gt 150 ] || [ MAXBAR -lt 0 ]; then 
                   echo "${RED}Error: -s option requires an integer between 0 and 150 ${NORMAL}"
                   usage
            fi ;;
        \?) usage ;;
    esac    
done
shift $((OPTIND -1))

while read labl val; do
    let RA[$labl]=$val
    # keep the largest value; for scaling
    (( val > max )) && max=$val
done

#scale and print it
for labl in "${!RA[@]}"; do
    printf '%10.20s ' "$labl"
    pr_bar ${RA[$labl]} $max
done




