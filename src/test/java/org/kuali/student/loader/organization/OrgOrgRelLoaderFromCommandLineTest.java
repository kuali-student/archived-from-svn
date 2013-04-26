/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.loader.organization;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 *
 * @author nwright
 */
public class OrgOrgRelLoaderFromCommandLineTest
{

 public OrgOrgRelLoaderFromCommandLineTest ()
 {
 }

 @BeforeClass
 public static void setUpClass () throws Exception
 {
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
  * Test of main method, of class OrganizationLoaderFromCommandLine.
  */
 @Test
 public void testMain ()
 {
  System.out.println ("main");
  String[] args =
  {
   "src/main/" + OrgOrgRelationInputModelFactory.RESOURCES_DIRECTORY + "/"
   + OrgOrgRelationInputModelFactory.REFERENCE_ORGORGRELATION,
//   OrganizationServiceFactory.LOCAL_HOST_EMBEDDED_URL
   OrganizationServiceFactory.DEV_EMBEDDED_URL
  };
  OrgOrgRelationLoaderFromCommandLine.main (args);
 }
}
