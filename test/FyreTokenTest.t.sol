// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {FyreToken} from "../src/FyreToken.sol";

contract FyreTokenTest is Test {
    FyreToken fyreToken;
    address owner = address(0x1);
    address user = address(0x2);

    function setUp() public {
        fyreToken = new FyreToken(owner, 1000);
    }

    function testInitialSupply() public {
        assertEq(fyreToken.totalSupply(), 1000);
        assertEq(fyreToken.balances(owner), 1000);
    }

    function testMinting() public {
        fyreToken.mint(user, 500);
        assertEq(fyreToken.balances(user), 500);
        assertEq(fyreToken.totalSupply(), 1500);
    }

    function testBurning() public {
        fyreToken.burn(owner, 200);
        assertEq(fyreToken.balances(owner), 800);
        assertEq(fyreToken.totalSupply(), 800);
    }

    function testTransfer() public {
        vm.prank(owner);
        fyreToken.transfer(user, 300);
        assertEq(fyreToken.balances(user), 300);
        assertEq(fyreToken.balances(owner), 700);
    }

    function testManaConversion() public {
        fyreToken.treasuryConvertToMana(user, 200);
    }

    function testStablecoinConversion() public {
        fyreToken.treasuryConvertToStablecoin(user, 200);
    }

    function testBTCRestriction() public {
        fyreToken.treasuryRestrictBTCRedemption(user, 100);
    }

    function testCollateralCheck() public {
        fyreToken.userInitiateCollateralCheck(user);
    }

    function testVerusIDIntegration() public {
        fyreToken.integrateVerusID();
    }
}
