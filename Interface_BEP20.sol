// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface IBEP20{
    function name() external view returns(string memory);

    function symbol() external view returns(string memory);

    function decimal() external view returns(uint8);    

    function getowner() external view returns(address);
    /*-------------------------------------------------*/
    function totalsupply() external view returns(uint256);

    function balanceof(address who) external view returns(uint256);

    function transfer(address recipient, uint256 amount) external returns(bool);

    function approve(address spender, uint256 value) external returns(bool);

    function allowance(address owner, address spender) external view returns(uint256);
    
    function transferfrom(address sender, address recipient, uint256 amount) external returns(bool);
    /*----------------------------------------------------------------------------------------------*/
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    event Approval(address indexed owner, address indexed spender, uint256 value);
    

    


}
