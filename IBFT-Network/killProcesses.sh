#!/bin/bash

# list of ports to check
ports=("30303" "30304" "30305" "30306")

# loop through the ports and kill processes if found
for port in "${ports[@]}"
do
    pid=$(lsof -ti tcp:$port)
    if [ -n "$pid" ]; then
        echo "Killing processes on port $port..."
        kill $pid
        echo "Processes killed on port $port."
    else
        echo "No processes found on port $port."
    fi
done
