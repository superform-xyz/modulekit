# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# Export RPC URL
export MAINNET_RPC_URL = $(shell op read op://5ylebqljbh3x6zomdxi3qd7tsa/ETHEREUM_RPC_URL/credential)

build :; forge build

test :; forge test

test-vvv :; forge test -vvv

clean :; forge clean

.PHONY: build test test-vvv clean 