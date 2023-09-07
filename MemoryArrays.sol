// SPDX-License-Identifier: MIT
pragma solidity >0.8.0 <0.9.0;
//                 *****************************  Not Finished  ****************************

//In this contract I tried to implement a memory array.
/*
1- People add their name and wallet address to a mapping.
2- Admin, using their names, make them a member and adds them to a struct(with  role and address members) 
3- Based on their given role, we want them in as arrays (role based arrays) in output.
4- Then if needed, admin removes them so they can't be a member anymore.
*/

// The count and getaccounts functoins does not work

contract memoryArrays {
    struct EmpData{
        bytes32 role;
        address payable account;
    }
    EmpData[] public empData;
    mapping (address => bool) private isEmp;
    mapping (string => address payable) private Addrs;

    address private owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyAdmin{
        require(msg.sender == owner,"Access Denied");
        _;
    }

    bytes32 constant public worker= keccak256("worker");
    bytes32 constant public engineer= keccak256("engineer");

    
    function addYourAccount(string memory name) external {
        Addrs[name] = payable (msg.sender);
    }

    function addEmployee(bytes32 role, string memory name) external onlyAdmin{
        address payable  account = Addrs[name];
        require(account != address(0), "Invalid Input");
        require(isEmp[account]==false ,"already is an employee");

        EmpData memory newEmp;

        newEmp.account = account;
        newEmp.role = role;
        isEmp[account] = true;
        empData.push(newEmp);
    }
    
    function countAccounts(bytes32 role) internal view returns(uint256){

        uint256 counter=0;
        for(uint256 i=0; i<= 10; i++){
            if(isEmp[empData[i].account] ==true && empData[i].account!= address(0)){
                if(empData[i].role == role){
                    counter++;
                }
            }
               
        }
        return counter;
    }


    function getroleAccounts(bytes32 role) external view returns(address payable[] memory){
        address payable [] memory result = new address payable [] (countAccounts(role));
        uint256 j =0;

        for(uint256 i=0; i<= empData.length; i++){
            if(isEmp[empData[i].account] ==true && empData[i].account!= address(0)){
                if(empData[i].role == role){
                    result[j] = empData[i].account;
                    j++;
                }
            }
        }
        return result;
    }

    function removeEmployee(string memory name) external onlyAdmin{
        address payable account = Addrs[name];
        require(isEmp[account]==true,"not an employee");
        isEmp[account] = false;
    }

    /*function paySalary(bytes32 role,uint256 unitSalary) public payable  {
        uint256 totalSalary = roleSalary(role, unitSalary);

        require(address(this).balance >= totalSalary);
        address payable [] memory emplist = getroleAccounts(role);

        for (uint256 i=0; i<= emplist.length; i++){
            (bool sent,) = emplist[i].call{value: unitSalary}("");
            require(sent==true,"failed to send");
        }
    }*/
    



}