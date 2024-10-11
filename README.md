# Sagahalla Tokens

This repository contains a suite of smart contracts designed to facilitate the governance, contribution, and token management of the SagaHalla cooperative. The system is built around three primary token types—`FyreToken`, `ManaToken`, and `ShieldToken`—which interact to create a robust governance and reward structure. Below is an overview of each contract, its purpose, and its role within the system.

## Contracts Overview

### 1. `FyreToken.sol`

- **Type**: ERC-20
- **Purpose**: `FyreToken` serves as the base utility token within the cooperative. It is primarily used for rewarding contributions, making payments, and acting as a medium of exchange.
- **Key Features**:
  - **Minting**: The `onlyOwner` can mint new tokens as needed.
  - **Burning**: The `onlyOwner` can burn tokens from a specified account.
  - **Transferability**: `FyreToken` is freely transferable between users.
- **Interaction with Other Tokens**:
  - `FyreToken` can be used to acquire `mana` tokens as a way to contribute to projects or participate in cooperative activities.
  - Only collateralized `FyreToken` (backed by assets like BTC) can be used to convert `mana` into `MANA` for governance purposes.

### 2. `ManaToken.sol`

- **Type**: Hybrid ERC-20 and ERC-1400
- **Purpose**: `ManaToken` represents contributions and labor within the cooperative. It starts as `mana` (an ERC-20 token) and can be collateralized into `MANA` (an ERC-1400 token) for governance purposes.
- **Key Features**:
  - **ERC-20 (`mana`)**: Freely transferable and used for payments and speculative labor.
  - **ERC-1400 (`MANA`)**: Created when `mana` is collateralized, adding governance rights and restrictions.
  - **Collateralization**: `mana` can be burned to mint `MANA` tokens in a specified partition using a valid certificate.
  - **Partitioned Balances**: `MANA` tokens are categorized into partitions (e.g., `"default"`) to manage governance and project-specific contributions.
  - **Certificate Validation**: Uses a `CertificateController` to ensure that only authorized collateralizations and transfers are performed.
- **Interaction with Other Tokens**:
  - `mana` can be obtained using `FyreToken` and then transformed into `MANA` for governance.
  - The governance weight of `MANA` is authenticated through the `ShieldToken`.

### 3. `ShieldToken.sol`

- **Type**: ERC-721 (Non-transferable NFT)
- **Purpose**: `ShieldToken` (SHLD) represents non-transferable governance rights. It serves as a soulbound NFT that grants exclusive voting and proposal rights within the cooperative.
- **Key Features**:
  - **Non-transferable**: SHLD tokens cannot be transferred, ensuring that governance rights remain tied to the original holder.
  - **Minting**: Controlled by the `onlyOwner` of the contract, allowing the cooperative to assign governance rights to specific members.
  - **Governance Role**: SHLD holders are the only participants with direct voting rights and proposal capabilities.
- **Interaction with Other Tokens**:
  - `SHLD` verifies governance rights for `MANA` holders, making it a prerequisite for participating in decision-making processes.
  - SHLD does not interact directly with `FyreToken` but plays a key role in determining how `MANA` can be used for governance.

### 4. `CertificateController.sol`

- **Type**: Utility Contract
- **Purpose**: Handles the validation of certificates to ensure that only authorized transitions of `mana` to `MANA` are permitted. This adds a layer of security to the collateralization process.
- **Key Features**:
  - **Certificate Validation**: Verifies certificates using `isValidCertificate` before allowing actions like minting `MANA`.
  - **Certificate Management**: Marks certificates as "used" after they have been validated to prevent re-use.
- **Interaction with Other Tokens**:
  - Integrates directly with the `ManaToken` contract to ensure that the minting and partitioning of `MANA` is valid and authorized.
  - Does not interact with `ShieldToken` directly but plays a crucial role in ensuring that only valid contributions are rewarded with `MANA`.

### 5. `Treasury.sol`

- **Type**: Utility Contract for Managing Collateralization
- **Purpose**: Manages the collateralization process by interacting with the `ManaToken` contract and facilitating the transition from `mana` to `MANA`.
- **Key Features**:
  - **Collateralization**: Handles the process of collateralizing `mana` into `MANA`, interacting with the `CertificateController` to validate certificates.
  - **Mock Collateralization**: For the hackathon, it includes simplified functions for simulating deposits with testnet funds.
- **Interaction with Other Tokens**:
  - Directly interacts with `ManaToken` to trigger the collateralization process.
  - Does not directly interact with `ShieldToken` or `FyreToken` but serves as a bridge for transforming `mana` into `MANA`.

---

## How It Works Together

1. **Contribution Flow**:

   - Members receive `FyreToken` as rewards or through purchases.
   - `FyreToken` is used to acquire `mana`, which represents labor or contributions to the cooperative.
   - Contributors can collateralize `mana` into `MANA` using the `Treasury` and `CertificateController`, gaining governance rights.

2. **Governance Flow**:

   - `MANA` holders with verified `SHLD` tokens can participate in governance decisions, such as voting on project proposals.
   - The weight of a member's influence in governance is determined by the amount of `MANA` they hold, validated through `SHLD`.

3. **Security and Validation**:
   - The `CertificateController` ensures that only valid contributions are rewarded with `MANA`, adding a layer of security to the cooperative’s processes.
   - `ShieldToken` ensures that only verified members can engage in governance activities, maintaining the integrity of the decision-making process.

---

## Future Work

- **Deployment and Testing**: Add scripts and processes for deploying these contracts on testnet and running unit tests.
- **Governance Contract**: Develop a dedicated governance contract to handle proposals, votes, and other decision-making processes.
- **Cross-Chain Integration**: Expand on the cross-chain collateralization process for `FyreToken` to allow real-world asset backing.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
