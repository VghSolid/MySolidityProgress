//SPDX-License-Identifier: MIT
pragma solidity >0.8.4 <0.9.0;

import "./ERC20_New.sol";

contract MyFirstToken is ERC20_new{
    constructor() ERC20_new("MyERC20Token","MET"){
        _mint(_msgSender(), 21000000000000000000000000);
    }
    
}



