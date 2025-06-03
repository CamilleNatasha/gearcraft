import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const GearCraft = await ethers.getContractFactory("GearCraft");
  const gear = await GearCraft.deploy();
  console.log("GearCraft deployed to:", await gear.getAddress());
}

main().catch(console.error);
