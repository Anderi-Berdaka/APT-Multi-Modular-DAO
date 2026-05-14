### Technical Architecture: APT Multi-Modular DAO 
This project implements a decentralized autonomous organization (DAO) on the Ethereum Sepolia testnet, utilizing a modular "Hub-and-Spoke" architecture. Unlike monolithic DAOs, this system separates governance logic into distinct, specialized modules to enhance flexibility.

### Governance Modules
The **APT_Governance_Hub** serves as the central registry, orchestrating interactions between four primary governance models:
- **Quadratic Voting Module:** Mitigates the "whale" problem by using a mathematical cost-per-vote model ($$Cost = \text{Votes}^2$$), ensuring a more pluralistic distribution of influence.
- **Optimistic Governance Module:** Streamlines operations by assuming validity unless a "veto" is triggered within a 72-hour window.
- **Conviction Voting Module:** Aggregates voter "preference" over time, allowing stakeholders to stake weight toward specific proposals without a fixed deadline.
- **Recursive Subsidiarity Module:** Implements a hierarchical DAO structure, allowing the Root DAO to authorize and fund localized "Hubs" for decentralized decision-making.

### The "Access Control" Engineering Challenge
During the deployment and testing phase of the Recursive Subsidiarity Module, a critical architectural challenge was identified regarding Deployment Context and Access Control.

**The Problem:**

Initially, the Subsidiarity module was deployed internally via the APT_Governance_Hub constructor. In Solidity, msg.sender inside a constructor refers to the account deploying the contract. Consequently, the Governance Hub Contract became the administrative owner of the Subsidiarity module, effectively locking out my (the developer's) wallet from performing direct administrative tasks like registerHub.

**The Solution:**

I refactored the module to support Dependency Injection for administrative privileges. By modifying the constructor to accept an explicit _initialAdmin address, the deployment script was updated to pass the developer's EOA (Externally Owned Account) during the standalone deployment phase.

```
// Refactored Constructor for explicit ownership
constructor(address _initialAdmin) {
    admin = _initialAdmin;
}
```

**Result:**

This fix resolved EVM revert errors and gas estimation failures (where MetaMask previously defaulted to a 21M gas limit due to failed require checks). The module now correctly validates administrative identity, as confirmed by the isAuthorizedHub mapping on the Sepolia network.

**How to Verify Status:**

To check the authorization status of a hub via the terminal, run:

`npx hardhat run scripts/checkStatus.js --network sepolia`

### Deployment Links (Sepolia Testnet)

| Contract | Address | Link |
| :--- | :--- | :--- |
| **Governance Hub** | `0x248285D7aF3F3d1c50EB975e344Dd316f34f17F4` | [View on Etherscan](https://sepolia.etherscan.io/address/0x248285D7aF3F3d1c50EB975e344Dd316f34f17F4#code) |
| **Conviction Voting** | `0x9aA72cFAcCa1bFAd6Fc6c5BE40ccef8F6D8f29F5` | [View on Etherscan](https://sepolia.etherscan.io/address/0x9aA72cFAcCa1bFAd6Fc6c5BE40ccef8F6D8f29F5#code) |
| **Optimistic Governance** | `0x3318F4D54ca1f9aD3641dF8Bdf6953881f1a6e7f` | [View on Etherscan](https://sepolia.etherscan.io/address/0x3318F4D54ca1f9aD3641dF8Bdf6953881f1a6e7f#code) |
| **Optimistic Governance V2** | `0x92801f0ee5d37F7945D8720FDD85617c0cba2f2b` | [View on Etherscan](https://sepolia.etherscan.io/address/0x92801f0ee5d37F7945D8720FDD85617c0cba2f2b#code) |
| **Quadratic Voting** | `0x024Aaa0324abB77a7e3eDF5E6Ef34733D61d2Ff2` | [View on Etherscan](https://sepolia.etherscan.io/address/0x024Aaa0324abB77a7e3eDF5E6Ef34733D61d2Ff2#code) |
| **Recursive Subsidiarity** | `0x980114515E67E1e15Ff139894Db1b5A95432B09f` | [View on Etherscan](https://sepolia.etherscan.io/address/0x980114515E67E1e15Ff139894Db1b5A95432B09f#code) |
| **Recursive Subsidiarity updated** | `0x3abF65bB1D9e798936e6a4Ab92Fd5463EFd9a441` | [View on Etherscan](https://sepolia.etherscan.io/address/0x3abf65bb1d9e798936e6a4ab92fd5463efd9a441#code) |
