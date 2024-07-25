#!/usr/bin/env bash
#
# fd2.sh
#
# Description: 
# Compares to port scans to find changes
# Major Assumption: both files have the same # of lines,
# each line with the same host address
# though with possibly different listed ports
#
# Usage: ./fd2.sh <file1> <file2>
#

# look for "$LOOKFOR" in the list of args to this function
# retuns true (0) if it is not in the list
function not_in_list(){
    for port in "$@"; do
        if [[ $port == $LOOKFOR ]]; then
            return 1
        fi
    done
    return 0
}

while true; do
    read aline <&4 || break
    read bline <&5 || break

    # if [[ $aline == $bline ]]; then continue; fi
    [[ $aline == $bline ]] && continue;

    # there's a difference, so
    # subdivide into host and ports
    HOSTA=${aline%% *}
    PORTSA=( ${aline#* } )

    HOSTB=${bline%% *}
    PORTSB=( ${bline#* } )

    echo $HOSTA

    for porta in ${PORTA[@]}; do
        LOOKFOR=$porta not_in_list ${PORTSB[@]} && echo "   closed: $porta"
    done

    for portb in ${PORTB[@]}; do
        LOOKFOR=$portb not_in_list ${PORTSA[@]} && echo "   closed: $portb"
    done
done 4< ${1:-day1.data} 5< ${2:-day2.data}
# day1.data and day2.data are default names to make it easier to test

