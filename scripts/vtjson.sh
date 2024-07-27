#!/usr/bin/env bash
#
# vtjson.sh 
# Description: 
# Search a JSON file for VirusTotal scan results.
#
# Usage: vtjson.sh <file.json>
# <file.json> - JSON file containing VirusTotal scan results.
#               default: Calc_VirusTotal.json
#

RE='^.(.*)...\{.*detect..(.,*),..vers.*result....(.*),..update.*$'

FN="${1:-Calc_VirusTotal.json}"
sed -e 's/{"scans": {/&\n /' -e 's/},/&\n/g' "$FN" |
while read ALINE; do
    if [[ $ALINE =~ $RE ]]; then
        VIRUS=${BASH_REMATCH[1]}
        FOUND=${BASH_REMATCH[2]}
        RESLT=${BASH_REMATCH[3]}
        if [[ $FOUND == .*true.* ]]; then
            echo "Virus: " $VIRUS " - Result: " $RESLT
        fi
    fi
done