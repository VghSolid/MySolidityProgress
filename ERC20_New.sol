// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import "./Context.sol";
import "./IERC20.sol";
import "./draft-IERC6093.sol";

//This ERC20 token contract instead of "revert reason strings" (like require()) uses ERC20 Errors.
//No need for SafeMath library because newer versions of solidity handles under/over flows.
//using "unchecked" reduces gas significantly.
//This code excluses IERC20Metadata(because I don't know it)

abstract contract ERC20_new is context,IERC20, IERC20Errors {
    mapping(address => uint256) _balance;
    mapping(address => mapping(address => uint256)) _allowance;

    string private _name;
    string private _symbol;
    uint256 private _totalsupply;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    } 

    function name() public view virtual returns(string memory){
        return _name;
    }
    function symbol() public view virtual returns(string memory){
        return _symbol;
    }

    function decimal() public view virtual returns (uint8){
        return 18;
    }

    function totalsupply() public view virtual returns(uint256) {
        return _totalsupply;
    }

    function balanceof(address who) public view virtual returns(uint256){
        return _balance[who];
    }

    function transfer(address recipient, uint256 amount) public virtual returns(bool) {
        address sender = _msgSender();
        _transfer(sender,recipient,amount);
        return(true);
    }

    function _transfer(address from, address to, uint256 amount) internal  {
        if(from == address(0)){
            revert ERC20InvalidSender(address(0));
        }
        if(to == address(0)){
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, amount);
    }

    function _burn(address account, uint256 amount) internal {
        if(account == address(0)){
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), amount);
    }  

    function _mint(address account, uint256 amount) internal {
        if(account == address(0)){
            revert ERC20InvalidReceiver(address(0)); 
        }
        _update(address(0), account, amount);

    }

    function _update(address from, address to, uint256 amount) internal virtual {
        if(from == address(0)){
            _totalsupply += amount;

            }else{

            uint256 fromBalance = _balance[from];
            if(fromBalance < amount){
                revert ERC20InsufficientBalance(from, fromBalance, amount);
            }
            unchecked {
                _balance[from] = fromBalance- amount;

            }
        }

        if(to == address(0)){
            unchecked {
                _totalsupply -= amount;

            }

          }else{

            unchecked {
                _balance[to] += amount;
                
            }
        }
        emit Transfer(from, to, amount);

    }

    function allowance(address owner,address spender) public virtual view returns (uint256) {
        return _allowance[owner][spender];
    }

    function approve(address spender, uint256 value) public virtual returns(bool){
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    function _approve(address owner, address spender, uint256 value) internal virtual{
        _approve(owner, spender, value, true);
    }
    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if(owner == address(0)){
            revert ERC20InvalidApprover(address(0));
        }
        if(spender == address(0)){
            revert ERC20InvalidSpender(address(0));
        }
        _allowance[owner][spender] = value;
        if(emitEvent == true){
            emit Approval(owner, spender, value);
        }


    }

    function transferfrom(address sender, address recipient, uint256 amount) public virtual returns(bool) {
        address spender = _msgSender();
        _spendAllowance(sender, spender, amount);
        _transfer(sender, recipient, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if(currentAllowance != type(uint256).max){
            if(currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance-value, false);
            }
        }
    }
}