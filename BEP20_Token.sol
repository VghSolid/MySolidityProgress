// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Token_SafeMath.sol";
import "./Interface_BEP20.sol";
import "./Ownable.sol";
import "./Context.sol";

//we have this error: "contract BEP20 should be marked as abstract". This error will remain until we insert 
//all the functions from the interface "IBEP20".
contract BEP20 is context, IBEP20, ownable {
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
    _balance[_msgSender()] = _totalsupply;
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
   function getowner() external view returns (address){
    return owner();
   }
   function balanceof(address account) external view returns(uint256){
    return _balance[account];
   }

    function transfer(address recipient, uint256 amount) external returns(bool){
        _transfer(_msgSender(), recipient, amount);
        return (true);
    }
    function _transfer(address sender,address recipient, uint256 amount) internal returns(bool){
        require(amount <= _balance[sender],"Not enough balance");
        require(recipient != address(0),"zero address is not acceptable");
        require(sender != address(0),"zero address is not acceptable");

        _balance[sender] = _balance[sender].sub(amount);
        _balance[recipient] = _balance[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
        return (true);
    }
    function allowance(address owner, address spender) external view returns(uint256){
        return _allowed[owner][spender];
    }

    function approve(address spender, uint256 value) external returns(bool){
        _approve(_msgSender(), spender, value);
        return(true);
    }
    function _approve(address owner,address spender, uint256 value) internal returns(bool){
        require(spender != address(0),"zero address is not acceptable");
        require(owner != address(0),"zero address is not acceptable");

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
        return(true);
    }
    //This is the function that a spender calls to spend an allowance so msg.sender is the spender.
    function transferfrom(address sender,address recipient,uint256 amount) external returns(bool){
        require(amount <= _allowed[sender][_msgSender()]);
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowed[sender][_msgSender()].sub(amount));
        return (true);
    }
    //In emit line: why address(0)?
    //mint should be onlyowner.
    function _mint(address account,uint256 amount) internal {
        require(account != address(0));

        _totalsupply = _totalsupply.add(amount);
        _balance[account] = _balance[account].add(amount);

        emit Transfer(address(0), account, amount);
    }
    //In emit line: makes sense to use address(0) for burning.
    function _burn(address account,uint256 amount) internal {
        require(account != address(0));
        require(amount <= _balance[account]);

        _totalsupply = _totalsupply.sub(amount);
        _balance[account] = _balance[account].sub(amount);

        emit Transfer(account, address(0), amount);
    }
    //needs approve function. same as transferfrom.
    function burnfrom(address account, uint256 amount) internal {
        require(amount <= _allowed[account][_msgSender()]);
        _burn(account, amount);
        _allowed[account][_msgSender()] = _allowed[account][_msgSender()].sub(amount);
        emit Approval(account, _msgSender(), _allowed[account][_msgSender()]);
    }
    //This is an anti_cheat for approve function. The cheating technique is called "front-running".
    function increaseAllowance (address spender, uint256 addedvalue) public returns(bool) {
        _approve(_msgSender(), spender, _allowed[_msgSender()][spender].add(addedvalue));
        return(true);
    }
    function decreaseAllowance (address spender, uint256 subedvalue) public returns(bool) {
        require(subedvalue <= _allowed[_msgSender()][spender]);
        _approve(_msgSender(), spender, _allowed[_msgSender()][spender].sub(subedvalue));
        return(true);
    }


    
        
     


}
