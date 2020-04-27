#!/bin/bash

CHECKED=0
BROKEN=0
LINK="$(echo -e "$1" | sed -e 's/[[:space:]]*$//')"
FILE="$(echo -e "$2" | sed -e 's/[[:space:]]*$//')"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Cheking file $FILE against $LINK ${NC}"
BASENAME=$(basename $FILE)

while IFS= read -r line
do
    CURLINK="$(echo -e "$line" | sed -e 's/[[:space:]\r\n\t]*$//')"
    CURLINK="$(echo -e "$CURLINK" | sed -e 's/^[[:space:]\r\n\t]*//')"
    
    if [ "$CURLINK" != "" ]
    then
        result=$(curl -s $CURLINK | grep $LINK)
        ((++CHECKED))
        
        if [ "$result" != "" ]
        then
            # if the link is in the content
            echo -e "${GREEN}[GOOD]${NC} $line"
            echo $line >> "./results/good_$BASENAME"
        else
            echo -e "${RED}[BAD]${NC} $line"
            echo $line >> "./results/bad_$BASENAME"
            ((++BROKEN))
        fi
    fi
done < $FILE

echo -e "${YELLOW}"
echo "Done."
echo ""
echo "Result $FILE against $LINK"
echo "CHECKED: $CHECKED"
echo "BROKEN: $BROKEN"
echo "FOUND: $((CHECKED-BROKEN))"
echo -e "${NC}"