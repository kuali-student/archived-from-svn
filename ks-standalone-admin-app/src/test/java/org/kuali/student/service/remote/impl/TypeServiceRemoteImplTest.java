/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import java.util.ArrayList;
import java.util.List;
import org.junit.*;
import org.kuali.rice.core.api.criteria.Predicate;
import org.kuali.rice.core.api.criteria.PredicateFactory;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;
import org.kuali.student.r2.core.class1.type.dto.TypeTypeRelationInfo;

/**
 *
 * @author nwright
 */
@Ignore
public class TypeServiceRemoteImplTest {

    public TypeServiceRemoteImplTest() {
    }
    
    private static ContextInfo contextInfo;
    private static TypeServiceRemoteImpl typeService;


    @BeforeClass
    public static void setUpClass() throws Exception {
        System.out.println("setting up services...");
        typeService = new TypeServiceRemoteImpl();
        typeService.setHostUrl(RemoteServiceConstants.ENV2_URL);
//        typeService.setHostUrl(RemoteServiceConstants.LOCAL_HOST_EMBEDDED_URL);
        contextInfo = new ContextInfo();
        contextInfo.setPrincipalId("testUser");
    }

    @AfterClass
    public static void tearDownClass() throws Exception {
    }
    @Before
    public void setUp() {
    }

    @After
    public void tearDown() {
    }

    @Test
    public void testTypeServiceGetRefObjectsUris() throws Exception {
        // test standard method
        List<String> refObjectUris = typeService.getRefObjectUris(contextInfo);
        System.out.println(refObjectUris.size() + " refObjectUris");
//        for (String refObjectUri : refObjectUris) {
//            System.out.println(refObjectUri);
//        }
    }

    @Test
    public void testTypeServiceSearchForTypeKeysAll() throws Exception {

        // test search for all
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
//        qBuilder.setPredicates(null);
        List<TypeInfo> infos = typeService.searchForTypes(qBuilder.build(), contextInfo);
        System.out.println("searched for types with null predicate size=" + infos.size());
//        for (String typeKey : typeKeys) {
//            System.out.println(typeKey);
//        }
    }

    @Test
    public void testTypeServiceSearchForTypeKeysKeywordAtp() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "atp"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<TypeInfo> infos = typeService.searchForTypes(qBuilder.build(), contextInfo);
        System.out.println("searched for types keyword = atp size=" + infos.size());
    }

    @Test
    public void testTypeServiceSearchForTypeKeysKeywordXYZZY() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        // test keyword search that finds nothing
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<TypeInfo> infos = typeService.searchForTypes(qBuilder.build(), contextInfo);
        System.out.println("searched for types keyword = zyzzy size=" + infos.size());
    }

    @Test
    public void testTypeServiceSearchFoorTypeTypeRelationAll() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        qBuilder = QueryByCriteria.Builder.create();
//        qBuilder.setPredicates(null);
        List<TypeTypeRelationInfo> infos = typeService.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
        System.out.println("searched for type type relations with null predicate size=" + infos.size());
//        for (String typeKey : typeKeys) {
//            System.out.println(typeKey);
//        }
    }

    @Test
    public void testTypeServiceTypeTypeRelationKeywordAtp() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();

        // test keyword search
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "atp"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<TypeTypeRelationInfo> infos = typeService.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
        System.out.println("searched for type type relations keyword = atp size=" + infos.size());
    }

    @Test
    public void testTypeServiceTypeTypeRelationKeywordXyzzy() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();

        // test keyword search that finds nothing
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<TypeTypeRelationInfo> infos = typeService.searchForTypeTypeRelations(qBuilder.build(), contextInfo);
        System.out.println("searched for type type relations keyword = xyzzy size=" + infos.size());
    }

}
