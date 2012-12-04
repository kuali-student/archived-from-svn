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


import java.lang.String;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import org.kuali.rice.core.api.exception.RiceIllegalArgumentException;
import org.kuali.rice.kim.api.common.assignee.Assignee;
import org.kuali.rice.kim.api.common.template.Template;
import org.kuali.rice.kim.api.permission.Permission;
import org.kuali.rice.kim.api.permission.PermissionService;


public class PermissionServiceRemoteImpl extends PermissionServiceDecorator
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
			String urlStr = hostUrl + "/services/soap/kim/v2_0/" + PermissionServiceConstants.SERVICE_NAME_LOCAL_PART + "?wsdl";
			wsdlURL = new URL(urlStr);
		}
		catch (MalformedURLException ex)
		{
			throw new IllegalArgumentException(ex);
		}
		QName qname = new QName(PermissionServiceConstants.NAMESPACE, PermissionServiceConstants.SERVICE_NAME_LOCAL_PART);
		Service factory = Service.create(wsdlURL, qname);
		PermissionService port = factory.getPort(PermissionService.class);
		this.setNextDecorator(port);
	}
	//
	// Have to override and check for null because of a bug in CXF 2.3.8 our current version
	// It was fixed in 2.6.1 but 2.3.8 still renders empty lists as null when transported by soap
	// see http://stackoverflow.com/questions/11384986/apache-cxf-web-services-problems
	//
	
	@Override
	public List<Assignee> getPermissionAssignees(String namespaceCode, String permissionName, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Assignee> list = this.getNextDecorator ().getPermissionAssignees(namespaceCode, permissionName, qualification);
		if (list == null)
		{
			return new ArrayList<Assignee> ();
		}
		return list;
	}
	
	@Override
	public List<Assignee> getPermissionAssigneesByTemplate(String namespaceCode, String permissionTemplateName, Map<String, String> permissionDetails, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Assignee> list = this.getNextDecorator ().getPermissionAssigneesByTemplate(namespaceCode, permissionTemplateName, permissionDetails, qualification);
		if (list == null)
		{
			return new ArrayList<Assignee> ();
		}
		return list;
	}
	
	@Override
	public List<Permission> getAuthorizedPermissions(String principalId, String namespaceCode, String permissionName, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Permission> list = this.getNextDecorator ().getAuthorizedPermissions(principalId, namespaceCode, permissionName, qualification);
		if (list == null)
		{
			return new ArrayList<Permission> ();
		}
		return list;
	}
	
	@Override
	public List<Permission> getAuthorizedPermissionsByTemplate(String principalId, String namespaceCode, String permissionTemplateName, Map<String, String> permissionDetails, Map<String, String> qualification)
		throws RiceIllegalArgumentException
	{
		List<Permission> list = this.getNextDecorator ().getAuthorizedPermissionsByTemplate(principalId, namespaceCode, permissionTemplateName, permissionDetails, qualification);
		if (list == null)
		{
			return new ArrayList<Permission> ();
		}
		return list;
	}
	
	@Override
	public List<Permission> findPermissionsByTemplate(String namespaceCode, String templateName)
		throws RiceIllegalArgumentException
	{
		List<Permission> list = this.getNextDecorator ().findPermissionsByTemplate(namespaceCode, templateName);
		if (list == null)
		{
			return new ArrayList<Permission> ();
		}
		return list;
	}
	
	@Override
	public List<Template> getAllTemplates()
	{
		List<Template> list = this.getNextDecorator ().getAllTemplates();
		if (list == null)
		{
			return new ArrayList<Template> ();
		}
		return list;
	}
	
	@Override
	public List<String> getRoleIdsForPermission(String namespaceCode, String permissionName)
		throws RiceIllegalArgumentException
	{
		List<String> list = this.getNextDecorator ().getRoleIdsForPermission(namespaceCode, permissionName);
		if (list == null)
		{
			return new ArrayList<String> ();
		}
		return list;
	}
}

