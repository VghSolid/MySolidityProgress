// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import "./Context.sol";
import "./IAccessControl.sol";

abstract contract AccessControl is context, IAccessControl{
    struct RoleData {
        mapping (address => bool) members;
        bytes32 adminRole;
    }
    mapping (bytes32 => RoleData) private _roles;

    bytes32 constant public Default_Admin_Role = 0x00;

    modifier onlyRole(bytes32 role){
        _checkRole(role);
        _;
    }

    //Is this account has a role?
    function hasRole(bytes32 role,address account) public view virtual returns(bool) {
        return _roles[role].members[account];
    }

    //Who is the admin of this role?
    function getRoleAdmin(bytes32 role) public view virtual returns(bytes32){
        return _roles[role].adminRole;
    }

    //Give an account a role. caller must be the role's admin. 
    function grantRole(bytes32 role,address account) public virtual onlyRole(getRoleAdmin(role)) {
        _grantRole(role,account);
    }
    function _grantRole(bytes32 role, address account) internal virtual{
        if(!hasRole(role, account)){
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }
    //revoke a role from account.
    function revokeRole(bytes32 role,address account) public virtual onlyRole(getRoleAdmin(role)) {
        _revokeRole(role,account);
    }
    function _revokeRole(bytes32 role , address account) internal virtual {
        if(hasRole(role, account)){
            
        }
    }
    //
    function renounceRole(bytes32 role,address callerConfirmation) public virtual {

    }
    //
    function _checkRole(bytes32 role) internal view {
        require(hasRole(role, _msgSender()),"You're not the role's admin");
    }



}