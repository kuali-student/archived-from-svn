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
package org.kuali.student.contract.model.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.Stack;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

import org.kuali.student.contract.model.MessageStructure;
import org.kuali.student.contract.model.Service;
import org.kuali.student.contract.model.ServiceContractModel;
import org.kuali.student.contract.model.ServiceMethod;
import org.kuali.student.contract.model.ServiceMethodParameter;
import org.kuali.student.contract.model.XmlType;
import org.kuali.student.contract.model.util.HtmlContractServiceWriter;
import org.kuali.student.contract.model.util.MessageStructureHierarchyDumper;
import org.kuali.student.contract.model.util.ModelFinder;
import org.kuali.student.contract.model.validation.ServiceContractModelValidator;

/**
 *
 * @author nwright
 */
public class ServiceContractModelQDoxLoaderTest {

    public ServiceContractModelQDoxLoaderTest() {
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

    private static final String RESOURCES_DIRECTORY = "src/test/resources";
    private static final String TEST_SOURCE_DIRECTORY =
            "src/test/java/org/kuali/student/contract/model/test/source";
    private static final String ENROLL_PROJECT_SRC_MAIN = "C:/svn/ks-1.3/ks-enroll/ks-enroll-api/src/main";
    private static final String ENROLL_PROJECT_JAVA_DIRECTORY = ENROLL_PROJECT_SRC_MAIN + "/java";
    
    private static ServiceContractModel model = null;
    private ServiceContractModel getModel() {
        if (model != null) {
            return model;
        }
        List<String> srcDirs = new ArrayList();
        System.out.println("User directory=" + System.getProperty("user.dir"));
        System.out.println("Current directory=" + new File(".").getAbsolutePath());
//        srcDirs.add (ENROLL_PROJECT_JAVA_DIRECTORY);
        srcDirs.add(TEST_SOURCE_DIRECTORY);
        ServiceContractModel instance = new ServiceContractModelQDoxLoader(srcDirs);
        instance = new ServiceContractModelCache(instance);
        validate(instance);
        model = instance;
        return instance;
    }

    private String dump(ServiceMethod method) {
        StringBuilder bldr = new StringBuilder();
        bldr.append(method.getName());
        String comma = "";
        bldr.append("(");
        for (ServiceMethodParameter param : method.getParameters()) {
            bldr.append(comma);
            comma = ", ";
            bldr.append(param.getType());
            bldr.append(" ");
            bldr.append(param.getName());
        }
        bldr.append(")");
        return bldr.toString();
    }

    private void validate(ServiceContractModel model) {
        Collection<String> errors =
                new ServiceContractModelValidator(model).validate();
        if (errors.size() > 0) {
            StringBuilder buf = new StringBuilder();
            buf.append(errors.size()).append(" errors found while validating the data.");
            int cnt = 0;
            for (String msg : errors) {
                cnt++;
                buf.append("\n");
                buf.append("*error*").append(cnt).append(":").append(msg);
            }

            fail(buf.toString());
        }
    }

    /**
     * Test of getServiceMethods method, of class ServiceContractModelQDoxLoader.
     */
    @Test
    public void testGetServiceMethods() {
        System.out.println("getServiceMethods");
        ServiceContractModel model = getModel();
        List<ServiceMethod> result = model.getServiceMethods();
        System.out.println("Number of methods=" + result.size());
        for (ServiceMethod method : result) {
            System.out.println(dump(method));
        }
        if (result.size() < 10) {
            fail("too few: " + result.size());
        }
    }

    /**
     * Test of getSourceNames method, of class ServiceContractModelQDoxLoader.
     */
    @Test
    public void testGetSourceNames() {
        System.out.println("getSourceNames");
        ServiceContractModel model = getModel();
        List<String> expResult = new ArrayList();
        expResult.add(TEST_SOURCE_DIRECTORY);
        List result = model.getSourceNames();
        assertEquals(expResult, result);
    }

    /**
     * Test of getServices method, of class ServiceContractModelQDoxLoader.
     */
    @Test
    public void testGetServices() {
        System.out.println("getServices");
        ServiceContractModel model = getModel();
        List<Service> result = model.getServices();
        for (Service service : result) {
            System.out.println(service.getKey() + " " + service.getName() + " "
                    + service.getVersion() + " " + service.getStatus());
        }
        assertEquals(4, result.size());
    }

    /**
     * Test of getXmlTypes method, of class ServiceContractModelQDoxLoader.
     */
    @Test
    public void testGetXmlTypes() {
        System.out.println("getXmlTypes");
        ServiceContractModel model = getModel();
        List<XmlType> result = model.getXmlTypes();
        for (XmlType xmlType : result) {
            System.out.println("XmlType=" + xmlType.getName() + " "
                    + xmlType.getPrimitive());
        }
        if (result.size() < 10) {
            fail("too few: " + result.size());
        }
    }

    /**
     * Test of getMessageStructures method, of class ServiceContractModelQDoxLoader.
     */
    @Test
    public void testGetMessageStructures() throws FileNotFoundException {
        System.out.println("getMessageStructures");
        ServiceContractModel model = getModel();
        List<MessageStructure> result = model.getMessageStructures();
        for (MessageStructure ms : result) {
            if (ms.getId().equalsIgnoreCase("academicCalendarInfo.typeKey")) {
                System.out.println("MessageStructure=" + ms.getId() + " " + ms.getType() + "required=["+ ms.getRequired() + "]");
            }
        }
        if (result.size() < 10) {
            fail("too few: " + result.size());
        }
        String outputFileName = "target/messageStructures.txt";
        File file = new File(outputFileName);
        PrintStream out = new PrintStream(file);
        new MessageStructureHierarchyDumper(out, model).writeTabbedHeader();
        Set<XmlType> rootTypes = HtmlContractServiceWriter.calcMainMessageStructures(
                model, null);
        ModelFinder finder = new ModelFinder(model);
        for (XmlType rootType : rootTypes) {
            Stack<String> stack = new Stack();
            stack.push(rootType.getName());
            for (MessageStructure ms : finder.findMessageStructures(rootType.getName())) {
                new MessageStructureHierarchyDumper(out, model).writeTabbedData(ms, stack);
            }
        }
    }
}
