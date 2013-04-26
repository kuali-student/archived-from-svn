/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.loader;

import static org.junit.Assert.assertEquals;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 *
 * @author nwright
 */
public class LoadFromCommandLineTest
{

 public LoadFromCommandLineTest ()
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
  * Test of main method, of class LoadFromCommandLine.
  */
 @Test
 public void testMain ()
 {
  System.out.println ("main");
  String[] args = null;
  try
  {
  LoadFromCommandLine.main (args);
  }
  catch (RuntimeException ex)
  {
   assertEquals ("no parameters specified", ex.getMessage ());
  }
 }


}
