//SPDX-License-Identifier: MIT
pragma solidity >0.8.0 <0.9.0;

import "./Context.sol";
import "./AccessControl.sol";

contract MultiSend is context,AccessControl{
    //emp: employee
    address [] private _emplist;
    mapping (string => address) private _Addrs;
    mapping (address => uint256) private _Index; 

    //roles defenition
    bytes32 constant public worker = keccak256("worker");
    bytes32 constant public engineer = keccak256("engineer");

    //give each role an admin to rule them all.
    constructor() {
        _roles[0x00].adminRole = 0x00;
        _roles[worker].adminRole = 0x00;
        _roles[engineer].adminRole = 0x00;
        _roles[0x00].members[_msgSender()] = true;
    }

    /*----------------------------------- Functions ----------------------------*/

    //For employees to add their wallet address to the mapping.
    function addyourAddrs(string name) public {
        _Addrs[name] = _msgSender();
    }
    
    //give the emp a role | add it to the dynamic array | give its address an index.
    function addEmployee(bytes32 role, string name) public onlyRole(getRoleAdmin(role)){
        address account = _Addrs[name];

        _grantRole(role, account);

        _emplist.push(account);

        uint256 index = _emplist.length - 1;
        _Index[account] = index;
    }

    // revoke emp's role | replace its address from the array with the last element | update all mappings. 
    function removeEmployee (bytes32 role ,string memory name) public onlyRole(getRoleAdmin(role)) {
        address account = _Addrs[name];
        _revokeRole(role, account);

        uint256 index = _Index[account];
        address lastEmp = _emplist[_emplist.length-1];
        _emplist[index] = lastEmp;
       _Index[lastEmp] = index;
       _emplist.pop();
       //next we should remove the employee from the mappings. how?
    }


    function transferSalary (uint256 _amount) public onlyBoss() {
        for (uint256 i=0; i<= list.length; i++) {
            _emplist[i].call{value: _amount}("");
        }
    } 




}
/*what to add:
1- Remove someone from the list based on their name. ---------[DONE]
+ how to update index of other members? /solved by Remix_Multisend / ---------[DONE]
+ how to remove them from mapping? / we can use "delete", but it sets the value of mapping to zero. we already 
  have zero an an index. what should we do? 
   
2- Employess get different amount of salary. how to implemnt that? I think defining roles can be the solution.
3- Use access control to add onlyEmployee and onlyBoss. how to add roles? -------[DONE]
*/



