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
import org.kuali.student.r2.lum.lrc.dto.ResultScaleInfo;
import org.kuali.student.r2.lum.lrc.dto.ResultValueInfo;
import org.kuali.student.r2.lum.lrc.dto.ResultValuesGroupInfo;


//@Ignore
public class LRCServiceRemoteImplTest
{
	private static ContextInfo contextInfo;
	private static LrcServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new LrcServiceRemoteImpl();
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
	public void testSearchResultScaleInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByDescrPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByDescrFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByResultValueRangeMinValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.minValue", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByResultValueRangeMaxValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.maxValue", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultScaleInfoByResultValueRangeIncrement () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.increment", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a Date
	// TODO: deal with  expirationDate which is a Date
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchResultScaleInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchResultScaleInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultScaleInfo> infos = service.searchForResultScales(qBuilder.build(), contextInfo);
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
	public void testSearchResultValuesGroupInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByDescrPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByDescrFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByResultScaleKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultScaleKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  resultValueKeys which is a List
	
	@Test
	public void testSearchResultValuesGroupInfoByResultValueRangeMinValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.minValue", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByResultValueRangeMaxValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.maxValue", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValuesGroupInfoByResultValueRangeIncrement () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultValueRange.increment", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a Date
	// TODO: deal with  expirationDate which is a Date
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchResultValuesGroupInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchResultValuesGroupInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValuesGroupInfo> infos = service.searchForResultValuesGroups(qBuilder.build(), contextInfo);
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
	public void testSearchResultValueInfoKeywordSearch () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("keywordSearch", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByDescrPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByDescrFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByResultScaleKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("resultScaleKey", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByNumericValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("numericValue", "0"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchResultValueInfoByValue () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("value", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a Date
	// TODO: deal with  expirationDate which is a Date
	// TODO: deal with seaching on the version indicator which is a string in the contract but a number in the database
	// TODO: deal with  meta.createTime which is a Date
	
	@Test
	public void testSearchResultValueInfoByMetaCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a Date
	
	@Test
	public void testSearchResultValueInfoByMetaUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "xyzzysomethingnothingmatches"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<ResultValueInfo> infos = service.searchForResultValues(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
}

