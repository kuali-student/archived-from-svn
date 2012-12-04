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


import java.util.ArrayList;
import java.util.List;
import org.junit.*;
import org.kuali.rice.core.api.criteria.Predicate;
import org.kuali.rice.core.api.criteria.PredicateFactory;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.rice.kim.api.common.template.Template;
import org.kuali.rice.kim.api.common.template.TemplateQueryResults;
import org.kuali.rice.kim.api.permission.Permission;
import org.kuali.rice.kim.api.permission.PermissionQueryResults;
import org.kuali.student.r2.common.dto.ContextInfo;


//@Ignore
public class PermissionServiceRemoteImplTest
{
	private static ContextInfo contextInfo;
	private static PermissionServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new PermissionServiceRemoteImpl();
		service.setHostUrl(RemoteServiceConstants.ENV2_URL);
		//service.setHostUrl(RemoteServiceConstants.LOCAL_HOST_EMBEDDED_URL);
		contextInfo = new ContextInfo();
		contextInfo.setPrincipalId("TESTUSER");
	}
	
	@AfterClass
	public static void tearDownClass() throws Exception
	{
	}
	
	@Before
	public void setUp()
	{
	}
	
	@After
	public void tearDown()
	{
	}
	
	
	@Test
	public void testSearchPermissionAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionById () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("id", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByNamespaceCode () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("namespaceCode", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByDescription () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("description", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByTemplateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("template.id", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByTemplateNamespaceCode () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("template.namespaceCode", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByTemplateName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("template.name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByTemplateDescription () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("template.description", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchPermissionByTemplateKimTypeId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("template.kimTypeId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	// TODO: deal with  template.active which is a boolean
	// TODO: deal with  template.versionNumber which is a Long
	
	@Test
	public void testSearchPermissionByTemplateObjectId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("template.objectId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	// TODO: deal with  active which is a boolean
	// TODO: deal with  attributes which is a Map<String, String>
	// TODO: deal with  versionNumber which is a Long
	
	@Test
	public void testSearchPermissionByObjectId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("objectId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		PermissionQueryResults infos = service.findPermissions(qBuilder.build());
	}
	
	@Test
	public void testSearchTemplateAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
	
	@Test
	public void testSearchTemplateKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
	
	@Test
	public void testSearchTemplateById () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("id", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
	
	@Test
	public void testSearchTemplateByNamespaceCode () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("namespaceCode", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
	
	@Test
	public void testSearchTemplateByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
	
	@Test
	public void testSearchTemplateByDescription () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("description", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
	
	@Test
	public void testSearchTemplateByKimTypeId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("kimTypeId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
	// TODO: deal with  active which is a boolean
	// TODO: deal with  versionNumber which is a Long
	
	@Test
	public void testSearchTemplateByObjectId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("objectId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		TemplateQueryResults infos = service.findPermissionTemplates(qBuilder.build());
	}
}

