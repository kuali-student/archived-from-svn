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


//@Ignorepublic class LRCServiceRemoteImplTest{
	private static ContextInfo contextInfo;
	private static LRCServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new LRCServiceRemoteImpl();
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
	public void testSearchResultScaleInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByMinValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.minValue", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByMaxValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.maxValue", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByIncrement () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.increment", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a date
	// TODO: deal with  expirationDate which is a date
	
	@Test
	public void testSearchResultScaleInfoByVersionInd () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.versionInd", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.createTime which is a date
	
	@Test
	public void testSearchResultScaleInfoByCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a date
	
	@Test
	public void testSearchResultScaleInfoByUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
	
	@Test
	public void testSearchResultValueInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByResultScaleKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultScaleKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByNumericValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("numericValue", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("value", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a date
	// TODO: deal with  expirationDate which is a date
	
	@Test
	public void testSearchResultValueInfoByVersionInd () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.versionInd", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.createTime which is a date
	
	@Test
	public void testSearchResultValueInfoByCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a date
	
	@Test
	public void testSearchResultValueInfoByUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
	
	@Test
	public void testSearchResultValuesGroupInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByResultScaleKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultScaleKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  resultValueKeys which is a list
	
	@Test
	public void testSearchResultValuesGroupInfoByMinValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.minValue", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByMaxValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.maxValue", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByIncrement () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.increment", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a date
	// TODO: deal with  expirationDate which is a date
	
	@Test
	public void testSearchResultValuesGroupInfoByVersionInd () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.versionInd", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.createTime which is a date
	
	@Test
	public void testSearchResultValuesGroupInfoByCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a date
	
	@Test
	public void testSearchResultValuesGroupInfoByUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
}

