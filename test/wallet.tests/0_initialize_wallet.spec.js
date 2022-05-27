const { expect } = require("chai");
const { parseEther } = require("ethers/lib/utils");
const { ethers, waffle } = require("hardhat");

const initializeWallet = () => {
  context("Airdrop Factory", async function () {
    it("should initialize wallet with owner", async function () {
      expect(await this.wallet.owner()).to.equal(this.signers.deployer.address);
    });

    it("only owner can approve transactions", async function () {
      const { deployer, client1 } = this.signers;
      const ERC20 = this.mockToken;

      await expect(
        this.wallet
          .connect(client1)
          .approve(ERC20.address, deployer.address, true)
      ).to.be.revertedWith("Only owner is allowed");
    });
  });
};

module.exports = {
  initializeWallet,
};
