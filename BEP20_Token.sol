// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Token_SafeMath.sol";
import "./Interface_BEP20.sol";

//we have this error: "contract BEP20 should be marked as abstract". This error will remain until we insert 
//all the functions from the interface "IBEP20".
contract BEP20 is IBEP20{
   using SafeMath for uint256;//SafeMath is the name of a library.

   string private _name;
   string private _symbol;
   uint8 private _decimal;
   uint256 private _totalsupply;

   mapping (address => uint256) private _balance;
   mapping (address => mapping(address => uint256)) private _allowed;   

   constructor() {
    _name = "MyBepToken";
    _symbol = "MBT";
    _decimal = 5;
    _totalsupply = 2100000000000;
    _balance[msg.sender] = _totalsupply;
   }

   function decimal() external view returns(uint8) {
    return _decimal;
   }
   function totalsupply() external view returns(uint256) {
    return _totalsupply;
   }
   function name() external view returns(string memory) {
    return _name;
   }
   function symbol() external view returns(string memory) {
    return _symbol;
   }
   function getowner() external view returns (address){}
   function balanceof(address account) external view returns(uint256){
    return _balance[account];
   }

    function transfer(address recipient, uint256 amount) external returns(bool){
        require(amount <= _balance[msg.sender]);
        require(recipient != address(0));

        _balance[msg.sender] = _balance[msg.sender].sub(amount);
        _balance[recipient] = _balance[recipient].add(amount);

        emit Transfer(msg.sender, recipient, amount);
        return (true);
    }

    function allowance(address owner, address spender) external view returns(uint256){
        return _allowed[owner][spender];
    }

    function approve(address spender, uint256 value) external returns(bool){
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return(true);
    }
    //This is the function that a spender calls to spend an allowance so msg.sender is the spender.
    function transferfrom(address sender,address recipient,uint256 amount) external returns(bool){
        require(amount <= _balance[sender]);
        require(amount <= _allowed[sender][msg.sender]);
        require(recipient != address(0));

        _balance[sender] = _balance[sender].sub(amount);
        _allowed[sender][msg.sender] = _allowed[sender][msg.sender].sub(amount);
        _balance[recipient] = _balance[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
        return (true);
    }

    
        
     


}
