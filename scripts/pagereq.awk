# pagereq.awk
#
# Description:
# Count the number of page requests for a given IP address using awk
#
# Usage:
# pagereq <ip address> < inputfile
# <ip address> IP address to search for
#
# count the number of page request from an address ($1)
awk -v page="$1" '{ if ($1==page) {cnt[$7]+=1 } }
END { for(id in cnt){
    printf "%8d %s\n", cnt[id], id
    }
}

