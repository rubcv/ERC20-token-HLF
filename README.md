# Implementation of a ERC-20 Token using Hyperledger Fabric

## Pre-requisites

1. Hyperledger Fabric docker images and binaries
1. Docker
1. Docker-Compose

> Note: This was developed using macOS, other OS have not been tested

## Run

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