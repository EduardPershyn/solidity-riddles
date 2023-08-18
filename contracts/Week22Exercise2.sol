// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

// Signatures can be re-used between contracts and different chains.
// Took msg + sig for same signer address from https://optimistic.etherscan.io/tx/0x08e18539b6a2b45c74aa3eb4bc769a173baf87b3373437123c9498d72f02c2e2

contract Week22Exercise2 {
    using ECDSA for bytes32;
    address public verifyingAddress = 0x0000000cCC7439F4972897cCd70994123e0921bC;
    mapping(bytes => bool) public used;

    function challenge(
        string calldata message,
        bytes calldata signature
    ) public {
        bytes32 signedMessageHash = keccak256(abi.encode(message))
        .toEthSignedMessageHash();
        require(
            signedMessageHash.recover(signature) == verifyingAddress,
            "signature not valid"
        );

        require(!used[signature]);
        used[signature] = true;
    }
}
