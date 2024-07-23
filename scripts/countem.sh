#!/usr/bin/env bash
#
# countem.sh
#
# Description: 
# Count the number of instances of an item using bash
# 
# Usage
# countem.sh < inputfile
#

declare -A cnt          # associative array
while read id xtra; do
    let cnt[$id]++
done

# now display what we counted
# for each key in the (key, value) assoc. array
for id in "${!cnt[@]}"; do
    printf '%d %s\n' "${cnt[$id]}" "$id"
done
