/*
 * Copyright 2010 The Kuali Foundation
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
package org.kuali.student.loader.organization;

import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.r2.core.organization.service.OrganizationService;

/**
 *
 * @author nwright
 */
public class OrganizationLoaderTest
{

 public OrganizationLoaderTest ()
 {
 }

 private static OrganizationService organizationService;

 @BeforeClass
 public static void setUpClass () throws Exception
 {
  OrganizationServiceFactory factory = new OrganizationServiceFactory ();
  factory.setHostUrl (OrganizationServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  organizationService = factory.getOrganizationService ();
 }

 @AfterClass
 public static void tearDownClass ()
   throws Exception
 {
 }

 @Before
 public void setUp ()
 {
 }

 @After
 public void tearDown ()
 {
 }

 /**
  * Test of load method, of class OrgLoader.
  */
 @Test
 public void testLoadOrganizations ()
   throws Exception
 {
  System.out.println (new Date () + " load organizations");

  OrganizationLoader ccLoader = new OrganizationLoader ();
  ccLoader.setOrganizationService (organizationService);
  OrganizationInputModel ccModel = OrganizationInputModelFactoryTest.getInstance ().
    getModel ();

  System.out.println (new Date () + " getting organizations...");
  List<Organization> orgs = ccModel.getOrganizations ();

  System.out.println (new Date () + " loading " + orgs.size ()
                      + " organizations");
//  ccLoader.setInputDataSource (orgs.subList (372, 373).iterator ());
  ccLoader.setInputDataSource (orgs);
  List<OrganizationLoadResult> results = ccLoader.load ();
    // output good results
  for (OrganizationLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     System.out.println (result.getOrgInfo ().getShortName ()
                         + " " + result.getStatus () + " id = "
                         + result.getOrgInfo ().getId ());
   }
  }

  // output summary
  for (OrganizationLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (orgs.size () + " organizations");
  for (OrganizationLoadResult.Status status :
       OrganizationLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (OrganizationLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     break;
    default:
     System.out.println (result);
   }
  }
  if (OrganizationLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (OrganizationLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (OrganizationLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (OrganizationLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
