//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

contract Voting {
    address private immutable i_manager;
    uint256 private s_endTime;

    mapping(address => bool) private s_voted;
    s_candidateInfo[] private s_candidatesList;
    struct s_candidateInfo {
        bytes32 name;
        uint256 countedVote;
    }

    modifier onlymanager() {
        require(msg.sender == i_manager, "Access Denied");
        _;
    }
    modifier haveTime() {
        require(block.timestamp < s_endTime, "voting is ended");
        _;
    }
    modifier votingEnded() {
        require(block.timestamp > s_endTime, "voting is not ended");
        _;
    }

    /** ************************ */

    constructor() {
        i_manager = msg.sender;
        s_endTime = block.timestamp + 5 days;
    }

    function AddCandidate(string memory name) public onlymanager {
        s_candidateInfo memory candidates;
        candidates.name = stringToBytes32(name);
        s_candidatesList.push(candidates);
    }

    //get your candidate's ID then go vote him/her.
    function getCandidateID(
        string memory name
    ) public view haveTime returns (uint256) {
        s_candidateInfo memory candidate;
        uint256 index;
        for (uint256 i = 0; i < s_candidatesList.length; i++) {
            candidate = s_candidatesList[i];
            if (candidate.name == stringToBytes32(name)) {
                index = i;
            }
        }
        return index;
    }

    //you need to know the ID of your desired candidate
    function Vote(uint256 candidateID) public haveTime {
        require(!s_voted[msg.sender], "you have already voted");
        s_candidateInfo storage candidate;
        candidate = s_candidatesList[candidateID];
        candidate.countedVote++;
        s_voted[msg.sender] = true;
    }

    function getTheWinner()
        public
        view
        votingEnded
        returns (string memory, uint256, uint256)
    {
        uint256 maxVote;
        uint256 winnerID;
        string memory winner;
        s_candidateInfo memory candidate;
        for (uint256 i = 0; i < s_candidatesList.length; i++) {
            candidate = s_candidatesList[i];
            if (candidate.countedVote > maxVote) {
                maxVote = candidate.countedVote;
                winnerID = i;
            }
        }
        candidate = s_candidatesList[winnerID];
        winner = string(abi.encodePacked(candidate.name));
        return (winner, winnerID, maxVote);
    }

    function stringToBytes32(
        string memory name
    ) internal pure returns (bytes32) {
        bytes32 output = bytes32(abi.encodePacked(name));
        return output;
    }
}

/**
 * 1- add a function to show the names of candidates
 * 2- add a function to show the remaning time
 */
