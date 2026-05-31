// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    struct Proposal {
        string name;
        uint voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson, "Only chairperson can authorize.");
        require(!voters[voter].voted, "Already voted.");
        require(!voters[voter].authorized, "Already authorized.");
        voters[voter].authorized = true;
    }

    function vote(uint proposalIndex) public {
        require(voters[msg.sender].authorized, "Not authorized to vote.");
        require(!voters[msg.sender].voted, "You have already voted!");
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = proposalIndex;
        proposals[proposalIndex].voteCount += 1;
    }

    function winningProposal() public view returns (uint winningIndex) {
        uint highestVotes = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > highestVotes) {
                highestVotes = proposals[i].voteCount;
                winningIndex = i;
            }
        }
    }

    function winnerName() public view returns (string memory) {
        return proposals[winningProposal()].name;
    }
}