//SPDX-License-Identifier: MIT
pragma solidity >0.8.0 <0.9.0;

import "./Context.sol";
import "./AccessControl.sol";
/*This project did not work as I expected but as result I learned:
1- How to remove(not delete) an item form an array based on its address(we don't know the index).
2- How to inherit and use AccessControl.sol 
*/
// I wrote another code for this priject(MultiSendII). Remember you learn through these mistakes. 
contract MultiSend is context,AccessControl{
    //emp: employee
    struct Data{
        uint256 index;
        bytes32 role;
    }
    uint256 private ContractBalance; 
    address private owner;

    address payable [] public _emplist;
    mapping (address => Data) public map; 
    mapping (string => address payable) public addrs;

    modifier onlyAdmin {
        require(_msgSender() == owner,"Access Denied");
        _;
    }

    //--------------------------- Role Defenition --------------------------------
    
    bytes32 constant public worker = keccak256("worker");
    bytes32 constant public engineer = keccak256("engineer");

    //give each role an admin to rule them all.
    constructor() {
        owner = _msgSender();
        _setupRole(Default_Admin_Role, _msgSender());
        _setupAdminRole(Default_Admin_Role, Default_Admin_Role);
        _setupAdminRole(worker, Default_Admin_Role);
        _setupAdminRole(engineer, Default_Admin_Role);
    }

    /*----------------------------------- Functions ----------------------------*/

    //For employees to add their wallet address to the mapping. (write your name like this: Ali Ahmadi)
    function addyourdata(string memory name) public {
        addrs[name] = payable(_msgSender());
    }
    
    //give the emp a role | add it to the dynamic array | give its address  an index.
    function addEmployee(bytes32 role, string memory name) public onlyRole(getRoleAdmin(role)){
        address payable account = addrs[name];
        Data storage data = map[account];

        require(data.index == 0,"This account already exists");

        _grantRole(role, account);
        data.role = role;

        _emplist.push(account);

        uint256 realIndex = _emplist.length - 1;
        data.index = realIndex + 1;
    }

    // revoke emp's role | replace its address  from the array with the last element | update all mappings. 
    function removeEmployee (bytes32 role ,string memory name) public onlyRole(getRoleAdmin(role)) {
        address payable account = addrs[name];
        Data storage data = map[account];

        require(data.index != 0,"This account does not exist");

        _revokeRole(role, account);
        //how to remove data.role?

        uint256 realIndex= data.index -1;
        address payable lastEmp = _emplist[_emplist.length -1];
        _emplist[realIndex] = lastEmp;

        //update the index of lastEmp
        map[lastEmp].index = data.index;

        //remove the last element of array(lastemp)
        _emplist.pop();

        //remove the index of removed employee;
        data.index = 0;
    }

    

    function charge() public payable onlyAdmin {
        ContractBalance += msg.value;
    }

    function countRole(bytes32 role) private view returns (uint256) {//test this seprately
        uint256 j=0;
    
        for (uint256 i=0; i<= _emplist.length; i++){
            Data storage data = map[_emplist[i]];
            bytes32 empRole = data.role;

            if(empRole == role) {
                j++;
            }
        }
        return j;       
    } 

    function roleArray(bytes32 role) public view returns(address payable[] memory){//test this seprately
        uint256 length = countRole(role);
        address payable[] memory result = new address payable[](length);

        for (uint256 i=0; i<= _emplist.length; i++){
            Data storage data = map[_emplist[i]];
            bytes32 empRole = data.role;

            if(empRole == role){
                result[i] = _emplist[i];
            }
        } 
        return result;   
    }   

    //this is not working. 
    /*function PaySalary (uint256 worker_amount, uint256 engineer_amount) public payable onlyAdmin { 
      
        uint256 total_salary = totalSalary(worker_amount, engineer_amount);
        require(ContractBalance >= total_salary ,"not enough balance");

    } */
}




/*what to add:
1- Remove someone from the list based on their name. ---------[DONE]
+ how to update index of other members? /solved by Remix_Multisend / ---------[DONE]
+ how to remove them from mapping? / we can use "delete", but it sets the value of mapping to zero. we already 
  have zero an an index. what should we do? ---------- [DONE] 
   
2- Employess get different amount of salary. how to implemnt that? I think defining roles can be the solution.------[Done]
3- Use access control to add onlyEmployee and onlyBoss. how to add roles? -------[DONE]
4- solidity doesn't support dynamic array in memory(only storage). So we can't pull out rolebased arrays 
   from emplist. how solve this?
*/


/*Extend this:
1- Learn how to code a ICO contract. There are similarities I think.
*/

