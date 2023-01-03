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

1. Hyperledger Fabric docker images and binaries
1. Docker
1. Docker-Compose
1. Golang

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

### Web Application

A Web Application is available made in Nest.js

```shell
cd webapp/
```

#### Installation

```shell
npm install
```

#### Running the app

```shell
npm run start
```
