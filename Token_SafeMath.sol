// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

library SafeMath{
    //why do we need the Requier?
    //update: because of overflow(or underflow problem): if C becomes greater than max number(256bit) or lesser than min. 
    function Add(uint256 a,uint256 b) internal pure returns (uint256) {
        uint256 c = a+b;
        require(c >= a, "SafeMath: add overflow");
        return c;
    }
    //okay
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
       require(a >= b,"SafeMath: add overflow");
       return a-b;
    }
    //why do we need the Requier? 
    //why do we seprate a==0 from others? update: because the denominator in the requier section can't be zero.
    function multiply(uint256 a,uint256 b) internal pure returns(uint256){
        if(a==0) {
            return 0;
        }
        uint256 c= a*b;
        require(c/a == b,"SafeMath: multiply overflow");
        return c;
    }
    //okay
    function mod(uint256 a, uint256 b) internal pure returns(uint256){
        require(b!=0, "Error");
        return a % b;    
    }
    //how to calculate 2/4 ? the result should be uint...
    function divide(uint256 a, uint256 b) internal pure returns(uint256){
        require(b>0,"Error");
        return a/b;
    }
}
//why there are 2 sub, div and mod functions? (main file)
//why some functions have error massage inputs? (main file)