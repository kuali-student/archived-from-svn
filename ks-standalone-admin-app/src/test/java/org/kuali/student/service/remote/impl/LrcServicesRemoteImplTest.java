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
import org.kuali.student.r2.lum.lrc.dto.ResultScaleInfo;
import org.kuali.student.r2.lum.lrc.dto.ResultValuesGroupInfo;
import org.kuali.student.r2.lum.util.constants.LrcServiceConstants;

/**
 *
 * @author nwright
 */
public class LrcServicesRemoteImplTest {

    public LrcServicesRemoteImplTest() {
    }
    
    private static ContextInfo contextInfo;
    private static LrcServiceRemoteImpl lrcService;


    @BeforeClass
    public static void setUpClass() throws Exception {
        System.out.println("setting up services...");
        lrcService = new LrcServiceRemoteImpl();
        lrcService.setHostUrl(RemoteServiceConstants.LOCAL_HOST_EMBEDDED_URL);
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
    public void testLRCServiceGetRefObjectsUris() throws Exception {
        // test standard method
        ResultValuesGroupInfo rvg = lrcService.getResultValuesGroup(LrcServiceConstants.RESULT_GROUP_KEY_GPA, contextInfo);
        System.out.println("gpa result values group=" + rvg.getName());
//        for (String refObjectUri : refObjectUris) {
//            System.out.println(refObjectUri);
//        }
    }

    @Test
    public void testLRCServiceSearchForRVGKeysAll() throws Exception {

        // test search for all
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
//        qBuilder.setPredicates(null);
        List<String> keys = lrcService.searchForResultValuesGroupIds(qBuilder.build(), contextInfo);
        System.out.println("searched for types with null predicate size=" + keys.size());
//        for (String typeKey : typeKeys) {
//            System.out.println(typeKey);
//        }
    }

    @Test
    public void testLRCServiceSearchForRVGKeysKeywordCredit() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "credit"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<ResultValuesGroupInfo> keys = lrcService.searchForResultValuesGroups(qBuilder.build(), contextInfo);
        System.out.println("searched for rvg keyword = credit size=" + keys.size());
    }

    @Test
    public void testLRCServiceSearchForRVGKeysKeywordXYZZY() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        // test keyword search that finds nothing
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<ResultValuesGroupInfo> keys = lrcService.searchForResultValuesGroups(qBuilder.build(), contextInfo);
        System.out.println("searched for rvg keyword = zyzzy size=" + keys.size());
    }

    @Test
    public void testLRCServiceSearchFoorResultScaleAll() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        qBuilder = QueryByCriteria.Builder.create();
//        qBuilder.setPredicates(null);
        List<ResultScaleInfo> ids = lrcService.searchForResultScales(qBuilder.build(), contextInfo);
        System.out.println("searched for result scale ids with null predicate size=" + ids.size());
//        for (String typeKey : typeKeys) {
//            System.out.println(typeKey);
//        }
    }

    @Test
    public void testLRCServiceResultScaleKeywordAtp() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();

        // test keyword search
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "grade"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<String> ids = lrcService.searchForResultScaleIds(qBuilder.build(), contextInfo);
        System.out.println("searched for result scale keyword = grade size=" + ids.size());
    }

    @Test
    public void testLRCServiceResultScaleKeywordXyzzy() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();

        // test keyword search that finds nothing
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<String> ids = lrcService.searchForResultScaleIds(qBuilder.build(), contextInfo);
        System.out.println("searched for result scale keyword = xyzzy size=" + ids.size());
    }

}
