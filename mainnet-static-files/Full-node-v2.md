# Tutorial to participate in the Oraichain mainnet

This tutorial helps full node operators quickly synchronize with the Oraichain mainnet by downloading a storage snapshot prepared by the team. The downloading speed is much faster than synchronizing from the first block, which allows fast set up to join the network in no time!

## Hardware specifications for an Oraichain node:

A dedicated node that can run Docker amd64.

**Minimum requirements**

```
The number of CPUs: 2vCPUs
RAM: 2GB
Storage: 200GB SSD
```

**Recommended requirements**

```
The number of CPUs: 2vCPUs
RAM: 2GB
Storage: 200GB SSD
```

**Estimated cost for a node with minimum requirements using Digital Ocean: $25/month**

![droplet](./droplet.jpg)

![disk](./disk.jpg)

## Setup the node

### 1. Download and run the setup file

```bash
curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docker-compose.fast.yml && curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/orai.env && mv docker-compose.fast.yml docker-compose.yml
```

### 2. Edit your moniker in the orai.env file you have just downloaded

### 3. Build and enter the container

With docker, your node can run on any platforms. As a result, it is a must to install and download Docker & docker-compose. Afterward, please type:

```bash
docker-compose pull && docker-compose up -d --force-recreate
```

### 4. Initiate the node

Please enter the container and type:

```bash
oraid init "$MONIKER" --home /workspace/.oraid
```

then, you need to download the network's genesis file by using the following command inside your container:

```bash
wget -O /workspace/.oraid/config/genesis.json https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/genesis.json

```

### 5. Download Chain Data

```bash
docker-compose exec orai bash -c 'wget -O - https://orai.s3.us-east-2.amazonaws.com/oraid-data-bk.tar.gz | tar -zxvf - && mv -r /workspace/data/* /workspace/.oraid/data/'
```

### 6. Start the node

Please exit the container and follow the below steps to start the nodes

#### List of seed & sentry nodes that you can connect to

```bash
0baa806b3a4dd17be6e06369d899f140c3897d6e@18.223.242.70:26656
9749da4a81526266d7b8fe9a03d260cd3db241ad@18.116.209.76:26656
8a8c58e5514c86051940b3bbe39db2817de62288@34.79.231.38:26656
59d49e39d507bb190e746bcf5590d65879c132e2@13.79.247.74:26656
35c1f999d67de56736b412a1325370a8e2fdb34a@5.189.169.99:26656
5ad3b29bf56b9ba95c67f282aa281b6f0903e921@64.225.53.108:26656
```


```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --p2p.pex false --p2p.persistent_peers "<node-id1>@<pubclic-ip1>:26656,<node-id2>@<public-ip2>:26656"'
```

If you do not specify the **--p2p.persistent_peers** flags, you must add at least a persistent peer connection in the **.oraid/config/config.toml** file before running the below command, otherwise your node will not be able to connect to the Oraichain network.

The above commands run as the background process so when you turn off your Terminal, it is still running. You can always run them in the foreground process by removing the "-d" flag.