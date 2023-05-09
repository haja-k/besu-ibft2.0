#!/bin/bash

# Delete generated genesis and networkFiles from previous init
rm -f genesis.json
rm -rf networkFiles

echo "previous init files deleted"

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

# Run chain init
besu operator generate-blockchain-config --config-file=ibftConfigFile.json --to=networkFiles --private-key-file-name=key

echo "besu operator executed"

# Delete data folders for all nodes
rm -rf Node-1/data
rm -rf Node-2/data
rm -rf Node-3/data
rm -rf Node-4/data

DIRECTORY="networkFiles/keys"
i=0

# Loop through the directories and echo the directory name
for dir in $DIRECTORY/*; do
    ((i++))
    # Copy key files/folders to data folders for all nodes
    cp -R ${dir}/ Node-$i/data
done

cp -R networkFiles/genesis.json .

# Getting enode URL of Node-1
getKey=$(cat Node-1/data/key.pub)
key=$(echo "$getKey" | awk '{print substr($0, 3)}')
echo $key
enodeURL=$(echo "enode://"$key"@127.0.0.1:30303")
echo $enodeURL

# Run Node 1
cd Node-1
besu --data-path=data --genesis-file=../genesis.json --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-allowlist="*" --rpc-http-cors-origins="all" &

# Run Node 2
cd ../Node-2
besu --data-path=data --genesis-file=../genesis.json --bootnodes=$enodeURL --p2p-port=30304 --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8546 &

# Run Node 3
cd ../Node-3
besu --data-path=data --genesis-file=../genesis.json --bootnodes=$enodeURL --p2p-port=30305 --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8547 &

# Run Node 4
cd ../Node-4
besu --data-path=data --genesis-file=../genesis.json --bootnodes=$enodeURL --p2p-port=30306 --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8548
