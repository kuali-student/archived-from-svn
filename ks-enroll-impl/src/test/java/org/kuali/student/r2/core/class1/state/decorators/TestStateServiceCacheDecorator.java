/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.r2.core.class1.state.decorators;

import static org.junit.Assert.assertEquals;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.RichTextInfo;
import org.kuali.student.r2.core.class1.state.dto.LifecycleInfo;
import org.kuali.student.r2.core.class1.state.dto.StateInfo;
import org.kuali.student.r2.core.class1.state.mock.StateServiceMockImpl;
import org.kuali.student.r2.core.class1.state.service.StateService;

/**
 *
 * @author nwright
 */
public class TestStateServiceCacheDecorator {
    
    public TestStateServiceCacheDecorator() {
    }

    @BeforeClass
    public static void setUpClass()
            throws Exception {
    }

    @AfterClass
    public static void tearDownClass()
            throws Exception {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    @Test
    public void testLifecycleCache()
            throws Exception {
        System.out.println("testLifecycleCache");
        ContextInfo contextInfo = new ContextInfo ();
        contextInfo.setPrincipalId("TESTUSER");
        
        StateServiceMockImpl mock = new StateServiceMockImpl ();
        
        setupStateServiceData(mock);
        
        StateServiceCacheDecorator instance = new StateServiceCacheDecorator();
        instance.setNextDecorator(mock);
        
        QueryByCriteria.Builder criteria = QueryByCriteria.Builder.create ();
        
        // duplicated to get it the 2nd time from the cache
        assertEquals (mock.searchForStateKeys(criteria.build(), contextInfo), instance.searchForStateKeys(criteria.build(), contextInfo));
        assertEquals (mock.searchForStateKeys(criteria.build(), contextInfo), instance.searchForStateKeys(criteria.build(), contextInfo));
        
        // duplicated to get it the 2nd time from the cache
        assertEquals (mock.searchForStates(criteria.build(), contextInfo), instance.searchForStates(criteria.build(), contextInfo));
        assertEquals (mock.searchForStates(criteria.build(), contextInfo), instance.searchForStates(criteria.build(), contextInfo));
        
        // duplicated to get it the 2nd time from the cache
        assertEquals (mock.searchForLifecycleKeys(criteria.build(), contextInfo), instance.searchForLifecycleKeys(criteria.build(), contextInfo));
        assertEquals (mock.searchForLifecycleKeys(criteria.build(), contextInfo), instance.searchForLifecycleKeys(criteria.build(), contextInfo));
        
        // duplicated to get it the 2nd time from the cache
        assertEquals (mock.searchForLifecycles(criteria.build(), contextInfo), instance.searchForLifecycles(criteria.build(), contextInfo));
        assertEquals (mock.searchForLifecycles(criteria.build(), contextInfo), instance.searchForLifecycles(criteria.build(), contextInfo));
        
    }

	private void setupStateServiceData(StateService service) throws Exception {
		
		 addLifecycle(service, "kuali.atp.process", "ATP Lifecycle", "Lifecycle process for Academic Time Periods.", "");
		         addState(service, "kuali.atp.process", "kuali.atp.state.Draft", "Draft", "Indicates that this ATP is tentative.");
		         addState(service, "kuali.atp.process", "kuali.atp.state.Official", "Official", "Indicates that this ATP has been established.");
		
		         addLifecycle(service, "kuali.milestone.process", "Milestone Lifecycle", "Lifecycle process for Milestones.", "");
		        addState(service, "kuali.milestone.process", "kuali.milestone.state.Draft", "Draft", "Indicates that this Milestone is tentative.");
		        addState(service, "kuali.milestone.process", "kuali.milestone.state.Official", "Official", "Indicates that this Milestone has been established.");     
	}
	

    private void addLifecycle(StateService service, String key, String name, String desc, String ref)
        throws Exception {

        LifecycleInfo lifecycle = new LifecycleInfo();
        lifecycle.setName(name);

        RichTextInfo rtDesc = new RichTextInfo();
        rtDesc.setPlain(desc);
        rtDesc.setFormatted(desc);
        lifecycle.setDescr(rtDesc);
        lifecycle.setKey(key);
        lifecycle.setRefObjectUri(ref);

        service.createLifecycle(key, lifecycle, new ContextInfo());
    }

    private void addState(StateService service, String lifecycleKey, String key, String name, String desc)
        throws Exception {

        StateInfo state = new StateInfo();
        state.setName(name);

        RichTextInfo rtDesc = new RichTextInfo();
        rtDesc.setPlain(desc);
        rtDesc.setFormatted(desc);
        state.setDescr(rtDesc);

        service.createState(lifecycleKey, key, state, new ContextInfo());
    }

}
