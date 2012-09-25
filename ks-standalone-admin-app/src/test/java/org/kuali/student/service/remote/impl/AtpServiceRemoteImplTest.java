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
import org.kuali.student.r2.core.atp.dto.AtpAtpRelationInfo;
import org.kuali.student.r2.core.atp.dto.AtpInfo;
import org.kuali.student.r2.core.atp.dto.MilestoneInfo;
import org.kuali.student.r2.core.constants.AtpServiceConstants;

/**
 *
 * @author nwright
 */
//@Ignore
public class AtpServiceRemoteImplTest {

    public AtpServiceRemoteImplTest() {
    }
    
    private static ContextInfo contextInfo;
    private static AtpServiceRemoteImpl atpService;


    @BeforeClass
    public static void setUpClass() throws Exception {
        System.out.println("setting up services...");
        atpService = new AtpServiceRemoteImpl();
        atpService.setHostUrl(RemoteServiceConstants.ENV2_URL);
//        atpService.setHostUrl(RemoteServiceConstants.LOCAL_HOST_EMBEDDED_URL);
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
    public void testAtpServiceBasicAccess() throws Exception {
        System.out.println("testAtpService");
        List<String> ids = atpService.getAtpIdsByType(AtpServiceConstants.ATP_ACADEMIC_CALENDAR_TYPE_KEY, contextInfo);
        System.out.println("get atp infos of type acal size=" + ids.size());
    }

    @Test
    public void testAtpServiceSearchForAtpsAll() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        qBuilder.setMaxResults (30);
        List<AtpInfo> infos = atpService.searchForAtps(qBuilder.build(), contextInfo);
        System.out.println("searched for atps with null predicate size=" + infos.size());
    }

    @Test
    public void testAtpServiceSearchForAtpsFall() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "fall"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<AtpInfo> infos = atpService.searchForAtps(qBuilder.build(), contextInfo);
        System.out.println("searched for atps keyword=fall size=" + infos.size());
    }

    @Test
    public void testAtpServiceSearchForAtpsXyzzy() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<AtpInfo> infos = atpService.searchForAtps(qBuilder.build(), contextInfo);
        System.out.println("searched for atps keyword=xyzzy size=" + infos.size());
    }

    @Test
    public void testAtpServiceSearchForMilestonesAll() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<MilestoneInfo> infos = atpService.searchForMilestones(qBuilder.build(), contextInfo);
        System.out.println("searched for milestones with null predicate size=" + infos.size());
    }

    @Test
    public void testAtpServiceSearchForMilestonesRegistration() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "registration"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<MilestoneInfo> infos = atpService.searchForMilestones(qBuilder.build(), contextInfo);
        System.out.println("searched for milestones keyword=registration size=" + infos.size());
    }

    @Test
    public void testAtpServiceSearchForMilestonesXyzzy() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<MilestoneInfo> infos = atpService.searchForMilestones(qBuilder.build(), contextInfo);
        System.out.println("searched for milesones keyword=xyzzy size=" + infos.size());
    }
    
    
    @Test
    public void testAtpServiceSearchForAtpAtpRelationsAll() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<AtpAtpRelationInfo> infos = atpService.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
        System.out.println("searched for atp atp relations with null predicate size=" + infos.size());
    }

    @Test
    public void testAtpServiceSearchForAtpAtpRelationsFall() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "fall"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<AtpAtpRelationInfo> infos = atpService.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
        System.out.println("searched for atp atp relations keyword=fall size=" + infos.size());
    }

    @Test
    public void testAtpServiceSearchForAtpAtpRelationsXyzzy() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<AtpAtpRelationInfo> infos = atpService.searchForAtpAtpRelations(qBuilder.build(), contextInfo);
        System.out.println("searched for atp atp relations keyword=xyzzy size=" + infos.size());
    }
}
