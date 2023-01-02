# Implementation of a ERC-20 Token using Hyperledger Fabric

## Table of contents

- [Pre-requisites](#pre-requisites)
- [Run](#run)
    - [Deploy the network](#deploy-the-network)

## Pre-requisites

1. Hyperledger Fabric docker images and binaries
1. Docker
1. Docker-Compose
1. Golang

> Note: This has been developed using macOS, other OS have not been tested.

## Run

### Deploy the network

1. Install Hyperledger Fabric latest docker images and binaries.
    ```shell
    ./install-fabric.sh
    ```
1. Generate the network artifacts.
    ```shell
    cd network-files
    ./generate.sh
    ```
1. Deploy the network.
    ```shell
    ./start.sh
    ```
1. Teardown the network
    ```shell
    ./teardown.sh
    ```

