const { waffle } = require("hardhat");
const { walletFixture } = require("./shared/fixtures");
const { initializeWallet } = require("./wallet.tests/0_initialize_wallet.spec");

describe("Unit Tests", async function () {
  before(async function () {
    const wallets = waffle.provider.getWallets();

    this.signers = {
      deployer: wallets[0],
      client1: wallets[1],
      client2: wallets[2],
    };

    this.loadFixture = waffle.createFixtureLoader(wallets);
  });

  describe("Wallet Factory", async function () {
    beforeEach(async function () {
      const { walletFixture: wallet, erc20DAI } = await this.loadFixture(
        walletFixture
      );

      this.wallet = wallet;
      this.mockToken = erc20DAI;
    });

    initializeWallet();
  });
});
