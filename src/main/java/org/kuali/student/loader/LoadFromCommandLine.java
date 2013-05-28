/*
 * Copyright 2009 The Kuali Foundation
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

import java.io.PrintStream;
import org.kuali.student.loader.atp.AtpLoaderFromCommandLine;
import org.kuali.student.loader.course.CourseDeleterFromCommandLine;
import org.kuali.student.loader.course.CreditCourseLoaderFromCommandLine;
import org.kuali.student.loader.enumeration.EnumeratedValueLoaderFromCommandLine;
import org.kuali.student.loader.organization.OrgOrgRelationLoaderFromCommandLine;
import org.kuali.student.loader.organization.OrganizationLoaderFromCommandLine;
import org.kuali.student.loader.organization.PosRestrictionLoaderFromCommandLine;
import org.kuali.student.loader.program.ProgramLoaderFromCommandLine;
import org.kuali.student.loader.rules.RulesDataLoaderFromCommandLine;
import org.kuali.student.loader.standardizedtest.StandardizedTestLoaderFromCommandLine;

/**
 *
 * @author nwright
 */
public class LoadFromCommandLine
{

 /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
  LoadFromCommandLine instance =
                      new LoadFromCommandLine ();
  instance.execute (args);

 }

 private void displayVersion ()
 {
  displayVersion (System.out);
 }

 public void displayVersion (PrintStream out)
 {
  //TODO: figure out how to get the version from the Maven property
  out.println ("Kuali Student Loader: Version 0.94");
  out.println ("        Built on December 10, 2010");
 }

 private void displayParameters (String whatToLoad, String inFile,
                                 String outFile)
 {
  displayParameters (System.out, whatToLoad, inFile, outFile);
 }

 public void displayParameters (PrintStream out, String whatToLoad,
                                String inFile, String hostURL)
 {
  out.println ("Loading:" + whatToLoad);
  out.println ("Reading: " + inFile);
  out.println ("Updating: " + hostURL);
 }

 private void displayUsage ()
 {
  displayUsage (System.out);
 }

 public void displayUsage (PrintStream out)
 {
  out.println (
    "Usage: java -jar ks-loader.jar <whatToLoad> <inputExcel> <hostUrl>");
  out.println (
    "\t@param whatToLoad 'organization', 'orgorgrelation', 'orgpositionrestriction', 'course', 'program', 'enumeration', 'atp' or 'test' (for standardized tests)");
  out.println (
    "\t@param inputExcel the fully qualified file name for the specially formatted input excel file");
  out.println (
    "\t@param hostUrl the fully qualified url of the running Kuali Student web service");
  out.println (
    "ex: java -jar ks-loader.jar organization AccreditingBodies.xls http://localhost:8081/ks-with-rice-bundled-dev");
 }

 private void execute (String[] args)
 {
  displayVersion ();
  if (args == null)
  {
   displayUsage ();
   throw new RuntimeException ("no parameters specified");
  }
  if (args.length == 0)
  {
   displayUsage ();
   throw new RuntimeException ("no parameters specified");
  }
  if (args.length == 1)
  {
   displayUsage ();
   throw new RuntimeException ("no input excel file and no host url specified");
  }
  if (args.length == 2)
  {
   displayUsage ();
   throw new RuntimeException ("no host url specified");
  }
  String whatToLoad = args[0];
  String in = args[1];
  String host = args[2];
  generate (whatToLoad, in, host);
 }

 protected void generate (String whatToLoad, String inFile, String hostUrl)
 {
  if (whatToLoad.equalsIgnoreCase ("courseLoader"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   CreditCourseLoaderFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("courseDeleter"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   CourseDeleterFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("program"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   ProgramLoaderFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("organization"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   OrganizationLoaderFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("orgorgrelation"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   OrgOrgRelationLoaderFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("orgpositionrestriction"))
  {
	  System.out.println("Loading orgpositionrestrictions");
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   PosRestrictionLoaderFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("test"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   StandardizedTestLoaderFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("atp"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   AtpLoaderFromCommandLine.main (args);
   return;
  }
  if (whatToLoad.equalsIgnoreCase ("enumeration"))
  {
   displayParameters (whatToLoad, inFile, hostUrl);
   String[] args = new String[2];
   args[0] = inFile;
   args[1] = hostUrl;
   EnumeratedValueLoaderFromCommandLine.main (args);
   return;
  }
     if (whatToLoad.equalsIgnoreCase("rules")) {
         displayParameters(whatToLoad, inFile, hostUrl);
         String[] args = new String[2];
         args[0] = inFile;
         args[1] = hostUrl;
         RulesDataLoaderFromCommandLine.main(args);
         return;
     }
  displayUsage ();
  displayParameters (whatToLoad, inFile, hostUrl);
  throw new RuntimeException ("Unknown type of object to be loaded " + whatToLoad);
 }
}
