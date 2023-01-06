# ERC-20 Token implementing methods for Hashed Time-Lock transactions on Hyperledger Fabric

## Table of contents

- [Pre-requisites](#pre-requisites)
- [Hyperledger Fabric network](#hyperledger-fabric-network)
- [Run](#run)
    - [Deploy the network](#deploy-the-network)
    - [Web Application](#web-application)
        - [Installation](#Installation)
        - [Running the app](#running-the-app)

## Pre-requisites

1. Hyperledger Fabric
1. Docker
1. Docker-Compose
1. Golang
1. NodeJS / TypeScript
1. npm

> Note: This has been developed using macOS, other OS have not been tested.

## Hyperledger Fabric network

The Hyperledger Fabric network consists of: 
* One orderer
    * orderer.example.com
* One organization
    * MSPID: Org1MSP
    * Two peers:
        * peer0.org1.example.com
        * peer1.org1.example.com
    * One CouchDB state database deployment for each peer
    * Fabric CA
        * ca.org1.example.com 
* Fabric CLI

![Network deployment](./img/topology.png)


## Run

### Deploy the network

1. Install Hyperledger Fabric latest docker images and binaries.
    ```shell
    ./install-fabric.sh
    ```
    this will generate a `fabric-samples` folder inside the project directory.
> Note: The `fabric-samples` folder is not needed, as we will only be using the downloaded Docker images to deploy the network

1. Generate the network artifacts.
    ```shell
    cd network-files
    ./generate.sh
    ```
![Network deployment](./img/generate.png)

1. Deploy the network.
    ```shell
    ./start.sh
    ```
![Network deployment](./img/start.png)

1. Teardown the network
    ```shell
    ./teardown.sh
    ```
![Network deployment](./img/teardown.png)

## Web Application

A Web Application is available made in **Nest.js**

```shell
cd webapp/
```

### Installation

```shell
npm install
```

### Running the app

```shell
npm start
```
![Web Application](./img/webapp-start.png)

## Firefly fabconnect

Firefly fabconnect is a reliable REST and websocket API to interact with a Fabric network and stream events.

See: https://github.com/hyperledger/firefly-fabconnect

Firefly fabconnect can be connected to the network and used to interact with it.

### Steps:

1. Pull the firefly-fabconnect repository
    ```shell
    git pull https://github.com/hyperledger/firefly-fabconnect.git
    ```
1. Go into the folder and run `make`
    ```shell
    cd firefly-fabconnect
    make
    ```
1. Firefly fabconnect needs 2 configuration files: `firefily-fabconnect-config.json` with all the Firefly configuration, and `connection-profile.json` with the Hyperledger Fabric blockchain network configuration.
    `firefly-fabconnect-config.json` can be found inside the `firefly-fabconnect/` folder of this repository.
    `connection-profile.json` is the one used by the Nest.JS WebAPP (fabric SDK) to connect to the blockchain.

    Launch the connector:
    ```shell
    ./fabconnect -f ${PWD}/firefly-fabconnect/firefly-fabconnect-config.json
    ```

    Additionally, here is the `firefly-fabconnect-config.json` file's content:

    ```json
    {
    "maxInFlight": 10,
    "maxTXWaitTime": 60,
    "sendConcurrency": 25,
    "receipts": {
      "maxDocs": 1000,
      "queryLimit": 100,
      "retryInitialDelay": 5,
      "retryTimeout": 30,
      "leveldb": {
        "path": "./receipts"
      }
    },
    "events": {
      "webhooksAllowPrivateIPs": true,
      "leveldb": {
        "path": "./events"
      }
    },
    "http": {
      "port": 3000
    },
    "rpc": {
      "useGatewayClient": true,
      "configPath": "../webapp/src/blockchain/utils/connection-profile.json"
    }
  }
    ```