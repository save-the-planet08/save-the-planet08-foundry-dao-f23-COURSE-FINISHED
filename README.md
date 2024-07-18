# Minimal DAO Project

## Overview

This project implements a Minimal DAO (Decentralized Autonomous Organization) using smart contracts. It's built on the Ethereum blockchain and utilizes OpenZeppelin's governance contracts. The DAO controls a contract, and every transaction is subject to a vote.

## Features

1. DAO-controlled contract
2. Voting mechanism for all transactions
3. ERC20 token integration (current implementation uses a default model)

## Project Structure

The project consists of the following main components:

- `src/`: Source code for the smart contracts
- `test/`: Test files for the smart contracts

## Smart Contracts

### Box.sol

A simple contract that stores a number. It's owned by the DAO and can only be updated through governance proposals.

### MyGovernor.sol

The main governance contract that inherits from various OpenZeppelin governance modules. It handles proposal creation, voting, and execution.

### GovToken.sol

An ERC20 token contract used for governance voting power.

### TimeLock.sol

A timelock contract that adds a delay between the passing of a proposal and its execution.

## Testing

The project includes comprehensive tests to ensure the correct functioning of the governance mechanism. Key test cases include:

- Verifying that the Box contract can't be updated without governance
- Testing the full governance flow from proposal creation to execution

## Setup and Usage

(Add instructions for setting up and running the project, including any dependencies and environment setup)

## Development

This project was developed as part of the Foundry course by Patrick Collins. It uses the Foundry framework for Ethereum development.

## License

This project is licensed under the MIT License.

## Contributors

- Frederik Pietratus

## Acknowledgements

- OpenZeppelin for their governance contracts
- Patrick Collins for the Foundry course

## Future Improvements

- Implement a more sophisticated token model for governance
- Enhance the voting mechanism
- Add more features to the governed contract (Box.sol)
