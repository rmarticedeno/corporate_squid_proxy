#!/bin/bash

while true; do
    read line
    user=$(echo $line | cut -d' ' -f1)
    pass=$(echo $line | cut -d' ' -f2)

    if [ "$user" == $USERNAME ] && [ "$pass" == $PASS ]; then
    echo "OK"
    else
    echo "ERROR"
    fi
done

