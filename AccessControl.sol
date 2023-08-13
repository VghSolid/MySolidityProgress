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
    //------------------------------------------------- only use in constructors ------- 
    function _setupRole(bytes32 role, address account) internal virtual {
        _roles[role].members[account] = true;
        emit RoleGranted(role, account, _msgSender());
    }
    function _setupAdminRole(bytes32 role,bytes32 adminrole) internal virtual {
        _roles[role].adminRole = adminrole;
    }
    //---------------------------------------------------------

    //modifer and check role functions
    modifier onlyRole(bytes32 role){
        _checkRole(role);
        _;
    }
    function _checkRole(bytes32 role) internal view {
        _checkRole(role,_msgSender());
    }
    function _checkRole(bytes32 role,address account) internal view {
        if(hasRole(role, account)==false){
            revert AccessControlUnauthorizedAccount(account, role);
        }
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
    
    //revoke a role from account_ by account itself.
    function renounceRole(bytes32 role,address callerConfirmation) public virtual {
        if(callerConfirmation != _msgSender()){
            revert AccessControlBadConfirmation();
        }
        _revokeRole(role, callerConfirmation);
    }

    //revoke a role from account_ by admin.
    function revokeRole(bytes32 role,address account) public virtual onlyRole(getRoleAdmin(role)) {
        _revokeRole(role,account);
    }

    function _revokeRole(bytes32 role , address account) internal virtual {
        if(hasRole(role, account)){
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
    function _grantRole(bytes32 role, address account) internal virtual{
        if(!hasRole(role, account)){
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _setRoleAdmin(bytes32 role, bytes32 adminRole) public virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }
    
    



}