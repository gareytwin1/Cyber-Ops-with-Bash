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

function pr_bar(){
    local raw maxraw scaled
    raw=$1
    maxraw=$2
    ((scaled=(maxbar*raw)/maxraw))
    ((scaled == 0)) && scaled=1
    for((i=0; i<scaled; i++)); do printf '#'; done
    printf '\n'
} # pr_bar

# main
maxbar=60   # largest no. of chars in a bar
MAX=60      # largest value in the data
while read dayst timst qty; do
    if((qty > MAX)); then
        let MAX=$qty+$qty/4  # allow some room
        echo"       **** rescaling: MAX=$MAX"
    fi
    printf '%6.6s %6.6s %4d:' $dayst $timst $qty
    pr_bar $qty $MAX
done


