require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); 

console.log("URL Check:", process.env.ALCHEMY_SEPOLIA_URL ? "Found!" : "Missing!");
console.log("Etherscan Key Check:", process.env.ETHERSCAN_API_KEY ? "Found!" : "Missing!");

const { ALCHEMY_SEPOLIA_URL, METAMASK_PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: ALCHEMY_SEPOLIA_URL,
      accounts: [METAMASK_PRIVATE_KEY]
    }
  },
  etherscan: {
    // Simplified for Etherscan API V2
    apiKey: ETHERSCAN_API_KEY
  }
};