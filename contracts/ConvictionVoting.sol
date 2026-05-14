// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ConvictionVoting {
    struct Proposal {
        string description;
        uint256 stakedAmount;
        uint256 convictionAtLastUpdate;
        uint256 lastUpdateBlock;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public constant THRESHOLD = 1000; // Power needed to pass

    function createProposal(string memory _description) external {
        proposalCount++;
        proposals[proposalCount].description = _description;
        proposals[proposalCount].lastUpdateBlock = block.number;
    }

    function stake(uint256 _proposalId, uint256 _amount) external {
        updateConviction(_proposalId);
        proposals[_proposalId].stakedAmount += _amount;
    }

    function updateConviction(uint256 _proposalId) public {
        Proposal storage p = proposals[_proposalId];
        if (p.executed) return;

        // Conviction = Previous + (Amount * Blocks passed)
        // This rewards the DURATION of the stake
        uint256 blocksPassed = block.number - p.lastUpdateBlock;
        p.convictionAtLastUpdate += (p.stakedAmount * blocksPassed);
        p.lastUpdateBlock = block.number;
    }

    function execute(uint256 _proposalId) external {
        updateConviction(_proposalId);
        require(proposals[_proposalId].convictionAtLastUpdate >= THRESHOLD, "Not enough conviction yet");
        require(!proposals[_proposalId].executed, "Already executed");

        proposals[_proposalId].executed = true;
    }
}