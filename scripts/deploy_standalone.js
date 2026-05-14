const hre = require("hardhat");

async function main() {
  // This gets the account linked to the private key in hardhat.config.js
  const [deployer] = await hre.ethers.getSigners();
  
  console.log("--------------------------------------------------");
  console.log("Deploying Standalone Subsidiarity with Admin:", deployer.address);
  console.log("--------------------------------------------------");

  const Subsidiarity = await hre.ethers.getContractFactory("RecursiveSubsidiarity");
  
  // deployer.address fills the '_initialAdmin' argument in the constructor
  const subsidiarity = await Subsidiarity.deploy(deployer.address); 

  await subsidiarity.waitForDeployment();
  
  const address = await subsidiarity.getAddress();
  console.log("SUCCESS!");
  console.log("Standalone Subsidiarity deployed to:", address);
  console.log("--------------------------------------------------");
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});