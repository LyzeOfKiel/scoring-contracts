#!/bin/bash

set -e

forge create --rpc-url $RPC_URL \
    --constructor-args 0x0000000000000000000000000000000000000000 \
    --private-key $PRIVATE_KEY \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --verify \
    src/ScoreState.sol:ScoreState
