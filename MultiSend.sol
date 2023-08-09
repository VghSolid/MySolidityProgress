//SPDX-License-Identifier: MIT
pragma solidity >0.8.0 <0.9.0;

import "./Context.sol";
import "./AccessControl.sol";

contract MultiSend is context,AccessControl{
    //emp: employee
    struct Data{
        uint256 index;
    }
    address [] private _emplist;
    mapping (address => Data) private map; 
    mapping (string => address) private addrs;

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

    //For employees to add their wallet address to the mapping. (write your name like this: Ali Ahmadi)
    function addyourdata(string name) public {
        addrs[name] = _msgSender();
    }
    
    //give the emp a role | add it to the dynamic array | give its address an index.
    function addEmployee(bytes32 role, string name) public onlyRole(getRoleAdmin(role)){
        address account = addrs[name];
        Data storage data = map[account];

        require(data.index == 0,"This account already exists");

        _grantRole(role, account);

        _emplist.push(account);

        uint256 realIndex = _emplist.length - 1;
        data.index = realIndex + 1;
    }

    // revoke emp's role | replace its address from the array with the last element | update all mappings. 
    function removeEmployee (bytes32 role ,string memory name) public onlyRole(getRoleAdmin(role)) {
        address account = addrs[name];
        Data storage data = map[account];

        require(data.index != 0,"This account does not exist");

        _revokeRole(role, account);

        uint256 realIndex= data.index -1;
        address lastEmp = _emplist[_emplist.length -1];
        _emplist[realIndex] = lastEmp;

        //update the index of lastEmp
        map[lastEmp].index = data.index;

        //remove the last element of array(lastemp)
        _emplist.pop();

        //remove the index of removed employee;
        data.index = 0;
    }

    function empNumbers() public view returns(uint256){
        return _emplist.length;
    }

    function transferSalary (uint256 _amount) public onlyBoss() { //next: can we divide employees by their roles?
        for (uint256 i=0; i<= list.length; i++) {                 // and give each different salaries.
            _emplist[i].call{value: _amount}("");
        }
    } 




}
/*what to add:
1- Remove someone from the list based on their name. ---------[DONE]
+ how to update index of other members? /solved by Remix_Multisend / ---------[DONE]
+ how to remove them from mapping? / we can use "delete", but it sets the value of mapping to zero. we already 
  have zero an an index. what should we do? ---------- [DONE] 
   
2- Employess get different amount of salary. how to implemnt that? I think defining roles can be the solution.
3- Use access control to add onlyEmployee and onlyBoss. how to add roles? -------[DONE]
*/



