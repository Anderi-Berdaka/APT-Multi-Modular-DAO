const hre = require("hardhat");

async function main() {
    // These are public Sepolia addresses for demonstration purposes.
  const subsidiarityAddress = "0x3abF65bB1D9e798936e6a4Ab92Fd5463EFd9a441";
  const addressToCheck = "0xEfcB88eB863d06b5C9bDf800d9decc493Fe22EFe";

  console.log("\n--- DAO HUB VERIFICATION PORTAL ---");
  
  // Get the contract factory first to ensure we have the ABI loaded
  const Subsidiarity = await hre.ethers.getContractAt("RecursiveSubsidiarity", subsidiarityAddress);

  try {
    const isAuthorized = await Subsidiarity.isAuthorizedHub(addressToCheck);
    
    console.log(`Checking status for: ${addressToCheck}`);

    if (isAuthorized) {
      console.log("RESULT: ✅ ACCESS GRANTED");
      console.log("This address is a Verified Local Hub.");
    } else {
      console.log("RESULT: ❌ ACCESS DENIED");
    }
  } catch (error) {
    console.log("Error querying the blockchain:", error.message);
  }
  
  console.log("-----------------------------------\n");
}

// Ensure the script waits for the main function to finish
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });