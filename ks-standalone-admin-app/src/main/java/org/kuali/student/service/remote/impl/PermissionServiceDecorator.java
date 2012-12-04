/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import java.util.List;
import java.util.Map;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.rice.core.api.exception.RiceIllegalArgumentException;
import org.kuali.rice.core.api.exception.RiceIllegalStateException;
import org.kuali.rice.kim.api.common.assignee.Assignee;
import org.kuali.rice.kim.api.common.template.Template;
import org.kuali.rice.kim.api.common.template.TemplateQueryResults;
import org.kuali.rice.kim.api.permission.Permission;
import org.kuali.rice.kim.api.permission.PermissionQueryResults;
import org.kuali.rice.kim.api.permission.PermissionService;

/**
 *
 * @author nwright
 */
public class PermissionServiceDecorator implements PermissionService {
    private PermissionService nextDecorator;

    public PermissionService getNextDecorator() {
        return nextDecorator;
    }

    public void setNextDecorator(PermissionService nextDecorator) {
        this.nextDecorator = nextDecorator;
    }

    public Permission createPermission(Permission permission) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().createPermission(permission);
    }

    public Permission updatePermission(Permission permission) throws RiceIllegalArgumentException, RiceIllegalStateException {
        return getNextDecorator ().updatePermission(permission);
    }

    public boolean hasPermission(String principalId, String namespaceCode, String permissionName) throws RiceIllegalArgumentException {
        return getNextDecorator ().hasPermission(principalId, namespaceCode, permissionName);
    }

    public boolean isAuthorized(String principalId, String namespaceCode, String permissionName, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().isAuthorized(principalId, namespaceCode, permissionName, qualification);
    }

    public boolean hasPermissionByTemplate(String principalId, String namespaceCode, String permissionTemplateName, Map<String, String> permissionDetails) throws RiceIllegalArgumentException {
        return getNextDecorator ().hasPermissionByTemplate(principalId, namespaceCode, permissionTemplateName, permissionDetails);
    }

    public boolean isAuthorizedByTemplate(String principalId, String namespaceCode, String permissionTemplateName, Map<String, String> permissionDetails, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().isAuthorizedByTemplate(principalId, namespaceCode, permissionTemplateName, permissionDetails, qualification);
    }

    public List<Assignee> getPermissionAssignees(String namespaceCode, String permissionName, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getPermissionAssignees(namespaceCode, permissionName, qualification);
    }

    public List<Assignee> getPermissionAssigneesByTemplate(String namespaceCode, String permissionTemplateName, Map<String, String> permissionDetails, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getPermissionAssigneesByTemplate(namespaceCode, permissionTemplateName, permissionDetails, qualification);
    }

    public boolean isPermissionDefined(String namespaceCode, String permissionName) throws RiceIllegalArgumentException {
        return getNextDecorator ().isPermissionDefined(namespaceCode, permissionName);
    }

    public boolean isPermissionDefinedByTemplate(String namespaceCode, String permissionTemplateName, Map<String, String> permissionDetails) throws RiceIllegalArgumentException {
        return getNextDecorator ().isPermissionDefinedByTemplate(namespaceCode, permissionTemplateName, permissionDetails);
    }

    public List<Permission> getAuthorizedPermissions(String principalId, String namespaceCode, String permissionName, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getAuthorizedPermissions(principalId, namespaceCode, permissionName, qualification);
    }

    public List<Permission> getAuthorizedPermissionsByTemplate(String principalId, String namespaceCode, String permissionTemplateName, Map<String, String> permissionDetails, Map<String, String> qualification) throws RiceIllegalArgumentException {
        return getNextDecorator ().getAuthorizedPermissionsByTemplate(principalId, namespaceCode, permissionTemplateName, permissionDetails, qualification);
    }

    public Permission getPermission(String id) {
        return getNextDecorator ().getPermission(id);
    }

    public Permission findPermByNamespaceCodeAndName(String namespaceCode, String name) throws RiceIllegalArgumentException {
        return getNextDecorator ().findPermByNamespaceCodeAndName(namespaceCode, name);
    }

    public List<Permission> findPermissionsByTemplate(String namespaceCode, String templateName) throws RiceIllegalArgumentException {
        return getNextDecorator ().findPermissionsByTemplate(namespaceCode, templateName);
    }

    public Template getPermissionTemplate(String id) throws RiceIllegalArgumentException {
        return getNextDecorator ().getPermissionTemplate(id);
    }

    public Template findPermTemplateByNamespaceCodeAndName(String namespaceCode, String name) throws RiceIllegalArgumentException {
        return getNextDecorator ().findPermTemplateByNamespaceCodeAndName(namespaceCode, name);
    }

    public List<Template> getAllTemplates() {
        return getNextDecorator ().getAllTemplates();
    }

    public List<String> getRoleIdsForPermission(String namespaceCode, String permissionName) throws RiceIllegalArgumentException {
        return getNextDecorator ().getRoleIdsForPermission(namespaceCode, permissionName);
    }

    public PermissionQueryResults findPermissions(QueryByCriteria queryByCriteria) throws RiceIllegalArgumentException {
        return getNextDecorator ().findPermissions(queryByCriteria);
    }

    public TemplateQueryResults findPermissionTemplates(QueryByCriteria queryByCriteria) throws RiceIllegalArgumentException {
        return getNextDecorator ().findPermissionTemplates(queryByCriteria);
    }
    
    
}
