/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.loader.enumeration;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 *
 * @author nwright
 */
public class EnumeratedValueLoaderFromCommandLineTest
{

 public EnumeratedValueLoaderFromCommandLineTest ()
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
  * Test of main method, of class EnumeratedValueLoaderFromCommandLine.
  */
 @Test
 public void testMain ()
 {
  System.out.println ("main");
  String[] args =
  {
   "src/main/" + EnumeratedValueInputModelFactory.RESOURCES_DIRECTORY + "/"
     + "NewReferenceSubjectAreaEnumerations.xls",
//   + EnumeratedValueInputModelFactory.EXTRA_ENUMERATED_VALUES_BSCI_XLS,
   EnumerationManagementServiceFactory.LOCAL_HOST_EMBEDDED_URL
  };
  EnumeratedValueLoaderFromCommandLine.main (args);
 }


}
