// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Context.sol";

contract ownable is context{
    address private _owner;
    address private deployer;

    event OwnershipTransfered(address indexed previousowner, address indexed newowner);

    constructor () {
        deployer = _msgSender();
        _owner = deployer;

        emit OwnershipTransfered(address(0), deployer);
    }

    function owner() public view returns(address){
        return _owner;
    }

    modifier onlyowner() {
        require(_owner == _msgSender(),"you're not allowed");
        _;
    }

    function renounceownership() public onlyowner(){
        _owner= address(0);
        emit OwnershipTransfered(_owner,address(0));
    }

    function _transferownership(address newowner) internal onlyowner(){
        require(newowner != address(0), "not acceptable");
        _owner = newowner;
        emit OwnershipTransfered(_owner, newowner);
    }
    function transferownership(address newowner) public onlyowner(){
        _transferownership(newowner);
    }
}