const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying Barbarian contract with the account:", deployer.address);

  // Deploy Barbarian contract
  const Barbarian = await ethers.getContractFactory("Barbarian");
  const barbarian = await Barbarian.deploy();

  await barbarian.deployed();

  console.log("Barbarian contract deployed to address:", barbarian.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });