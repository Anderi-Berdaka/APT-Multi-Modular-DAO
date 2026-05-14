const hre = require("hardhat");

async function main() {
  console.log("Starting Governance Hub deployment...");

  // Get the contract factory
  const Hub = await hre.ethers.getContractFactory("APT_Governance_Hub");
  
  // Deploy the contract
  const hub = await Hub.deploy();

  console.log("Waiting for deployment to confirm...");
  await hub.waitForDeployment();

  const hubAddress = await hub.getAddress();

  // Now I fetch the addresses of the child modules created in the constructor
  const qv = await hub.quadraticVoting();
  const ov1 = await hub.optimisticV1();
  const ov2 = await hub.optimisticV2();
  const cv = await hub.convictionVoting();
  const rs = await hub.recursiveSubsidiarity();

  console.log("==========================================");
  console.log("GOVERNANCE HUB DEPLOYED");
  console.log("==========================================");
  console.log(`Hub Address:          ${hubAddress}`);
  console.log(`Quadratic Voting:     ${qv}`);
  console.log(`Optimistic V1:        ${ov1}`);
  console.log(`Optimistic V2:        ${ov2}`);
  console.log(`Conviction Voting:    ${cv}`);
  console.log(`Recursive Subsidiarity: ${rs}`);
  console.log("==========================================");
  console.log("\nNext: Verify the Hub on Etherscan to see all modules!");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});