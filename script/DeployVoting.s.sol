//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Voting} from "src/Voting.sol";

contract DeployVoting is Script {
    function run(string[] memory names) external returns (Voting) {
        vm.startBroadcast();
        Voting voting = new Voting(names);
        vm.stopBroadcast();
        return voting;
    }
}
