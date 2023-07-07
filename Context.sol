// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract context{
    function _msgSender() internal view returns(address) {
        return msg.sender;
    }
    //what's the goal of line 10?
    function _msgData() internal view  returns(bytes memory) {
        address(this);
        return msg.data;
    }  
}