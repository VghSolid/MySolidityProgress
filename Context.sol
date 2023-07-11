// SPDX-License-Identifier: MIT
pragma solidity >0.8.4 <0.9.0;

abstract contract context{
    function _msgSender() internal view virtual returns(address) {
        return msg.sender;
    }
    //what's the goal of line 10?
    function _msgData() internal view virtual returns(bytes calldata) {
        return msg.data;
    }  
}