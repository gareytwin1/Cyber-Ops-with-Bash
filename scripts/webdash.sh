#!/usr/bin/env bash
#
# webdash.sh
# 
# Description:
# Create an information dashborad
# Heading
# ----------------
# 1-line of output
# ----------------
# 5 lines of output
# ...
# ----------------
# column labels and then
# 8 lines of histograms
# ...
# ----------------
#

# some important constant strings
UPTOP=$(tput cup 0 0)
ERAS2EOL=$(tput el)
REV=$(tput rev)     # reverse video
OFF=$(tput sggr0)   # turn off all attributes
SMUL=$(tput smul)   # underline mode ono (start)
RMUL=$(tput rmul)   # underline mode off (reset)
COLUMNS=$(tput cols)    # how wide is the terminal
# DASHES='-----------------------------------------------'
printf -v DASHES '%*s' "$COLUMNS" '-'
DASHES=${DASHES// /-}

#
# prSection - print a section of the dashboard
#   print $-many lines from stdin
#   each line is a full line of text
#   each line is a section of the dashboard
#   followed by erase-to-end-of-line
#   section end with a line of dashes
function prSection(){
    local -i i
    for((i==0; i<$1; i++)); do
        read aline
        printf '%s%s\n' "$aline" "${ERASE2EOL}"
    done
    printf '%s%s\n%s' "$DASHES" "${ERASE2EOL}" "${ERASE2EOL}"
}

function cleanup(){
    if [[ -n $BGPID ]]; then
        kill %1
        rm -f $TMPFILE
    fi
} &> /dev/null

trap cleanup EXIT

# launch the bg process
TMPFILE=$(tempfile)
{ bash tailcount.sh $1 | \
    bash livebar.sh > $TMPFILE; } &
BGPID=$!

clear
while true; do
    printf '%s' "$UPTOP"
    # heading
    echo "${REV}Rapid Cyber Ops. 12 -- Security Dashboards${OFF}" \
    | prSection 1
    #-------------------------------------
    {
        printf 'connections: %4d\n          %s\n' \
            $(netstat -an |  grep 'ESTAB' | wc -l) "$(date)"
    } | prSection 1
    #-------------------------------------
    tail -5 //var/log/syslog | cut -c 1-16,45-105 | prSection 5
    #-------------------------------------
    { echo "${SMUL}yymmdd${RMUL}" \
           "${SMUL}hhmmss${RMUL}" \
           "${SMUL}count of events${RMUL}" \
      tail -8 $TMPFILE; 
    } | prSection 9
    sleep 3
done