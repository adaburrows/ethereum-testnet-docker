# Ethereum test network in a box

Sets up an ethereum test network.

## Overview

The Ethereum network is wide open. So please don't look at this as an example
of good security. In fact, look at it as the worst example. This is purely for
ease of development. DO NOT use any of this in production.

Ethereum ports (useful for connecting extra-container apps) which can
optionally be used to allow access to the geth process outside the containers:

```
    ports:
     - "30303:30303"      # Ethereum P2P
     - "30303:30303/udp"  # Ethereum P2P UDP
     - "8545:8545"        # HTTP
     - "8546:8546"        # WS
     - "8547:8547"        # GraphQL
```

## Ethereum Accounts

Nodes have a keystore with one account set up (all of them have the same pw):

```
eth-bootnode: 0xB007c62365bFECCF872A39c3a15df7A9027c79bd
eth-signer:   0xacaB1655FACFc82AeF2d3C453dC11dF6d0058b48
eth-faucet:   0xacABb6Df0D0703467Ed7dc7A549D541dad48F937
eth-xochitl:  0x075DDc7E2f96e65a7835e55FB3DbfD438c4A26E0
eth-cuauhtli: 0x65F5641480B861815E2C188F6097D519A8c48c98
```

## Usage

First things first, create the needed docker network:

```
./ethereum/scripts/create_docker_network
```

Then bring the network up:

```
docker-compose up
```

When it first starts up, it will take a minute or so for all the nodes to peer.
After, they've peered the first time it will be faster the next time, as long
as you're not recreating the network after tearing it down.

There are four basic scripts included for getting started sending Wei (the base
unit of ethereum) between accounts:

 * ./ethereum/scripts/balance $eth-node
 * ./ethereum/scripts/drip $recieving-account $value
 * ./ethereum/scripts/send $eth-node $sending-account $recieving-account $value
 * ./ethereum/scripts/geth_console $eth-node

For example, let check the balance on eth-faucet:

```
./ethereum/scripts/balance eth-faucet
```

```
9.04625697166532776746648320380374280103671755200316906558262375061821325312e+74
```

We're rich! Now, let's check out eth-xochitl:

```
./ethereum/scripts/balance eth-xochitl
```

```
0
```

Poor Xochitl! Let's give her some money:

```
./ethereum/scripts/drip 075DDc7E2f96e65a7835e55FB3DbfD438c4A26E0 75000000000000000000000000000000
```

```
"0x313e89e71294b804ff4fbdd9cad80d723bfd8f25d5883e7648ef601059d36b80"
```

What we got back is the transaction id. We actually have to wait a bit for the
signer node to "mine" a new block. Once you see the other nodes have picked up
the new block in the docker logs, we can check Xochitl's balance again:

```
./ethereum/scripts/balance eth-xochitl
```

```
7.5e+31
```

Now Xochitl has quite a bit of ethereum, but we have barely made a dent in our
faucet's balance:

```
./ethereum/scripts/balance eth-faucet
```

```
9.04625697166532776746648320380374280103671680200316906558262354061821325312e+74
```

What else can we do? Let's send some of the money from Xochitl to Cuauhtli:

```
./ethereum/scripts/send eth-xochitl 075DDc7E2f96e65a7835e55FB3DbfD438c4A26E0 65F5641480B861815E2C188F6097D519A8c48c98 7500000000000000000000000000000
```

```
"0x52c45de29f05afc68359a95776a745b694393a9cf8280508cb4fcfd0db86db1a"
```

```
./ethereum/scripts/balance eth-xochitl
```

```
6.7499999999999999979e+31
```

```
./ethereum/scripts/balance eth-cuauhtli
```

```
7.5e+30
```

Finally, we can directly connect to the geth js console on any node with:

```
./ethereum/scripts/geth_console eth-xochitl
```

I hope you find this useful!
