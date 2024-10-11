// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ManaToken} from "./ManaToken.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Treasury is Ownable {
    ManaToken public manaToken;
    uint256 public collateralizationRate = 100000; // 1 Sepolia ETH = 100,000 MANA tokens

    constructor(address _manaToken) {
        manaToken = ManaToken(_manaToken);
    }

    // Collateralize mana tokens into MANA (ERC-1400) tokens
    function collateralizeMana(
        address contributor,
        uint256 amount,
        bytes calldata data
    ) external onlyOwner {
        manaToken.collateralize(contributor, amount, data);
    }

    // Mock deposit function to simulate Sepolia ETH collateralization
    function depositCollateral() external payable {
        // For demo purposes; actual ETH logic could be implemented here
    }
}
