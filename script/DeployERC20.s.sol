//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MyFirstToken} from "../src/ERC20.sol";

contract DeployERC20 is Script {
    function run() external {
        vm.startBroadcast();
        new MyFirstToken();
        vm.stopBroadcast();
    }
}
