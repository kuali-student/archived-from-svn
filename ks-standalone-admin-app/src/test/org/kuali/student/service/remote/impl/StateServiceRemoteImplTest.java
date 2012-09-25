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


import org.junit.*;
import org.kuali.rice.core.api.criteria.Predicate;
import org.kuali.rice.core.api.criteria.PredicateFactory;
import org.kuali.rice.core.api.criteria.QueryByCriteria;


//@Ignorepublic class StateServiceRemoteImplTest{
	private static ContextInfo contextInfo;
	private static StateServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new StateServiceRemoteImpl();
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
	public void testSearchStateInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchStateInfoByLifecycleKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("lifecycleKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a date
	// TODO: deal with  expirationDate which is a date
	
	@Test
	public void testSearchStateInfoByVersionInd () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.versionInd", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.createTime which is a date
	
	@Test
	public void testSearchStateInfoByCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<StateInfo> infos = service.searchForStates(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a date
	
	@Test
	public void testSearchStateInfoByUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "fall"));
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
	public void testSearchLifecycleInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByRefObjectUri () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("refObjectUri", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchLifecycleInfoByVersionInd () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.versionInd", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.createTime which is a date
	
	@Test
	public void testSearchLifecycleInfoByCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a date
	
	@Test
	public void testSearchLifecycleInfoByUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<LifecycleInfo> infos = service.searchForLifecycles(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
}

