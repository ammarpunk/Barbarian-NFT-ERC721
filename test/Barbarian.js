const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Barbarian", function () {
  let barbarian;
  let owner;
  let user;

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();

    const Barbarian = await ethers.getContractFactory("Barbarian");
    barbarian = await Barbarian.deploy();
    await barbarian.deployed();
  });

  it("Should deploy the Barbarian contract", async function () {
    expect(await barbarian.name()).to.equal("Barbarian");
    expect(await barbarian.symbol()).to.equal("BRN");
  });

  it("Should mint tokens to the owner", async function () {
    await barbarian.intMint();
    const ownerBalance = await barbarian.balanceOf(owner.address);
    expect(ownerBalance).to.equal(1);
  });

  it("Should allow the owner to pause and unpause the contract", async function () {
    await barbarian.pause();
    expect(await barbarian.paused()).to.be.true;

    await barbarian.unpause();
    expect(await barbarian.paused()).to.be.false;
  });

  it("Should allow whitelist minting", async function () {
    // Add the user to the whitelist
    await barbarian.setAllowList([user.address]);

    // Enable whitelist minting
    await barbarian.mintWindows(true, false);

    // User mints a token
    await expect(user.sendTransaction({ to: barbarian.address, value: ethers.utils.parseEther("0.001") })).to.not.be.reverted;
  });

  it("Should allow public minting", async function () {
    // Enable public minting
    await barbarian.mintWindows(false, true);

    // User mints a token
    await expect(user.sendTransaction({ to: barbarian.address, value: ethers.utils.parseEther("1") })).to.not.be.reverted;
  });
});
