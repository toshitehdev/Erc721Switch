const hre = require("hardhat");

async function main() {
  const Erc721Switch = await hre.ethers.getContractFactory("Erc721Switch");
  const ercswitch = await Erc721Switch.deploy();

  await ercswitch.deployed();
  console.log(`Deployed to: ${ercswitch.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
