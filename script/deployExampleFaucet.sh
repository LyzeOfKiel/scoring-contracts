#!/bin/bash

set -e

forge create --rpc-url $RPC_URL \
    --constructor-args 0xF6930F793e92fB1b849E3F1D7f339D6920e408e2 0xd3357Dc0F30316E539fB2f5dc55D09f48f3f3D53 5 \
    --private-key $PRIVATE_KEY \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --verify \
    src/ExampleFaucet.sol:ExampleFaucet
