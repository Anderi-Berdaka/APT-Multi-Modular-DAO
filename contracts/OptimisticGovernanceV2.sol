// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract OptimisticGovernanceV2 {
    // Added "Cancelled" to the status list
    enum Status { Pending, Passed, Vetoed, Cancelled }

    struct Proposal {
        string description;
        uint256 deadline;
        Status status;
        address proposer;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public constant CHALLENGE_PERIOD = 3 days;
    address public vetoAuthority;

    constructor(address _vetoAuthority) {
        vetoAuthority = _vetoAuthority;
    }

    function createProposal(string memory _description) external {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            deadline: block.timestamp + CHALLENGE_PERIOD,
            status: Status.Pending,
            proposer: msg.sender
        });
    }

    // NEW: Allow the person who made the proposal to cancel it
    function cancel(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];
        require(msg.sender == p.proposer, "Only the proposer can cancel");
        require(p.status == Status.Pending, "Can only cancel pending proposals");

        p.status = Status.Cancelled;
    }

    function veto(uint256 _proposalId) external {
        require(msg.sender == vetoAuthority, "Only Veto Authority can object");
        require(proposals[_proposalId].status == Status.Pending, "Proposal not pending");
        require(block.timestamp < proposals[_proposalId].deadline, "Challenge period over");

        proposals[_proposalId].status = Status.Vetoed;
    }

    function execute(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp >= p.deadline, "Challenge period still active");
        require(p.status == Status.Pending, "Proposal cannot be executed");

        p.status = Status.Passed;
    }
}