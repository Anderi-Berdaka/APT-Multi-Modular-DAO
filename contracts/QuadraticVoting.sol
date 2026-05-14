// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract QuadraticVoting {
    mapping(address => uint256) public voiceCredits;
    mapping(uint256 => uint256) public proposalVotes;
    mapping(address => mapping(uint256 => bool)) public voted;

    constructor(address[] memory voters, uint256[] memory credits) {
        for (uint i = 0; i < voters.length; i++) {
            voiceCredits[voters[i]] = credits[i];
        }
    }

    function vote(uint256 proposalId, uint256 numberOfVotes) external {
        uint256 cost = numberOfVotes * numberOfVotes; 
        require(voiceCredits[msg.sender] >= cost, "Not enough credits");
        require(!voted[msg.sender][proposalId], "Already voted");

        voiceCredits[msg.sender] -= cost;
        proposalVotes[proposalId] += numberOfVotes;
        voted[msg.sender][proposalId] = true;
    }

    function getProposalVotes(uint256 proposalId) public view returns (uint256) {
        return proposalVotes[proposalId];
    }
}
