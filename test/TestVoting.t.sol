//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployVoting} from "script/DeployVoting.s.sol";
import {Voting} from "src/Voting.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract TestAuction is Test {
    Voting voting;
    string[] candidateNames = ["ali", "mohammad", "shahram", "bahram"];

    function setUp() external {
        DeployVoting deployVoting = new DeployVoting();
        voting = deployVoting.run(candidateNames);
    }

    function test_giveRightToVoters() public {
        vm.startPrank(voting.getTheManager());
        for (uint160 i = 1; i < 100; i++) {
            voting.giveRightToVote(address(i));
        }
        vm.stopPrank();
        assertEq(voting.getVoters(address(99)).weight, 2);
    }

    function test_vote() public {
        vm.warp(0);
        vm.startPrank(voting.getTheManager());
        for (uint160 i = 0; i < 70; i++) {
            voting.giveRightToVote(address(i));
        }
        vm.stopPrank();

        for (uint160 i = 0; i < 10; i++) {
            vm.startPrank(address(i));
            uint256 index = voting.getCandidateID("ali");
            voting.Vote(index);
            vm.stopPrank();
        }
        for (uint160 i = 10; i < 30; i++) {
            vm.startPrank(address(i));
            uint256 index = voting.getCandidateID("mohammad");
            voting.Vote(index);
            vm.stopPrank();
        }
        for (uint160 i = 30; i < 50; i++) {
            vm.startPrank(address(i));
            uint256 index = voting.getCandidateID("shahram");
            voting.Vote(index);
            vm.stopPrank();
        }
        for (uint160 i = 50; i < 70; i++) {
            vm.startPrank(address(i));
            uint256 index = voting.getCandidateID("bahram");
            voting.Vote(index);
            vm.stopPrank();
        }

        skip(500);
        console.log(voting.getCandids(0).countedVote);
        console.log(voting.getCandids(1).countedVote);
        console.log(voting.getCandids(2).countedVote);
        console.log(voting.getCandids(3).countedVote);
        vm.prank(voting.getTheManager());
        voting.EndVoting();
        console.log(voting.getWinners()[1]);
    }

    function test_vote_delegation() public {
        vm.startPrank(voting.getTheManager());
        for (uint160 i = 1; i < 40; i++) {
            voting.giveRightToVote(address(i));
        }
        vm.stopPrank();

        vm.prank(address(16));
        voting.Vote(0);
        vm.prank(address(15));
        voting.delegate(address(16));

        assertEq(voting.getVoters(address(16)).weight, 1);
        assertEq(voting.getCandids(0).countedVote, 2);
    }
}
