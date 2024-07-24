WINLOG="Application"
LASTLOG=$(wevtutil qe "$WINLOG" //c:1 //rd:true //f:text)

while true; do
    CURRENTLOG=$(wevutil qe "$WINLOG" //c:1 //rd:true //f:text)
    if [[ "$CURRENTLOG" != "$LASTLOG" ]]; then
        echo "$CURRENTLOG"
        echo "-------------------------------"
        LASTLOG="$CURRENTLOG"
    fi
done
