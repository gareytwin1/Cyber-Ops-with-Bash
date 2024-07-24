#!/usr/bin/env bash
#
# livebar.sh
#
# Description:
# Creates rolling horizontal bar chart of live data
# 
# Usage: 
# <output from other script or program> | bash livebar.sh
#
function usage(){
    echo "Usage: $0 [-M max_value] <inputfile>"
    echo "  M: Maximum value to scale histogram between 0 and 61"
    exit 1
}
function pr_bar(){
    local raw maxraw scaled
    raw=$1
    maxraw=$2
    ((scaled=(maxbar*raw)/maxraw))
    ((scaled == 0)) && scaled=1
    for((i=0; i<scaled; i++)); do printf '#'; done
    printf '\n'
} # pr_bar

declare -i max_val=60
while getopts 'M:'; do
    case $opt in
        M)
            max_value=$OPTARG
            if ! [[ $max_value =~ ^[0-9]+$ ]] || [ $max_value -lt 1 ] || [ $max_value -gt 60 ]; then
                echo "Error: -i option requires integer greater than 1"
                usage
            fi
            ;;
        *) 
            usage
            ;;
    esac
done

if [[ -n $maxvale ]]; then
    usage
fi

maxbar=60   # largest no. of chars in a bar
MAX=$max_value
while read dayst timst qty; do
    if((qty > MAX)); then
        let MAX=$qty+$qty/4  # allow some room
        echo"       **** rescaling: MAX=$MAX"
    fi
    printf '%6.6s %6.6s %4d:' $dayst $timst $qty
    pr_bar $qty $MAX
done


