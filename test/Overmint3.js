const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "Overmint3"

describe(NAME, function () {
    async function setup() {
        const [owner, attackerWallet] = await ethers.getSigners();

        const VictimFactory = await ethers.getContractFactory(NAME);
        const victimContract = await VictimFactory.deploy();

        return { victimContract, attackerWallet };
    }

    describe("exploit", async function () {
        let victimContract, attackerWallet;
        before(async function () {
            ({ victimContract, attackerWallet } = await loadFixture(setup));
        })

        it("conduct your attack here", async function () {
            const AttackerFactory = await ethers.getContractFactory("Overmint3Attacker");
            const attackerContract = await AttackerFactory.connect(attackerWallet).deploy(victimContract.address);

//            victimContract.connect(attackerWallet).mint();
//
//            const signers = await ethers.getSigners();
//            let tokenId = 2;
//            for (let i = 11; i < 15; ++i) {
//                victimContract.connect(signers[i]).mint();
//                victimContract.connect(signers[i]).transferFrom(signers[i].address, attackerWallet.address, tokenId++);
//            }
        });

        after(async function () {
            expect(await victimContract.balanceOf(attackerWallet.address)).to.be.equal(5);
            expect(await ethers.provider.getTransactionCount(attackerWallet.address)).to.equal(1, "must exploit one transaction");
        });
    });
});