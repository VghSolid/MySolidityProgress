//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Auction} from "../src/Auction.sol";

contract DeployAuction is Script {
    function run() public returns (Auction) {
        vm.startBroadcast();
        Auction auction = new Auction();
        vm.stopBroadcast();
        return auction;
    }
}
