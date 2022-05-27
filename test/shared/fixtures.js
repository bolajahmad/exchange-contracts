const { ethers } = require("hardhat");
const { deployMockDAI } = require(".//mock-dai-token");

const walletFixture = async (signers) => {
  const deployer = signers[0];

  const walletFactory = await ethers.getContractFactory(`Wallet`);
  const wallet = await walletFactory.connect(deployer).deploy(deployer.address);

  await wallet.deployed();
  const erc20DAI = await deployMockDAI(deployer);

  return { walletFixture: wallet, erc20DAI };
};

module.exports = { walletFixture };
