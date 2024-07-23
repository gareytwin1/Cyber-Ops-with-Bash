#!/usr/bin/env bash
# 
# histogram_plain.sh
#
# Description:
# Generate a horizontal bar chart of specified data without
# using associative arrays, good for older versions of bash
#
# Usage: ./histogram_plain.sh
#   input format: label value

declare -a RA_Key RA_value
declare -i max ndx
max_bar=50 # how large the largest bar should be

function pr_bar(){
    local -i i raw_val max_raw scaled
    raw_val=$1
    max_raw=$2
    ((scaled=(max_bar*raw_val)/max_raw))
    # min size guarantee
    ((raw_val > 0 && scaled == 0)) && scaled=1
    for((i=0; i<scaled; i++)); do printf '#'; done
    printf '\n'
} # pr_bar

# This segment just store labl in one array and val        
# in the other array with match indices.
ndx=0
while read labl val; do
    RA_key[$ndx]=$labl
    RA_value[$ndx]=$val
    # if then run expression
    ((val > max)) && max=$val
    let ndx++
done

# scale and print it
for ((j=0; j<ndx; j++)); do
    printf "%-10.20s " ${RA_key[$j]}
    pr_bar ${RA_value[$j]} $max
done

