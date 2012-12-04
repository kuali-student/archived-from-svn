/*
 * Copyright 2011 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.service.remote.impl;


import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import org.kuali.rice.core.api.exception.RiceIllegalArgumentException;
import org.kuali.rice.kim.api.common.delegate.DelegateMember;
import org.kuali.rice.kim.api.role.Role;
import org.kuali.rice.kim.api.role.RoleMembership;
import org.kuali.rice.kim.api.role.RoleResponsibility;
import org.kuali.rice.kim.api.role.RoleResponsibilityAction;
import org.kuali.rice.kim.api.role.RoleService;


public class RoleServiceRemoteImpl extends RoleServiceDecorator
{
	private String hostUrl;

	public String getHostUrl()
	{
		return hostUrl;
	}
	public void setHostUrl(String hostUrl)
	{
		this.hostUrl = hostUrl;
		if (hostUrl == null)
		{
			this.setNextDecorator(null);
			return;
		}
		URL wsdlURL;
		try
		{
			String urlStr = hostUrl + "/services/soap/kim/v2_0/" + RoleServiceConstants.SERVICE_NAME_LOCAL_PART + "?wsdl";
			wsdlURL = new URL(urlStr);
		}
		catch (MalformedURLException ex)
		{
			throw new IllegalArgumentException(ex);
		}
		QName qname = new QName(RoleServiceConstants.NAMESPACE, RoleServiceConstants.SERVICE_NAME_LOCAL_PART);
		Service factory = Service.create(wsdlURL, qname);
		RoleService port = factory.getPort(RoleService.class);
		this.setNextDecorator(port);
	}
	//
	// Have to override and check for null because of a bug in CXF 2.3.8 our current version
	// It was fixed in 2.6.1 but 2.3.8 still renders empty lists as null when transported by soap
	// see http://stackoverflow.com/questions/11384986/apache-cxf-web-services-problems
	//
	
	@Override
	public List<Role> getRoles(List<String> ids)
		throws RiceIllegalArgumentException
	{
		List<Role> list = this.getNextDecorator ().getRoles(ids);
		if (list == null)
		{
			return new ArrayList<Role> ();
		}
		return list;
	}
	
	@Override
	public List<Map<String, String>> getRoleQualifersForPrincipalByRoleIds(String principalId, List<String> roleIds, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Map<String, String>> list = this.getNextDecorator ().getRoleQualifersForPrincipalByRoleIds(principalId, roleIds, qualification);
		if (list == null)
		{
			return new ArrayList<Map<String, String>> ();
		}
		return list;
	}
	
	@Override
	public List<Map<String, String>> getRoleQualifersForPrincipalByNamespaceAndRolename(String principalId, String namespaceCode, String roleName, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Map<String, String>> list = this.getNextDecorator ().getRoleQualifersForPrincipalByNamespaceAndRolename(principalId, namespaceCode, roleName, qualification);
		if (list == null)
		{
			return new ArrayList<Map<String, String>> ();
		}
		return list;
	}
	
	@Override
	public List<Map<String, String>> getNestedRoleQualifersForPrincipalByNamespaceAndRolename(String principalId, String namespaceCode, String roleName, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Map<String, String>> list = this.getNextDecorator ().getNestedRoleQualifersForPrincipalByNamespaceAndRolename(principalId, namespaceCode, roleName, qualification);
		if (list == null)
		{
			return new ArrayList<Map<String, String>> ();
		}
		return list;
	}
	
	@Override
	public List<Map<String, String>> getNestedRoleQualifiersForPrincipalByRoleIds(String principalId, List<String> roleIds, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Map<String, String>> list = this.getNextDecorator ().getNestedRoleQualifiersForPrincipalByRoleIds(principalId, roleIds, qualification);
		if (list == null)
		{
			return new ArrayList<Map<String, String>> ();
		}
		return list;
	}
	
	@Override
	public List<RoleMembership> getRoleMembers(List<String> roleIds, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<RoleMembership> list = this.getNextDecorator ().getRoleMembers(roleIds, qualification);
		if (list == null)
		{
			return new ArrayList<RoleMembership> ();
		}
		return list;
	}
	
	@Override
	public Collection<String> getRoleMemberPrincipalIds(String namespaceCode, String roleName, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		Collection<String> list = this.getNextDecorator ().getRoleMemberPrincipalIds(namespaceCode, roleName, qualification);
		if (list == null)
		{
			return new ArrayList<String> ();
		}
		return list;
	}
	
	@Override
	public List<String> getPrincipalIdSubListWithRole(List<String> principalIds, String roleNamespaceCode, String roleName, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<String> list = this.getNextDecorator ().getPrincipalIdSubListWithRole(principalIds, roleNamespaceCode, roleName, qualification);
		if (list == null)
		{
			return new ArrayList<String> ();
		}
		return list;
	}
	
	@Override
	public List<RoleMembership> getFirstLevelRoleMembers(List<String> roleIds)
		throws RiceIllegalArgumentException
	{
		List<RoleMembership> list = this.getNextDecorator ().getFirstLevelRoleMembers(roleIds);
		if (list == null)
		{
			return new ArrayList<RoleMembership> ();
		}
		return list;
	}
	
	@Override
	public List<String> getMemberParentRoleIds(String memberType, String memberId)
		throws RiceIllegalArgumentException
	{
		List<String> list = this.getNextDecorator ().getMemberParentRoleIds(memberType, memberId);
		if (list == null)
		{
			return new ArrayList<String> ();
		}
		return list;
	}
	
	@Override
	public Set<String> getRoleTypeRoleMemberIds(String roleId)
		throws RiceIllegalArgumentException
	{
		Set<String> list = this.getNextDecorator ().getRoleTypeRoleMemberIds(roleId);
		if (list == null)
		{
			return new HashSet<String> ();
		}
		return list;
	}
	
	@Override
	public List<DelegateMember> getDelegationMembersByDelegationId(String delegateId)
		throws RiceIllegalArgumentException
	{
		List<DelegateMember> list = this.getNextDecorator ().getDelegationMembersByDelegationId(delegateId);
		if (list == null)
		{
			return new ArrayList<DelegateMember> ();
		}
		return list;
	}
	
	@Override
	public List<RoleResponsibility> getRoleResponsibilities(String roleId)
		throws RiceIllegalArgumentException
	{
		List<RoleResponsibility> list = this.getNextDecorator ().getRoleResponsibilities(roleId);
		if (list == null)
		{
			return new ArrayList<RoleResponsibility> ();
		}
		return list;
	}
	
	@Override
	public List<RoleResponsibilityAction> getRoleMemberResponsibilityActions(String roleMemberId)
		throws RiceIllegalArgumentException
	{
		List<RoleResponsibilityAction> list = this.getNextDecorator ().getRoleMemberResponsibilityActions(roleMemberId);
		if (list == null)
		{
			return new ArrayList<RoleResponsibilityAction> ();
		}
		return list;
	}
}

