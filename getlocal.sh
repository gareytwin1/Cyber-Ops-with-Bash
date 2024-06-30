#!/bin/bash

# Description:
# Gathers general system information and dumps it to a file
#
# Usage:
# bash getlocal.sh < cmds.txt
#

# Sepcmds - seperate the commands from the line of input
function SepCmds()
{
   LINUXCMD=${ALINE%%|*}
   printf '============================================================================================================\n'
   printf 'Linux Command: %s\n' "$LINUXCMD"
   REST=${ALINE#*|}
   # printf 'REST: %s\n' "$REST"
   WINDOWSCMD=${REST%%|*}
   printf 'Windows Command: %s\n' "$WINDOWSCMD"
   REST=${REST#*|}
   # printf 'REST: %s\n' "$REST"
   TAG=${REST%%|*}
   printf 'TAG: %s\n' "$TAG"
   printf '============================================================================================================\n'
   if [[ $OSTYPE == "MSWin" ]]
   then
      CMD="$WINDOWSCMD"
   else
      CMD="$LINUXCMD"
   fi
}

function DumpInfo()
{
   printf '<systeminfo host="%s" type="%s"' "$HOSTNAME" "$OSTYPE"
   printf ' date="%s" time="%s">\n' "$(date '+%F')" "$(date '+%T')"
   readarray CMDS
   for ALINE in "${CMDS[@]}"
   do 
      # ignore comments
      if [[ ${ALINE:0:1} == '#' ]] ; then continue ; fi

      SepCmds

      if [[ ${CMD:0:3} == N/A ]] 
      then
         continue
      else
         printf "<%s>\n" $TAG
         $CMD
         printf "</%s>\n" $TAG
      fi
   done
   printf "</systeminfo>\n"
}

OSTYPE=$(./osdetect.sh)
HOSTNM=$(hostname)
TMPFILE="${HOSTNM}.info"

# gather the info into the tmp file; errors, too
DumpInfo > $TMPFILE 2>&1
