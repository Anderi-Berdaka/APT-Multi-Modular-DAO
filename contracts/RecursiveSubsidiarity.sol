// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// The Local Hub (The Child)
contract LocalHub {
    address public rootDAO; // In this child contract, the "boss" is the Root DAO
    uint256 public localBudget;
    mapping(string => uint256) public expenses;

    constructor(address _rootDAO) {
        rootDAO = _rootDAO;
    }

    function receiveFunding() external payable {
        require(msg.sender == rootDAO, "Only Root can fund");
        localBudget += msg.value;
    }

    function spendLocal(string memory _reason, uint256 _amount) external {
        require(_amount <= localBudget, "Not enough local budget");
        localBudget -= _amount;
        expenses[_reason] = _amount;
    }
}

// The Main Module
contract RecursiveSubsidiarity {
    address public admin;
    mapping(address => bool) public isAuthorizedHub;

    // I updated this so I can pass my wallet address when deploying standalone
    constructor(address _initialAdmin) {
        admin = _initialAdmin;
    }

    function registerHub(address _hubAddress) external {
        require(msg.sender == admin, "Only admin can register hubs");
        isAuthorizedHub[_hubAddress] = true;
    }

    function fundHub(address payable _hubAddress) external payable {
        require(isAuthorizedHub[_hubAddress], "Not an authorized hub");
        LocalHub(_hubAddress).receiveFunding{value: msg.value}();
    }
}