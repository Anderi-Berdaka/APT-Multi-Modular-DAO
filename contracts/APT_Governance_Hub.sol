// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./QuadraticVoting.sol";
import "./OptimisticGovernance.sol";
import "./OptimisticGovernanceV2.sol";
import "./ConvictionVoting.sol";
import "./RecursiveSubsidiarity.sol";

contract APT_Governance_Hub {
    address public admin;
    
    address public quadraticVoting;
    address public optimisticV1;
    address public optimisticV2;
    address public convictionVoting;
    address public recursiveSubsidiarity;

    constructor() {
        admin = msg.sender;

        // 1. Quadratic Voting: Expects (address[] voters, uint256[] credits)
        // I initialize it giving me (the admin) 100 credits to start.
        address[] memory initialVoters = new address[](1);
        initialVoters[0] = admin;
        uint256[] memory initialCredits = new uint256[](1);
        initialCredits[0] = 100;
        
        QuadraticVoting qv = new QuadraticVoting(initialVoters, initialCredits);
        quadraticVoting = address(qv);

        // 2. Optimistic Governance: Expects only (address _vetoAuthority)
        // Note: The 3-day period is already hardcoded inside the contract.
        OptimisticGovernance og1 = new OptimisticGovernance(admin);
        optimisticV1 = address(og1);

        // 3. Optimistic Governance V2: Expects only (address _vetoAuthority)
        OptimisticGovernanceV2 og2 = new OptimisticGovernanceV2(admin);
        optimisticV2 = address(og2);

        // 4. Conviction Voting: Expects NO arguments (threshold is constant 1000)
        ConvictionVoting cv = new ConvictionVoting();
        convictionVoting = address(cv);

        // 5. Recursive Subsidiarity: Expects NO arguments
        RecursiveSubsidiarity rs = new RecursiveSubsidiarity(msg.sender);
        recursiveSubsidiarity = address(rs);
    }

    function updateModule(uint8 _type, address _newAddress) external {
        require(msg.sender == admin, "Only admin");
        if (_type == 0) quadraticVoting = _newAddress;
        else if (_type == 1) optimisticV1 = _newAddress;
        else if (_type == 2) optimisticV2 = _newAddress;
        else if (_type == 3) convictionVoting = _newAddress;
        else if (_type == 4) recursiveSubsidiarity = _newAddress;
    }
}