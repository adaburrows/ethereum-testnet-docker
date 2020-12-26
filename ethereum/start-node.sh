#!/bin/bash
set -e

echo "Creating the genesis block from custom config..."
geth --networkid 13 --config /root/config.toml $@ init "/root/genesis.json"

echo "Waiting..."
sleep 2

echo "Reaching out to the bootnode for it's enode..."
geth attach http://eth-bootnode:8545 --exec 'admin.nodeInfo.enode' > /root/bootnode

echo "enode found:"
echo "$(cat /root/bootnode)"

echo "Waiting..."
sleep 3

echo "Standing up node..."
geth --networkid 13 --config /root/config.toml --bootnodes $(cat /root/bootnode | tr -d '"') $@
