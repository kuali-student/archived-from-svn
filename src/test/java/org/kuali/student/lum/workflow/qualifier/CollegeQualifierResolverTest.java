/*
 * Copyright 2007 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 1.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl1.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.lum.workflow.qualifier;

import static org.kuali.student.lum.workflow.qualifier.AbstractOrgQualifierResolver.COLLEGE;

import java.util.Arrays;
import java.util.List;

import org.easymock.EasyMock;
import org.junit.Test;
import org.kuali.rice.kew.engine.RouteContext;
import org.kuali.rice.kew.routeheader.DocumentContent;
import org.kuali.rice.kew.routeheader.StandardDocumentContent;
import org.kuali.rice.kim.bo.types.dto.AttributeSet;
import org.kuali.rice.test.BaseRiceTestCase;
import org.kuali.student.core.exceptions.DoesNotExistException;
import org.kuali.student.core.exceptions.InvalidParameterException;
import org.kuali.student.core.exceptions.MissingParameterException;
import org.kuali.student.core.exceptions.OperationFailedException;
import org.kuali.student.core.exceptions.PermissionDeniedException;
import org.kuali.student.core.organization.dto.OrgInfo;
import org.kuali.student.core.organization.service.OrganizationService;
import org.kuali.student.core.search.dto.Result;
import org.kuali.student.core.search.dto.ResultCell;


/**
 * Tests the XPathQualifierResolver.
 * 
 * @author Kuali Rice Team (kuali-rice@googlegroups.com)
 *
 */
public class CollegeQualifierResolverTest extends BaseRiceTestCase {
	
	private static final String SIMPLE_CLU_DOC_NO_ORG_XML =
								"<documentContent>" +
									"<applicationContent>" +
										"<cluProposal>" +
											"<cluId>Doc Type 1</cluId>" +
										"</cluProposal>" +
									"</applicationContent>" +
								"</documentContent>";
	
	private static final String SIMPLE_CLU_DOC_COLLEGE_XML =
								"<documentContent>" +
									"<applicationContent>" +
										"<cluProposal>" +
											"<cluId>Doc Type 1</cluId>" +
											"<orgId>31</orgId>" +
										"</cluProposal>" +
									"</applicationContent>" +
								"</documentContent>";
	
	private static final String SIMPLE_CLU_DOC_DEPT_XML =
								"<documentContent>" +
									"<applicationContent>" +
										"<cluProposal>" +
											"<cluId>Doc Type 1</cluId>" +
											"<orgId>64</orgId>" +
										"</cluProposal>" +
									"</applicationContent>" +
								"</documentContent>";
	
	OrganizationService mockOrgSvc = EasyMock.createMock(OrganizationService.class);
	
	
	@Test
	public void testResolveBasic() throws Exception {
		CollegeQualifierResolver resolver = new CollegeQualifierResolver();
		resolver.setOrganizationService(getMockOrgService());
		
		RouteContext context = new RouteContext();
		DocumentContent docContent = new StandardDocumentContent(SIMPLE_CLU_DOC_NO_ORG_XML);
		context.setDocumentContent(docContent);
		
		// shouldn't find a department, since there is none
		List<AttributeSet> attributeSets = resolver.resolve(context);
		assertEquals(0, attributeSets.size());
		
		// however, should succeed with this
		context = new RouteContext();
		docContent = new StandardDocumentContent(SIMPLE_CLU_DOC_COLLEGE_XML);
		context.setDocumentContent(docContent);
		
		attributeSets = resolver.resolve(context);
		assertEquals(1, attributeSets.size());
		assertEquals(2, attributeSets.get(0).size());
		assertEquals("Engineering", attributeSets.get(0).get(COLLEGE));
		
		// and this
		context = new RouteContext();
		docContent = new StandardDocumentContent(SIMPLE_CLU_DOC_DEPT_XML);
		context.setDocumentContent(docContent);
		
		attributeSets = resolver.resolve(context);
		assertEquals(2, attributeSets.size());
		AttributeSet set1 = attributeSets.get(0);
		AttributeSet set2 = attributeSets.get(1);
		
		assertEquals(2, set1.size());
		assertEquals(2, set2.size());
		
		String college1 = set1.get(AbstractOrgQualifierResolver.COLLEGE);
		String college2 = set2.get(AbstractOrgQualifierResolver.COLLEGE);
		assertTrue(college1.equals("Engineering") ^ college2.equals("Engineering"));
		assertTrue(college1.equals("Liberal Arts") ^ college2.equals("Liberal Arts"));
	}

	/**
	 * @return EasyMock-based mock OrganizationService
	 * 
	 * @throws PermissionDeniedException 
	 * @throws OperationFailedException 
	 * @throws MissingParameterException 
	 * @throws InvalidParameterException 
	 * @throws DoesNotExistException 
	 */
	@SuppressWarnings("unchecked")
	private OrganizationService getMockOrgService() throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
		EasyMock.reset(mockOrgSvc);
		
		OrgInfo mockCollege = new OrgInfo();
		mockCollege.setId("31");
		mockCollege.setType("kuali.org.College");
		mockCollege.setShortName("Engineering");
		EasyMock.expect(mockOrgSvc.getOrganization("31")).andReturn(mockCollege);
		
		OrgInfo mockCollege2 = new OrgInfo();
		mockCollege2.setId("43");
		mockCollege2.setType("kuali.org.College");
		mockCollege2.setShortName("Liberal Arts");
		EasyMock.expect(mockOrgSvc.getOrganization("43")).andReturn(mockCollege2);
		
		OrgInfo mockDepartment = new OrgInfo();
		mockDepartment.setId("64");
		mockDepartment.setType("kuali.org.Department");
		mockDepartment.setShortName("CompSci");
		EasyMock.expect(mockOrgSvc.getOrganization("64")).andReturn(mockDepartment);
		
		Result queryResult = new Result();
		ResultCell cell = new ResultCell();
		cell.setValue("kuali.org.hierarchy.Main");
		queryResult.setResultCells(Arrays.asList(cell));
		EasyMock.expect(mockOrgSvc.searchForResults(EasyMock.matches("org.search.hierarchiesOrgIsIn"), EasyMock.isA(List.class))).andReturn(Arrays.asList(queryResult));
		
		EasyMock.expect(mockOrgSvc.getAllAncestors("64", "kuali.org.hierarchy.Main")).andReturn(Arrays.asList("5", "31", "137", "43"));
		
		OrgInfo mockBoard = new OrgInfo();
		OrgInfo mockCommittee = new OrgInfo();
		mockBoard.setId("5");
		mockBoard.setType("kuali.org.Board");
		mockCommittee.setId("137");
		mockCommittee.setType("kuali.org.Committee");
		EasyMock.expect(mockOrgSvc.getOrganizationsByIdList(Arrays.asList("5", "31", "137", "43"))).andReturn(Arrays.asList(mockBoard, mockCollege, mockCommittee, mockCollege2));
		
		EasyMock.replay(mockOrgSvc);
		return mockOrgSvc;
	}
}
