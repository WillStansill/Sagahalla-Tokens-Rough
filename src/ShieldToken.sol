// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract ShieldToken is ERC721, Ownable {
    uint256 public tokenIdCounter;

    constructor() ERC721("ShieldToken", "SHLD") {}

    function mint(address to) external onlyOwner {
        _mint(to, tokenIdCounter);
        tokenIdCounter += 1;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        require(from == address(0), "This token is non-transferable.");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}
