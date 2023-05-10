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

# getting enode URL of Node-1
getKey=$(cat Node-1/data/key.pub)
key=$(echo "$getKey" | awk '{print substr($0, 3)}')
echo $key
enodeURL=$(echo "enode://"$key"@127.0.0.1:30303")
echo $enodeURL

# loop through each directory in the parent directory
for dir in $PWD/*Node* ; do
  if [[ -d "$dir" ]]; then
    cd $dir/Tessera

    # get the node name from the directory name
    node_name=$(basename "$dir")
    # start tessera
    nohup tessera -configfile tessera.conf > /dev/null 2>&1 &
    echo "Started Tessera for $node_name"
    cd ../
    if [[ $node_name == "Node-1" ]]; then
        echo "You entered 'Node-1'"
        besu --data-path=data --genesis-file=../genesis.json --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT,EEA,PRIV --host-allowlist="*" --rpc-http-cors-origins="all" --privacy-enabled --privacy-url=http://127.0.0.1:9102 --privacy-public-key-file=Tessera/nodeKey.pub --min-gas-price=0 &
    elif [[ $node_name == "Node-2" ]]; then
        echo "You entered 'Node-2'"
        besu --data-path=data --genesis-file=../genesis.json --bootnodes=$enodeURL --p2p-port=30304 --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT,EEA,PRIV --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8546 --privacy-enabled --privacy-url=http://127.0.0.1:9202 --privacy-public-key-file=Tessera/nodeKey.pub --min-gas-price=0 &
    elif [[ $node_name == "Node-3" ]]; then
        echo "You entered 'Node-3'"
        besu --data-path=data --genesis-file=../genesis.json --bootnodes=$enodeURL --p2p-port=30305 --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT,EEA,PRIV --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8547 --privacy-enabled --privacy-url=http://127.0.0.1:9302 --privacy-public-key-file=Tessera/nodeKey.pub --min-gas-price=0 &
    else
        echo "You entered 'Node-4'"
        besu --data-path=data --genesis-file=../genesis.json --bootnodes=$enodeURL --p2p-port=30306 --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT,EEA,PRIV --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8548 --privacy-enabled --privacy-url=http://127.0.0.1:9402 --privacy-public-key-file=Tessera/nodeKey.pub --min-gas-price=0
    fi
  fi
done