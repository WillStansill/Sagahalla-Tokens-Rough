// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract CertificateController is Ownable {
    mapping(bytes32 => bool) public usedCertificates;

    constructor() Ownable() {}

    // Mock function for certificate validation
    function isValidCertificate(
        bytes calldata data
    ) external view returns (bool) {
        bytes32 certificateHash = keccak256(data);
        require(!usedCertificates[certificateHash], "Certificate already used");
        return true;
    }

    // Mark a certificate as used
    function useCertificate(bytes calldata data) external onlyOwner {
        bytes32 certificateHash = keccak256(data);
        usedCertificates[certificateHash] = true;
    }
}
