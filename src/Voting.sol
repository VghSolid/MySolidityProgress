//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

contract Voting {
    address private immutable i_manager;
    uint256 private s_endTime;

    mapping(address => s_voter) private s_voters;
    s_candidate[] private s_candidatesList;

    struct s_voter {
        bool voted;
        uint256 weight;
        address delegate;
        uint256 vote;
    }

    struct s_candidate {
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

    constructor(string[] memory candidateNames) {
        i_manager = msg.sender;
        s_voters[i_manager].weight = 1;
        s_endTime = block.timestamp + 5 minutes;
        s_candidate memory candidate;
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidate.name = stringToBytes32(candidateNames[i]);
            s_candidatesList.push(candidate);
        }
    }

    function getCandidateNames()
        public
        view
        haveTime
        returns (string[] memory)
    {
        string[] memory candidNames = new string[](s_candidatesList.length);
        uint256 j;
        for (uint256 i = 0; i < s_candidatesList.length; i++) {
            bytes32 candidNames_ = s_candidatesList[i].name;
            candidNames[j] = string(abi.encodePacked(candidNames_));
            j++;
        }
        return candidNames;
    }

    //It's better to add voters in one call with an array. In case of mass-voting we have problems.
    function giveRightToVote(address voter) public haveTime onlymanager {
        require(!s_voters[voter].voted, "the address is voted");
        require(s_voters[voter].weight == 0);
        s_voters[voter].weight = 1;
    }

    function delegate(address to) public haveTime {
        s_voter storage sender = s_voters[msg.sender];
        require(sender.weight != 0, "you don't have the right to vote");
        require(!sender.voted, "you already voted");
        require(to != msg.sender, "self-delegation is not allowed");
        require(
            s_voters[to].weight >= 1,
            "target address has no right to vote"
        );

        while (s_voters[to].delegate != address(0)) {
            to = s_voters[to].delegate;
            require(to != msg.sender, "found loop in delegation");
        }
        s_voter storage delegated = s_voters[to];

        sender.voted = true;
        sender.delegate = to;

        if (delegated.voted) {
            s_candidatesList[delegated.vote].countedVote += sender.weight;
        } else {
            delegated.weight += sender.weight;
        }
    }

    //First get your candidate's ID then go vote him/her.
    function getCandidateID(
        string memory name
    ) public view haveTime returns (uint256) {
        s_candidate memory candidate;
        uint256 index;
        for (uint256 i = 0; i < s_candidatesList.length; i++) {
            candidate = s_candidatesList[i];
            if (candidate.name == stringToBytes32(name)) {
                index = i;
            }
        }
        return index;
    }

    //Before voting you need to know the ID of your desired candidate
    function Vote(uint256 candidateID) public haveTime {
        s_voter storage sender = s_voters[msg.sender];
        require(!sender.voted, "you have already voted");
        require(sender.weight != 0, "you don't have the right to vote");
        sender.vote = candidateID;
        s_candidatesList[candidateID].countedVote += sender.weight;
        s_voters[msg.sender].voted = true;
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
        s_candidate memory candidate;
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

    function getTheManager() public view returns (address) {
        return i_manager;
    }

    function getVoters(address voter) public view returns (s_voter memory) {
        return s_voters[voter];
    }

    function getCandids(
        uint256 index
    ) public view returns (s_candidate memory) {
        return s_candidatesList[index];
    }

    function stringToBytes32(
        string memory name
    ) internal pure returns (bytes32) {
        bytes32 output = bytes32(abi.encodePacked(name));
        return output;
    }
}

/**
 * 1- add a function to show the names of candidates *****DONE*****
 * 3- this contract is not suited for mass votings
 * 4- how to collect voters' addresses in one array(or ??) and prevent double address entry by user
 * 5-
 */
