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
package org.kuali.student.loader.standardizedtest;

import java.util.Date;
import java.util.List;
import java.util.Properties;

/**
 *
 * @author nwright
 */
public class StandardizedTestLoaderFromCommandLine
{

 /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
  StandardizedTestLoaderFromCommandLine instance =
                                    new StandardizedTestLoaderFromCommandLine ();
  instance.execute (args);

 }

 private void execute (String[] args)
 {
  if (args == null)
  {
   throw new RuntimeException ("args is null");
  }
  if (args.length == 0)
  {
   throw new RuntimeException ("no args specified");
  }
  if (args.length == 1)
  {
   throw new RuntimeException ("no host url specified");
  }
  String in = args[0];
  String host = args[1];
  generate (in, host);
 }

 protected void generate (String inFile, String hostUrl)
 {
  Properties cfg = new Properties ();
  cfg.put (StandardizedTestInputModelFactory.EXCEL_FILES_KEY + "1", inFile);
  StandardizedTestInputModelFactory factory = new StandardizedTestInputModelFactory ();
  factory.setConfig (cfg);
  StandardizedTestInputModel ccModel = factory.getModel ();
  StandardizedTestLoader ccLoader = new StandardizedTestLoader ();
  LuServiceFactory servFactory = new LuServiceFactory ();
  servFactory.setHostUrl (hostUrl);
  ccLoader.setLuService (servFactory.getCluService ());

  System.out.println (new Date () + " getting standardized tests...");
  List<StandardizedTest> standardizedTests = ccModel.getStandardizedTests ();

  System.out.println (new Date () + " loading " + standardizedTests.size ()
                      + " standardized tests");
//  List<StandardizedTest> list = standardizedTests.subList (0, 10);
  List<StandardizedTest> list = standardizedTests;
  ccLoader.setInputDataSource (list);
  List<StandardizedTestLoadResult> results = ccLoader.update ();

  // output good results
  for (StandardizedTestLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED_BOTH:
    case NOT_PROCESSED_BOTH_ALREADY_EXISTS:
     System.out.println (result.getCluInfo ().getOfficialIdentifier ().getCode ()
                         + " " + result.getStatus () + " id = "
                         + result.getCluInfo ().getId ());
   }
  }

  // output summary
  for (StandardizedTestLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (list.size () + " standardized tests");
  for (StandardizedTestLoadResult.Status status :
       StandardizedTestLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (StandardizedTestLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED_BOTH:
    case NOT_PROCESSED_BOTH_ALREADY_EXISTS:
     break;
    default:
     System.out.println (result);
   }
  }
  if (StandardizedTestLoadResult.Status.CLU_VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (StandardizedTestLoadResult.Status.CLU_VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (StandardizedTestLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (StandardizedTestLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
