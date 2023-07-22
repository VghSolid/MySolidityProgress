// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IAccessControl {

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    function hasRole(bytes32 role, address account) external view returns(bool);

    function getRoleAdmin(bytes32 role) external view returns(bytes32); 

    function grantRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function renounceRole(bytes32 role, address callerConfirmation) external; 
}