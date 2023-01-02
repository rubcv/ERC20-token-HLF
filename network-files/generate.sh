# Set env vars
export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME=default

# Remove previous crypto material and config transactions
mkdir -p artifacts
rm -rf artifacts/*
rm -rf crypto-config/*

# Generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# Generate genesis block for orderer
configtxgen -profile OneOrgOrdererGenesis -channelID system-channel -outputBlock ./artifacts/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# Generate channel creation transaction
configtxgen -profile OneOrgChannel -outputCreateChannelTx ./artifacts/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel creation transaction..."
  exit 1
fi
