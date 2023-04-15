#!/bin/bash

set -e

forge create --rpc-url $RPC_URL \
    --constructor-args 0x000000000000000000000000000000000000dead \
    --private-key $PRIVATE_KEY \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --verify \
    src/RewardToken.sol:RewardToken
