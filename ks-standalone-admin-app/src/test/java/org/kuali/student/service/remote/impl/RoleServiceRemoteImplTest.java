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
import org.kuali.rice.kim.api.common.delegate.DelegateMember;
import org.kuali.rice.kim.api.role.DelegateMemberQueryResults;
import org.kuali.rice.kim.api.role.Role;
import org.kuali.rice.kim.api.role.RoleQueryResults;
import org.kuali.student.r2.common.dto.ContextInfo;


//@Ignore
public class RoleServiceRemoteImplTest
{
	private static ContextInfo contextInfo;
	private static RoleServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new RoleServiceRemoteImpl();
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
	public void testSearchDelegateMemberAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		DelegateMemberQueryResults infos = service.findDelegateMembers(qBuilder.build());
	}
	
	@Test
	public void testSearchDelegateMemberKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		DelegateMemberQueryResults infos = service.findDelegateMembers(qBuilder.build());
	}
	
	@Test
	public void testSearchDelegateMemberByDelegationMemberId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("delegationMemberId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		DelegateMemberQueryResults infos = service.findDelegateMembers(qBuilder.build());
	}
	
	@Test
	public void testSearchDelegateMemberByDelegationId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("delegationId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		DelegateMemberQueryResults infos = service.findDelegateMembers(qBuilder.build());
	}
	
	@Test
	public void testSearchDelegateMemberByMemberId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("memberId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		DelegateMemberQueryResults infos = service.findDelegateMembers(qBuilder.build());
	}
	
	@Test
	public void testSearchDelegateMemberByRoleMemberId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("roleMemberId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		DelegateMemberQueryResults infos = service.findDelegateMembers(qBuilder.build());
	}
	
	@Test
	public void testSearchRoleAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
	
	@Test
	public void testSearchRoleKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
	
	@Test
	public void testSearchRoleById () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("id", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
	
	@Test
	public void testSearchRoleByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
	
	@Test
	public void testSearchRoleByNamespaceCode () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("namespaceCode", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
	
	@Test
	public void testSearchRoleByDescription () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("description", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
	
	@Test
	public void testSearchRoleByKimTypeId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("kimTypeId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
	// TODO: deal with  active which is a boolean
	// TODO: deal with  versionNumber which is a Long
	
	@Test
	public void testSearchRoleByObjectId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("objectId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		RoleQueryResults infos = service.findRoles(qBuilder.build());
	}
}

