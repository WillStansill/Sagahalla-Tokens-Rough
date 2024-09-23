// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "lib/forge-std/src/Script.sol";
import {FyreToken} from "../src/FyreToken.sol";
import {console} from "lib/forge-std/src/console.sol";

contract DeployFyreToken is Script {
    function run() external {
        address owner = vm.envAddress("OWNER_ADDRESS");
        uint256 initialSupply = 1000;

        vm.startBroadcast();
        FyreToken fyreToken = new FyreToken(owner, initialSupply);
        vm.stopBroadcast();

        // Print the deployed contract address
        console.log("Deployed FyreToken at:", address(fyreToken));
    }
}
