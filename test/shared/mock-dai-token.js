const { BigNumber } = require("ethers");
const { waffle } = require("hardhat");
const ERC_20_ABI = require("../../abis/erc20.abi.json");

async function deployMockDAI(deployer) {
  const erc20 = await waffle.deployMockContract(deployer, ERC_20_ABI);

  await erc20.mock.decimals.returns(18);
  await erc20.mock.name.returns(`Test DAI`);
  await erc20.mock.symbol.returns(`tDAI`);
  await erc20.mock.transferFrom.returns(true);
  await erc20.mock.allowance.returns(BigNumber.from("10000000").toNumber());

  return erc20;
}

module.exports = { deployMockDAI };
