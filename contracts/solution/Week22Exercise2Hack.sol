// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../Week22Exercise2.sol";

import "hardhat/console.sol";

contract Week22Exercise2Hack {
    Week22Exercise2 victim;

    constructor(Week22Exercise2 victim_)  {
        victim = victim_;
    }

    function attack() external {
        string memory msg = "attack at dawn";
        bytes memory sig = hex"e5d0b13209c030a26b72ddb84866ae7b32f806d64f28136cb5516ab6ca15d3c438d9e7c79efa063198fda1a5b48e878a954d79372ed71922003f847029bf2e751b";

//        uint8 v = 0x1b;
//        bytes32 r = 0xe5d0b13209c030a26b72ddb84866ae7b32f806d64f28136cb5516ab6ca15d3c4;
//        bytes32 s = 0x38d9e7c79efa063198fda1a5b48e878a954d79372ed71922003f847029bf2e75;
//        bytes memory signature = abi.encodePacked(r, s, v);
//        assert(signature.length == 65);

        victim.challenge(msg, sig);
    }
}