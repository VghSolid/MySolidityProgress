// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IAccessControl {

    error AccessControlBadConfirmation();

    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    function hasRole(bytes32 role, address account) external view returns(bool);

    function getRoleAdmin(bytes32 role) external view returns(bytes32); 

    function grantRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function renounceRole(bytes32 role, address callerConfirmation) external; 
}