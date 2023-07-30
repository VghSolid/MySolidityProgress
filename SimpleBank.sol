//SPDX-License-Identifier: MIT
pragma solidity >0.8.0 <0.9.0;

//Any address can deposit and withdraw eth whit this contract. 
contract SimpleBank{
   
    mapping (address => uint256) private _balance;
    event Transfer(string transaction);

    function deposit() public payable{
        emit Transfer("deposit transaction");
        _balance[msg.sender] =_balance[msg.sender] + msg.value;
    } 

    function withdraw(uint256 _amount) public payable  {
        require(_balance[msg.sender] > _amount,"insufficiant fund");

        (bool success,) = msg.sender.call{value: _amount}("");
        require(success==true,"Failed to send");

        _balance[msg.sender] = _balance[msg.sender]- _amount;
        emit Transfer("withdraw transaction");
    }
    function getBalance(address account) public view returns(uint256){
        return _balance[account];
    }
    
}   