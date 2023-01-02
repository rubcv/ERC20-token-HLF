set -e

# Set env vars
export CHANNEL_NAME=default
export CHAINCODE_NAME=erc20token

docker-compose -f docker-compose.yml up -d

# Wait for Hyperledger Fabric to start
# In case of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=15
sleep ${FABRIC_START_TIMEOUT}

echo "\nCreating the channel"
ORDERER_TLS_CA=`docker exec cli  env | grep ORDERER_TLS_CA | cut -d'=' -f2`
docker exec cli peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/$CHANNEL_NAME.tx --tls --cafile $ORDERER_TLS_CA

echo "\nJoining peers to the channel"
# Join peer0.org1.example.com to the channel
docker exec cli peer channel join -b $CHANNEL_NAME.block

# Join peer1.org1.example.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt \
    cli peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.example.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_ADDRESS=peer1.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt \
    cli peer channel join -b $CHANNEL_NAME.block

echo "\nPackaging the chaincode"
cd ../chaincode
GO111MODULE=on go mod vendor

docker exec -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    cli peer lifecycle chaincode package $CHAINCODE_NAME.tar.gz --path /opt/gopath/src/github.com/chaincode/ --lang golang --label ${CHAINCODE_NAME}_1.0

echo "\nInstalling the chaincode"
docker exec -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    cli peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

export PACKAGE_ID=$(docker exec -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    cli peer lifecycle chaincode queryinstalled -O json |jq -r .installed_chaincodes[0].package_id)

echo "\nPACKAGE_ID: "$PACKAGE_ID

echo "\nApproving chaincode installation"
docker exec -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    cli peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version 1.0 --package-id $PACKAGE_ID --sequence 1

echo "\nCommitting chaincode to the channel"
docker exec -it cli bash -c "peer lifecycle chaincode commit -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version 1.0 --sequence 1 --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"

docker exec -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    cli peer lifecycle chaincode querycommitted -n $CHAINCODE_NAME --channelID $CHANNEL_NAME