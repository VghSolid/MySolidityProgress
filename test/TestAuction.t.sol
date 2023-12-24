//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";
import {DeployAuction} from "../script/DeployAuction.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract TestAuction is Test {
    Auction auction; //we wanna test auction so I define an instance of auction
    uint256 constant USER_STARTING_BALANCE = 100 ether;
    address user = makeAddr("user");
    uint256 constant SEND_VALUE = 5 ether;

    //setUp is invoked before any test functions
    function setUp() public {
        DeployAuction deployAuction = new DeployAuction();
        auction = deployAuction.run();
    }

    //multiple bidd, increasing and canceling
    function test_Auction() public {
        uint160 numberOfBidders = 10;
        uint160 startingIndex = 1;
        uint256 send_Value;
        for (
            uint160 i = startingIndex;
            i < numberOfBidders + startingIndex;
            i++
        ) {
            hoax(address(i), USER_STARTING_BALANCE);
            send_Value += 1 ether;
            auction.Bid{value: send_Value}();
        }

        vm.startPrank(address(8));
        auction.IncreaseBid{value: 6 ether}();
        auction.CancelBid();
        vm.stopPrank();

        console.log(auction.getCurrentWinner());
        console.log(auction.getLastBid());
    }

    function test_EndAuction() public {
        vm.warp(0);

        uint160 numberOfBidders = 9;
        uint160 startingIndex = 1;
        uint256 send_Value;
        for (
            uint160 i = startingIndex;
            i < numberOfBidders + startingIndex;
            i++
        ) {
            hoax(address(i), USER_STARTING_BALANCE);
            send_Value += 1 ether;
            auction.Bid{value: send_Value}();
        }

        skip(4000);
        vm.prank(auction.getOwner());
        auction.EndAuction();

        console.log(auction.getCurrentWinner());
        console.log(auction.getLastBid());
    }

    modifier prep_user() {
        vm.deal(user, USER_STARTING_BALANCE);
        vm.prank(user);
        _;
    }

    //shows the winner
    function test_SingleBidder() public prep_user {
        uint256 startGas = gasleft();
        vm.txGasPrice(1); // setting up the price of gas. (when using anvil the default gasprice is 0 (forked or not))
        auction.Bid{value: SEND_VALUE}();
        uint256 endGas = gasleft();
        uint256 gasUsed = (startGas - endGas) * tx.gasprice;

        console.log(auction.getLastBid());
        console.log(auction.getCurrentWinner());
        console.log(gasUsed);
    }

    //auction time is not over so test passes
    function test_CanOwnerEndAuction() public prep_user {
        auction.Bid{value: SEND_VALUE}();

        vm.expectRevert();
        auction.EndAuction();
    }
}
