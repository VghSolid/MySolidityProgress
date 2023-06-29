// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
//okay
interface IBEP20 {
  
  function totalSupply() external view returns (uint256);

 
  function decimals() external view returns (uint8);

 
  function symbol() external view returns (string memory);

  
  function name() external view returns (string memory);

  
  function getOwner() external view returns (address);

 
  function balanceOf(address account) external view returns (uint256);


  function transfer(address recipient, uint256 amount) external returns (bool);


  function allowance(address _owner, address spender) external view returns (uint256);


  function approve(address spender, uint256 amount) external returns (bool);


  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


  event Transfer(address indexed from, address indexed to, uint256 value);


  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/******************* */
//why creating this contract?? update1: seems like we shouldn't use msg.sender & msg.data directly but why?
/*update2: based on OpenZeppelin version of this contract, it's related to meta-transactions. The actual sender
and the paying address may differ*/

contract Context {
  
  constructor () internal { }

  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; 
    return msg.data;
  }
}
/*********************** */
//okay
library SafeMath {
  
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }


  function mul(uint256 a, uint256 b) internal pure returns (uint256){
    
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

 
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;

    return c;
  }

 
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

 
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

/****************************************** ******************/
//so with this contract we can change the owner of token. It's related to minting new tokens.
//why not using msg.sender instead of Context? 
contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  
  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  
  function owner() public view returns (address) {
    return _owner;
  }

  
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

 
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}
/************************************************* */

contract BEP20Token is Context, IBEP20, Ownable {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;
  uint8 private _decimals;
  string private _symbol;
  string private _name;

  constructor() public {
    _name = {{TOKEN_NAME}};
    _symbol = {{TOKEN_SYMBOL}};
    _decimals = {{DECIMALS}};
    _totalSupply = {{TOTAL_SUPPLY}};
    _balances[msg.sender] = _totalSupply;

    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  
  function getOwner() external view returns (address) {
  }

  
  function decimals() external view returns (uint8) {
  }

  
  function symbol() external view returns (string memory) {
  }

  
  function name() external view returns (string memory) {
  }

  
  function totalSupply() external view returns (uint256) {
  }

  
  function balanceOf(address account) external view returns (uint256) {
  }

  
  function transfer(address recipient, uint256 amount) external returns (bool) {
  }

  
  function allowance(address owner, address spender) external view returns (uint256) {
  }

  
  function approve(address spender, uint256 amount) external returns (bool) {
  }

  
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
  }
  
  function mint(uint256 amount) public onlyOwner returns (bool) {
    
  }

  function burn(address account, uint256 amount) internal {
    
  }

 
  function burnFrom(address account, uint256 amount) internal {
    
  }
}
