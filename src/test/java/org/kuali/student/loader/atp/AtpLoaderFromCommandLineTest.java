/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.loader.atp;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 *
 * @author nwright
 */
public class AtpLoaderFromCommandLineTest
{

 public AtpLoaderFromCommandLineTest ()
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
  * Test of main method, of class AtpLoaderFromCommandLine.
  */
 @Test
 public void testMain ()
 {
  System.out.println ("main");
  String[] args =
  {
   "src/main/" + AtpInputModelFactory.RESOURCES_DIRECTORY + "/"
   + AtpInputModelFactory.ATP_CALENDAR,
   AtpServiceFactory.LOCAL_HOST_EMBEDDED_URL
//   AtpServiceFactory.DEV_EMBEDDED_URL
  };
  AtpLoaderFromCommandLine.main (args);
 }
}
