#!/bin/bash

pwd

echo "Enable sshd"
service ssh start

echo "Everthing you need is running!"

if [[ $1 == "-d" ]]; then
    while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
    /bin/bash
fi
