#!/bin/bash
#
# Description:
# Distinguish between MS-Windows/Linux/MacOS
# 
# Usage: bash osdetect.sh
#   output will be one of: Linux MSWin MacOS

if type -t wevutil &> /dev/null
then
   OS=MSWin
elif type -t scutil &> /dev/null
then
   OS=MacOS
else
   OS=Linux
fi
echo $OS
