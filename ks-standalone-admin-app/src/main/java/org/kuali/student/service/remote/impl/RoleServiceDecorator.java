/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.rice.core.api.delegation.DelegationType;
import org.kuali.rice.core.api.exception.RiceIllegalArgumentException;
import org.kuali.rice.core.api.exception.RiceIllegalStateException;
import org.kuali.rice.kim.api.common.delegate.DelegateMember;
import org.kuali.rice.kim.api.common.delegate.DelegateType;
import org.kuali.rice.kim.api.role.DelegateMemberQueryResults;
import org.kuali.rice.kim.api.role.Role;
import org.kuali.rice.kim.api.role.RoleMember;
import org.kuali.rice.kim.api.role.RoleMemberQueryResults;
import org.kuali.rice.kim.api.role.RoleMembership;
import org.kuali.rice.kim.api.role.RoleMembershipQueryResults;
import org.kuali.rice.kim.api.role.RoleQueryResults;
import org.kuali.rice.kim.api.role.RoleResponsibility;
import org.kuali.rice.kim.api.role.RoleResponsibilityAction;
import org.kuali.rice.kim.api.role.RoleService;

/**
 *
 * @author nwright
 */
public class RoleServiceDecorator implements RoleService {
    
    private RoleService nextDecorator;

    public RoleService getNextDecorator() {
        return nextDecorator;
    }

    public void setNextDecorator(RoleService nextDecorator) {
        this.nextDecorator = nextDecorator;
    }
    

    public Role createRole(Role role) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().createRole(role);
    }

    public Role updateRole(Role role) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().updateRole(role);
    }

    public Role getRole(String id) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRole(id);
    }

    public List<Role> getRoles(List<String> ids) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoles(ids);
    }

    public Role getRoleByNamespaceCodeAndName(String namespaceCode, String name) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleByNamespaceCodeAndName(namespaceCode, name);
    }

    public String getRoleIdByNamespaceCodeAndName(String namespaceCode, String name) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleIdByNamespaceCodeAndName(namespaceCode, name);
    }

    public boolean isRoleActive(String id) throws RiceIllegalArgumentException {
        return getNextDecorator ().isRoleActive(id);
    }

    public List<Map<String, String>> getRoleQualifersForPrincipalByRoleIds(String principalId, List<String> roleIds, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleQualifersForPrincipalByRoleIds(principalId, roleIds, qualification);
    }

    public List<Map<String, String>> getRoleQualifersForPrincipalByNamespaceAndRolename(String principalId, String namespaceCode, String roleName, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleQualifersForPrincipalByNamespaceAndRolename(principalId, namespaceCode, roleName, qualification);
    }

    public List<Map<String, String>> getNestedRoleQualifersForPrincipalByNamespaceAndRolename(String principalId, String namespaceCode, String roleName, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getNestedRoleQualifersForPrincipalByNamespaceAndRolename(principalId, namespaceCode, roleName, qualification);
    }

    public List<Map<String, String>> getNestedRoleQualifiersForPrincipalByRoleIds(String principalId, List<String> roleIds, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getNestedRoleQualifiersForPrincipalByRoleIds(principalId, roleIds, qualification);
    }

    public List<RoleMembership> getRoleMembers(List<String> roleIds, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleMembers(roleIds, qualification);
    }

    public Collection<String> getRoleMemberPrincipalIds(String namespaceCode, String roleName, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleMemberPrincipalIds(namespaceCode, roleName, qualification);
    }

    public boolean principalHasRole(String principalId, List<String> roleIds, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().principalHasRole(principalId, roleIds, qualification);
    }

    public boolean principalHasRole(String principalId, List<String> roleIds, Map<String, String> qualification, boolean checkDelegations) throws RiceIllegalArgumentException {
        return getNextDecorator ().principalHasRole(principalId, roleIds, qualification, checkDelegations);
    }

    public List<String> getPrincipalIdSubListWithRole(List<String> principalIds, String roleNamespaceCode, String roleName, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getPrincipalIdSubListWithRole(principalIds, roleNamespaceCode, roleName, qualification);
    }

    public RoleQueryResults findRoles(QueryByCriteria queryByCriteria) throws RiceIllegalArgumentException {
        return getNextDecorator ().findRoles(queryByCriteria);
    }

    public List<RoleMembership> getFirstLevelRoleMembers(List<String> roleIds) throws RiceIllegalArgumentException {
        return getNextDecorator ().getFirstLevelRoleMembers(roleIds);
    }

    public RoleMembershipQueryResults findRoleMemberships(QueryByCriteria queryByCriteria) throws RiceIllegalArgumentException {
        return getNextDecorator ().findRoleMemberships(queryByCriteria);
    }

    public List<String> getMemberParentRoleIds(String memberType, String memberId) throws RiceIllegalArgumentException {
        return getNextDecorator ().getMemberParentRoleIds(memberType, memberId);
    }

    public RoleMemberQueryResults findRoleMembers(QueryByCriteria queryByCriteria) throws RiceIllegalArgumentException {
        return getNextDecorator ().findRoleMembers(queryByCriteria);
    }

    public Set<String> getRoleTypeRoleMemberIds(String roleId) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleTypeRoleMemberIds(roleId);
    }

    public DelegateMemberQueryResults findDelegateMembers(QueryByCriteria queryByCriteria) throws RiceIllegalArgumentException {
        return getNextDecorator ().findDelegateMembers(queryByCriteria);
    }

    public List<DelegateMember> getDelegationMembersByDelegationId(String delegateId) throws RiceIllegalArgumentException {
        return getNextDecorator ().getDelegationMembersByDelegationId(delegateId);
    }

    public DelegateMember getDelegationMemberByDelegationAndMemberId(String delegationId, String memberId) throws RiceIllegalArgumentException {
        return getNextDecorator ().getDelegationMemberByDelegationAndMemberId(delegationId, memberId);
    }

    public DelegateMember getDelegationMemberById(String id) throws RiceIllegalArgumentException {
        return getNextDecorator ().getDelegationMemberById(id);
    }

    public List<RoleResponsibility> getRoleResponsibilities(String roleId) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleResponsibilities(roleId);
    }

    public List<RoleResponsibilityAction> getRoleMemberResponsibilityActions(String roleMemberId) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleMemberResponsibilityActions(roleMemberId);
    }

    public DelegateType getDelegateTypeByRoleIdAndDelegateTypeCode(String roleId, DelegationType delegateType) throws RiceIllegalArgumentException {
        return getNextDecorator ().getDelegateTypeByRoleIdAndDelegateTypeCode(roleId, delegateType);
    }

    public DelegateType getDelegateTypeByDelegationId(String delegationId) throws RiceIllegalArgumentException {
        return getNextDecorator ().getDelegateTypeByDelegationId(delegationId);
    }

    public RoleMember assignPrincipalToRole(String principalId, String namespaceCode, String roleName, Map<String, String> qualifications) throws RiceIllegalArgumentException {
        return getNextDecorator ().assignPrincipalToRole(principalId, namespaceCode, roleName, qualifications);
    }

    public RoleMember assignGroupToRole(String groupId, String namespaceCode, String roleName, Map<String, String> qualifications) throws RiceIllegalArgumentException {
        return getNextDecorator ().assignGroupToRole(groupId, namespaceCode, roleName, qualifications);
    }

    public RoleMember assignRoleToRole(String roleId, String namespaceCode, String roleName, Map<String, String> qualifications) throws RiceIllegalArgumentException {
        return getNextDecorator ().assignRoleToRole(roleId, namespaceCode, roleName, qualifications);
    }

    public RoleMember createRoleMember(RoleMember roleMember) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().createRoleMember(roleMember);
    }

    public RoleMember updateRoleMember(RoleMember roleMember) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().updateRoleMember(roleMember);
    }

    public DelegateMember updateDelegateMember(DelegateMember delegateMember) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().updateDelegateMember(delegateMember);
    }

    public DelegateMember createDelegateMember(DelegateMember delegateMember) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().createDelegateMember(delegateMember);
    }

    public void removeDelegateMembers(List<DelegateMember> delegateMembers) throws RiceIllegalArgumentException, RiceIllegalStateException {
        getNextDecorator ().removeDelegateMembers(delegateMembers);
    }

    public RoleResponsibilityAction createRoleResponsibilityAction(RoleResponsibilityAction roleResponsibilityAction) throws RiceIllegalArgumentException {
        return getNextDecorator ().createRoleResponsibilityAction(roleResponsibilityAction);
    }

    public DelegateType createDelegateType(DelegateType delegateType) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().createDelegateType(delegateType);
    }

    public DelegateType updateDelegateType(DelegateType delegateType) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().updateDelegateType(delegateType);
    }

    public void removePrincipalFromRole(String principalId, String namespaceCode, String roleName, Map<String, String> qualifications) throws RiceIllegalArgumentException {
        getNextDecorator ().removePrincipalFromRole(principalId, namespaceCode, roleName, qualifications);
    }

    public void removeGroupFromRole(String groupId, String namespaceCode, String roleName, Map<String, String> qualifications) throws RiceIllegalArgumentException {
        getNextDecorator ().removeGroupFromRole(groupId, namespaceCode, roleName, qualifications);
    }

    public void removeRoleFromRole(String roleId, String namespaceCode, String roleName, Map<String, String> qualifications) throws RiceIllegalArgumentException {
        getNextDecorator ().removeRoleFromRole(roleId, namespaceCode, roleName, qualifications);
    }

    public void assignPermissionToRole(String permissionId, String roleId) throws RiceIllegalArgumentException {
        getNextDecorator ().assignPermissionToRole(permissionId, roleId);
    }

    public void revokePermissionFromRole(String permissionId, String roleId) throws RiceIllegalArgumentException {
        getNextDecorator ().revokePermissionFromRole(permissionId, roleId);
    }

    public boolean isDerivedRole(String roleId) throws RiceIllegalArgumentException {
        return getNextDecorator ().isDerivedRole(roleId);
    }

    public boolean isDynamicRoleMembership(String roleId) throws RiceIllegalArgumentException {
        return getNextDecorator ().isDynamicRoleMembership(roleId);
    }

    public RoleResponsibilityAction updateRoleResponsibilityAction(RoleResponsibilityAction roleResponsibilityAction) throws RiceIllegalArgumentException {
        return nextDecorator.updateRoleResponsibilityAction(roleResponsibilityAction);
    }

    @Override
    public void deleteRoleResponsibilityAction(String roleResponsibilityActionId) throws RiceIllegalArgumentException {
        nextDecorator.deleteRoleResponsibilityAction(roleResponsibilityActionId);
    }
    
    
}
