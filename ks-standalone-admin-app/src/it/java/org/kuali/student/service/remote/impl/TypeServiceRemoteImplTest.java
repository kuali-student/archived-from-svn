/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import java.util.List;
import org.junit.*;
import static org.junit.Assert.*;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;

/**
 *
 * @author nwright
 */
public class TypeServiceRemoteImplTest {

    public TypeServiceRemoteImplTest() {
    }

    @BeforeClass
    public static void setUpClass() throws Exception {
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

    /**
     * Test of getUrl method, of class TypeServiceRemoteImpl.
     */
    @Test
    public void testConnection() throws InvalidParameterException,
            MissingParameterException,
            OperationFailedException,
            PermissionDeniedException {
        System.out.println("getConnection");
        TypeServiceRemoteImpl instance = new TypeServiceRemoteImpl();
        instance.setHostUrl(RemoteServiceConstants.ENV2_URL);
        ContextInfo contextInfo = new ContextInfo();
        contextInfo.setPrincipalId("testUser");
        List<String> refObjectUris = instance.getRefObjectUris(contextInfo);
        System.out.println(refObjectUris.size() + " refObjectUris");
        for (String refObjectUri : refObjectUris) {
            System.out.println(refObjectUri);
        }
    }
}
