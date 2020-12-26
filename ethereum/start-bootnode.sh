#!/bin/bash
set -e

echo "Creating the genesis block from custom config..."
geth --networkid 13 --config /root/config.toml $@ init /root/genesis.json

echo "Waiting..."
sleep 2

echo "Initializing bootnode..."
geth --networkid 13 --config /root/config.toml $@
