//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Auction {
    uint256 private s_auctionDuration;
    uint256 private s_startingTime;
    address private immutable i_owner;

    mapping(address => uint256) private s_offeredPrice;
    mapping(address => bool) private s_isBidderOut;
    address[] private s_biddersList; // an array including bidder's addresses

    address private s_winner;
    uint256 private s_lastBid;

    event auctionEnded(address winner, uint256 finalOffer, string theMassage);
    event highestBidIncreased(
        address currentWinner,
        uint256 lastOffer,
        string theMassage
    );
    event auctionStarted(string theMassage);

    constructor() {
        s_auctionDuration = 1 hours;
        s_startingTime = block.timestamp;
        i_owner = msg.sender;
    }

    modifier haveTime() {
        require(
            block.timestamp < s_startingTime + s_auctionDuration,
            " No Auction At the Moment"
        );
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == i_owner, "Access Denied");
        _;
    }

    /*******************/

    //setting up new times for next auction
    function SetNewAuction(
        uint256 week,
        uint256 day,
        string memory theMassage
    ) external onlyOwner {
        require(block.timestamp >= s_startingTime + s_auctionDuration);
        s_lastBid = 0;
        s_winner = address(0);
        uint256 toSeconds = ConvertToSeconds(week, day);
        s_auctionDuration = toSeconds;
        s_startingTime = block.timestamp;
        emit auctionStarted(theMassage);
    }

    function Transfer(address account, uint256 amount) internal {
        (bool sent, ) = payable(account).call{value: amount}("");
        require(sent, "failed to send eth");
    }

    //warning: before bidding first check the last offered price, your offering price should be more.
    function Bid() external payable haveTime {
        require(
            s_offeredPrice[msg.sender] == 0,
            "You've already bid once, if you wanna bid higher use IncreaseBid"
        );
        require(msg.value > s_lastBid, "offer a higher price than current one");
        s_offeredPrice[msg.sender] = msg.value;
        s_biddersList.push(msg.sender);

        s_lastBid = msg.value;
        s_winner = msg.sender;
        emit highestBidIncreased(
            s_winner,
            s_lastBid,
            "Highest Offer is Changed"
        );
    }

    //How much do you wanna raise your bid?
    function IncreaseBid() external payable haveTime {
        require(
            s_offeredPrice[msg.sender] != 0,
            "You,ve not bid before, first use Bid then use this to higher your offer"
        );
        require(
            s_isBidderOut[msg.sender] == false,
            "Sorry, you have canceled your bid"
        );

        s_offeredPrice[msg.sender] += msg.value;
        uint256 newBid = s_offeredPrice[msg.sender];

        if (newBid > s_lastBid) {
            s_lastBid = newBid;
            s_winner = msg.sender;
            emit highestBidIncreased(
                s_winner,
                s_lastBid,
                "Highest Offer is Changed"
            );
        }
    }

    function CancelBid() external haveTime {
        require(
            s_offeredPrice[msg.sender] != 0,
            "You can't use this, you did not bid yet"
        );
        s_isBidderOut[msg.sender] = true;
        if (msg.sender == s_winner) {
            (s_lastBid, s_winner) = getSecondLargeElement();
            emit highestBidIncreased(
                s_winner,
                s_lastBid,
                "Highest Offer is Changed"
            );
        }
    }

    function EndAuction() external onlyOwner {
        require(block.timestamp >= s_startingTime + s_auctionDuration);
        address theWinner = getCurrentWinner();
        Transfer(i_owner, s_offeredPrice[theWinner]); //sends the winner's bid to the owner's account.
        s_offeredPrice[theWinner] = 0;

        for (uint i = 0; i < s_biddersList.length; i++) {
            if (s_biddersList[i] != theWinner) {
                Transfer(s_biddersList[i], s_offeredPrice[s_biddersList[i]]);
                s_offeredPrice[s_biddersList[i]] = 0;
                if (s_isBidderOut[s_biddersList[i]] == true) {
                    s_isBidderOut[s_biddersList[i]] = false;
                }
            }
        }

        s_biddersList = new address[](0); //reseting the array to 0 element
        emit auctionEnded(theWinner, s_lastBid, "The Auction's Time is Up");
    }

    /**************************/
    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getLastBid() public view returns (uint256) {
        return s_lastBid;
    }

    function getCurrentWinner() public view returns (address) {
        return s_winner;
    }

    function getLeftTime()
        public
        view
        haveTime
        returns (uint256 dd, uint256 hh, uint256 mm, uint256 ss)
    {
        uint256 endTime = s_startingTime + s_auctionDuration;
        uint256 leftTime = endTime - block.timestamp;
        dd = leftTime / 1 days;
        hh = (leftTime - dd * 1 days) / 1 hours;
        mm = (leftTime - dd * 1 days - hh * 1 hours) / 1 minutes;
        ss =
            (leftTime - dd * 1 days - hh * 1 hours - mm * 1 minutes) /
            1 seconds;
    }

    function getSecondLargeElement() internal view returns (uint256, address) {
        uint256 thePrice;
        address theAddress;
        for (uint i = 0; i < s_biddersList.length; i++) {
            if (s_isBidderOut[s_biddersList[i]] == false) {
                uint256 offeredPrice = s_offeredPrice[s_biddersList[i]];
                if (offeredPrice > thePrice) {
                    if (offeredPrice != s_lastBid) {
                        thePrice = offeredPrice;
                        theAddress = s_biddersList[i];
                    }
                }
            }
        }
        return (thePrice, theAddress);
    }

    function ConvertToSeconds(
        uint256 week,
        uint256 day
    ) internal pure returns (uint256) {
        uint256 timeInSeconds = week * 1 weeks + day * 1 days;
        return timeInSeconds;
    }
}

// 1- add some condition to prevent mutiple winners. (prevent equal bids) ***DONE*** user interface should warn the bidder in advance
// 2-
// 3-
// 4- write the last function: CancelBid(): **********DONE**********
// 5- How can we reset all variables to use them again for next auction? ***DONE***
// 6- if some address wants to bid for a second time, what should we do? ===>>> I think we should add a function to do this. ****DONE***
// 8- Whenever someone offered a new price, all bidders should be warned: Define an event *********DONE******
// 9- can we change the pop() part to keep the array untouched??????? **********DONE*********
// 10- How to reset the s_winner after ending the auction?????????? **********DONE********

/**11-
 * 12- consider another solution to find the winner (to spend less gas) (and use less storage variables): improved a little ...
 * 13-
 * 14- consider adding an update() (if it's possible) to have a more cleaner code ...
 * 15- setNewAuction: time input should be in seconds. the owner should convert his ideal time to seconds an then put ot into function.
 *     maybe we can automate the conversion here(week,day,hour => second) *************DONE*************
 *
 * 16- Shouldn't we define addresses as payable to receive their money? yes, the address shoud be payable **************DoNE********
 *
 * 17- getTimeLeft should return 4 zero when the time is up, but it's just stuck at the last returns
 * 18- Extending the auction's time???
 *
 *
 */
