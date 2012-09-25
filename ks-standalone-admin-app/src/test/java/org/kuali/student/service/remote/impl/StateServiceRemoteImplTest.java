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
import org.kuali.student.r2.core.class1.state.dto.LifecycleInfo;
import org.kuali.student.r2.core.class1.state.dto.StateInfo;
import org.kuali.student.r2.core.constants.AtpServiceConstants;

/**
 *
 * @author nwright
 */
@Ignore
public class StateServiceRemoteImplTest {

    public StateServiceRemoteImplTest() {
    }
    
    private static ContextInfo contextInfo;
    private static StateServiceRemoteImpl stateService;


    @BeforeClass
    public static void setUpClass() throws Exception {
        System.out.println("setting up services...");
        contextInfo = new ContextInfo();
        contextInfo.setPrincipalId("testUser");
        stateService = new StateServiceRemoteImpl();
//        stateService.setHostUrl(RemoteServiceConstants.LOCAL_HOST_EMBEDDED_URL);
        stateService.setHostUrl(RemoteServiceConstants.ENV2_URL);
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
    public void testStateServiceGetState() throws Exception {
        StateInfo state = stateService.getState(AtpServiceConstants.ATP_ATP_RELATION_INACTIVE_STATE_KEY, contextInfo);
        System.out.println("can lookoup state " + state.getKey());
    }

    @Test
    public void testStateServiceSearchForStateKeysAll() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<StateInfo> infos = stateService.searchForStates(qBuilder.build(), contextInfo);
        System.out.println("searched for states with null predicate size=" + infos.size());
    }

    @Test
    public void testStateServiceSearchForStateKeysKeywordDraft() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "draft"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<StateInfo> infos = stateService.searchForStates(qBuilder.build(), contextInfo);
        System.out.println("searched for states keyword=draft size=" + infos.size());
    }

    @Test
    public void testStateServiceSearchForStateKeysKeywordXyzzy() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        // test finding nothing
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        List<StateInfo> infos = stateService.searchForStates(qBuilder.build(), contextInfo);
        System.out.println("searched for states keyword=xyzzy size=" + infos.size());
    }

    @Test
    public void testStateServiceSearchForLifecycleKeysKeywordAll() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<LifecycleInfo> infos = stateService.searchForLifecycles(qBuilder.build(), contextInfo);
        System.out.println("searched for lifecycles with null predicate size=" + infos.size());
    }

    @Test
    public void testStateServiceSearchForLifecycleKeysKeywordAtp() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "atp"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        QueryByCriteria criteria = qBuilder.build();
        System.out.println ("1atp criteria.toString=" + criteria.toString());
        System.out.println ("2atp criteria.toString=" + qBuilder.build ().toString());
        List<LifecycleInfo> infos = stateService.searchForLifecycles(criteria, contextInfo);
        System.out.println("searched for lifecycle keyword=atp size=" + infos.size());
    }

    @Test
    public void testStateServiceSearchForLifecycleKeysKeywordXyzzy() throws Exception {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        pList.add(PredicateFactory.equal("keywordSearch", "xyzzy"));
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        QueryByCriteria criteria = qBuilder.build();
        System.out.println ("xyzzy criteria.toString=" + criteria.toString());
        List<LifecycleInfo> infos = stateService.searchForLifecycles(criteria, contextInfo);
        System.out.println("searched for lifecycle keyword=xyzzy size=" + infos.size());
    }

}
