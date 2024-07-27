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

RE='"detected":(true|false),"result":"([^"]*)","update":"([^"]*)","version":"([^"]*)"'
FN=${1:-Calc_VirusTotal.json}
sed -e 's/.*,"scans":/{"scans":\n/' -e 's/},/&\n/g' -e 's/}}.*/}}/' $FN |
while read -r ALINE; do
    if [[ $ALINE =~ $RE ]]; then
        DETECTED=${BASH_REMATCH[1]}
        RESULT=${BASH_REMATCH[2]}
        UPDATE=${BASH_REMATCH[3]}
        VERSION=${BASH_REMATCH[4]}
       echo "Detected: $DETECTED - Result: $RESULT - Update: $UPDATE - Version: $VERSION"
   fi
done