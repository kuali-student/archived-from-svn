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


//@Ignorepublic class TypeServiceRemoteImplTest{
	private static ContextInfo contextInfo;
	private static TypeServiceRemoteImpl service;
	
	
	@BeforeClass
	public static void setUpClass() throws Exception
	{
		service = new TypeServiceRemoteImpl();
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
	public void testSearchTypeInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeInfoByKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("key", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeInfoByName () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("name", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeInfoByPlain () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.plain", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeInfoByFormatted () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("descr.formatted", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a date
	// TODO: deal with  expirationDate which is a date
	
	@Test
	public void testSearchTypeInfoByRefObjectUri () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("refObjectUri", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeInfoByServiceUri () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("serviceUri", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeInfoByVersionInd () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.versionInd", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.createTime which is a date
	
	@Test
	public void testSearchTypeInfoByCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a date
	
	@Test
	public void testSearchTypeInfoByUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeInfo> infos = service.searchForTypes(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
	
	@Test
	public void testSearchTypeTypeRelationInfoAll () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeTypeRelationInfoById () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("id", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeTypeRelationInfoByTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("typeKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeTypeRelationInfoByStateKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("stateKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  effectiveDate which is a date
	// TODO: deal with  expirationDate which is a date
	
	@Test
	public void testSearchTypeTypeRelationInfoByOwnerTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("ownerTypeKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeTypeRelationInfoByRelatedTypeKey () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("relatedTypeKey", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	
	@Test
	public void testSearchTypeTypeRelationInfoByRank () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("rank", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	// TODO: deal with dynamic attributes
	
	@Test
	public void testSearchTypeTypeRelationInfoByVersionInd () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.versionInd", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.createTime which is a date
	
	@Test
	public void testSearchTypeTypeRelationInfoByCreateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.createId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
	// TODO: deal with  meta.updateTime which is a date
	
	@Test
	public void testSearchTypeTypeRelationInfoByUpdateId () throws Exception
	{
		QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
		List<Predicate> pList = new ArrayList<Predicate>();
		pList.add(PredicateFactory.equal("meta.updateId", "fall"));
		qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
		qBuilder.setMaxResults (30);
		List<TypeTypeRelationInfo> infos = service.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
	}
}

