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
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.core.atp.dto.AtpAtpRelationInfo;
import org.kuali.student.r2.core.atp.dto.AtpInfo;
import org.kuali.student.r2.core.atp.dto.MilestoneInfo;


//@Ignore
public class AtpServiceRemoteImplTest
{
	private static ContextInfo contextInfo;
	private static AtpServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new AtpServiceRemoteImpl();
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
	public void testSearchAtpInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoById () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("id", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoByDescrPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoByDescrFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpInfoByCode () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("code", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  startDate which is a Date
	// TODO: deal with  endDate which is a Date
	
	@Test
	public void testSearchAtpInfoByAdminOrgId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("adminOrgId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchAtpInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchAtpInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpInfo> infos = service.searchForAtps(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
	
	@Test
	public void testSearchAtpAtpRelationInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpAtpRelationInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpAtpRelationInfoById () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("id", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpAtpRelationInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpAtpRelationInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpAtpRelationInfoByAtpId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("atpId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchAtpAtpRelationInfoByRelatedAtpId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("relatedAtpId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a Date
	// TODO: deal with  expirationDate which is a Date
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchAtpAtpRelationInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchAtpAtpRelationInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<AtpAtpRelationInfo> infos = service.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
	
	@Test
	public void testSearchMilestoneInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchMilestoneInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchMilestoneInfoById () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("id", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchMilestoneInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchMilestoneInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchMilestoneInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchMilestoneInfoByDescrPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchMilestoneInfoByDescrFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  isAllDay which is a Boolean
	// TODO: deal with  isInstructionalDay which is a Boolean
	// TODO: deal with  isRelative which is a Boolean
	
	@Test
	public void testSearchMilestoneInfoByRelativeAnchorMilestoneId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("relativeAnchorMilestoneId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  isDateRange which is a Boolean
	// TODO: deal with  startDate which is a Date
	// TODO: deal with  endDate which is a Date
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchMilestoneInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchMilestoneInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<MilestoneInfo> infos = service.searchForMilestones(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
}

