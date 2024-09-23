-include .env

.PHONY: build test deploy

# Build the contracts
build:
	forge build

# Run the test suite
test:
	forge test

# Deploy the contract using values from .env, no verification
deploy:
	@forge script script/DeployFyreToken.s.sol --rpc-url $(RPC_URL) --broadcast --private-key $(PRIVATE_KEY) -vvvv
