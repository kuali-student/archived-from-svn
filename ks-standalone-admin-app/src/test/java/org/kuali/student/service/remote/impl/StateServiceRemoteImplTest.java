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
import org.kuali.student.r2.core.class1.state.dto.LifecycleInfo;
import org.kuali.student.r2.core.class1.state.dto.StateInfo;


//@Ignore
public class StateServiceRemoteImplTest
{
	private static ContextInfo contextInfo;
	private static StateServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new StateServiceRemoteImpl();
//		service.setHostUrl(RemoteServiceConstants.ENV2_URL);
		service.setHostUrl(RemoteServiceConstants.LOCAL_HOST_EMBEDDED_URL);
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
	public void testSearchStateInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByDescrPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByDescrFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByLifecycleKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("lifecycleKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a Date
	// TODO: deal with  expirationDate which is a Date
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchStateInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchStateInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
	
	@Test
	public void testSearchLifecycleInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByDescrPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByDescrFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByRefObjectUri () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("refObjectUri", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchLifecycleInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchLifecycleInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
}

