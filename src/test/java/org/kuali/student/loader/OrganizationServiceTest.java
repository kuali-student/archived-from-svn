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
package org.kuali.student.loader;

import java.util.List;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.kuali.student.core.dto.StatusInfo;
import org.kuali.student.core.exceptions.DoesNotExistException;
import org.kuali.student.core.exceptions.OperationFailedException;
import org.kuali.student.core.organization.dto.OrgInfo;
import org.kuali.student.core.organization.dto.OrgTypeInfo;
import org.kuali.student.core.organization.service.OrganizationService;
import static org.junit.Assert.*;

/**
 *
 * @author nwright
 */
public class OrganizationServiceTest
{

 public OrganizationServiceTest ()
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
 public static void tearDownClass () throws Exception
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
  * Test of getTypes method in OrgFinder
  */
 @Test
 public void testGetOrgTypes ()
 {
  System.out.println ("getOrgTypes");
//  List<OrgTypeInfo> expResult = new ArrayList ();
  List<OrgTypeInfo> result;
  try
  {
   result = organizationService.getOrgTypes ();
  }
  catch (OperationFailedException ex)
  {
   throw new RuntimeException (ex);
  }
  System.out.print (result.size () + " types returned");
  System.out.print ("Key");
  System.out.print ("|");
  System.out.print ("Name");
  System.out.print ("|");
  System.out.print ("getDesc");
  System.out.print ("|");
  System.out.print ("EffectiveDate");
  System.out.print ("|");
  System.out.print ("ExpirationDate");
  System.out.println ("|");
  for (OrgTypeInfo typeInfo : result)
  {
   System.out.print (typeInfo.getId ());
   System.out.print ("|");
   System.out.print (typeInfo.getName ());
   System.out.print ("|");
   System.out.print (typeInfo.getDescr ());
   System.out.print ("|");
   System.out.print (typeInfo.getEffectiveDate ());
   System.out.print ("|");
   System.out.print (typeInfo.getExpirationDate ());
   System.out.println ("|");
  }
  assertEquals (18, result.size ());
 }

 /**
  * Test of GetOrganization method in OrgFinder
  */
 @Test
 public void testGetOrganization ()
 {
  System.out.println ("getOrganization");

//  List<OrgTypeInfo> expResult = new ArrayList ();
  String id = "1";
  OrgInfo result;

  try
  {
   result = organizationService.getOrganization (id);
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  System.out.print (result.getId ());
  System.out.print ("|");
  System.out.print (result.getShortName ());
  System.out.println ("|");

 }

 /**
  * Test of CreateOrganization method in OrgFinder
  */
 @Test
 public void testOrganizationLifeCycle ()
 {
  System.out.println ("createOrganization");
//  List<OrgTypeInfo> expResult = new ArrayList ();
  OrgInfo info = new OrgInfo ();
  info.setType ("kuali.org.Department");
  info.setState ("active");
  info.setShortName ("short name");
  info.setLongName ("long name that is longer than the short name");
  info.setSortName ("sort name");
  OrgInfo result = null;
  try
  {
   result = organizationService.createOrganization (info.getType (), info);
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result);
  assertNotNull (result.getId ());
  assertEquals (info.getType (), result.getType ());
  assertEquals (info.getState (), result.getState ());
  assertEquals (info.getShortName (), result.getShortName ());
  assertEquals (info.getLongName (), result.getLongName ());
//  assertEquals (info.getSortName (), result.getSortName ());
  System.out.println ("id=" + result.getId ());

  // get it now
  info = result;
  try
  {
   result = organizationService.getOrganization (info.getId ());
  }
  catch (DoesNotExistException ex)
  {
   fail ("org was just created by cannot get it");
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
  assertNotNull (result.getId ());
  assertEquals (info.getType (), result.getType ());
  assertEquals (info.getState (), result.getState ());
  assertEquals (info.getShortName (), result.getShortName ());
  assertEquals (info.getLongName (), result.getLongName ());

  // now update it
  info = result;
  info.setLongName ("new long name");
  try
  {
   result = organizationService.updateOrganization (info.getId (), info);
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

  assertNotNull (result.getId ());
  assertEquals (info.getType (), result.getType ());
  assertEquals (info.getState (), result.getState ());
  assertEquals (info.getShortName (), result.getShortName ());
  assertEquals (info.getLongName (), result.getLongName ());


  // now delete
  info = result;
  StatusInfo status = null;
  try
  {
   status = organizationService.deleteOrganization (info.getId ());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }

  assertTrue (status.getSuccess ());

  // get it now
  info = result;
  try
  {
   result = organizationService.getOrganization (info.getId ());
   fail ("should not be able to get the org");
  }
  catch (DoesNotExistException ex)
  {
   System.out.println ("as expected org does not exist");
  }
  catch (Exception ex)
  {
   System.out.println (
     "The server does not throw a DoesNotExistException but oh well");
  }


 }
}
