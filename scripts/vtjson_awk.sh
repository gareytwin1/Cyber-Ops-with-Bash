#!/usr/bin/env bash
# vtjson.awk
#
# Description: 
# Search a JSON file for VirusTotal malware hits
#
# Usage:
# vtjson.awk <jsonfile>
#   <jsonfile> - file containing results from VirusTotal
#

FN="${1:-Calc_VirusTotal.txt}"
sed -e 's/.*,"scans":{//' -e 's/},/&\n/g' -e 's/}}.*/}}/' -e 's/[:,{}]/ /g' "$FN" |
 awk '
    NF == 9 {
        QUOTE="\""
        if ( $3 == "true"){
            VIRUS=$5
            gsub(QUOTE, "",VIRUS)
            RESLT=$3
            gsub(QUOTE, "", RESLT)    
            print "Detected: " VIRUS, " Result:", RESLT
        }
    }
'