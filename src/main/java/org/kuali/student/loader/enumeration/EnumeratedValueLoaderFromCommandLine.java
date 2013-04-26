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
package org.kuali.student.loader.enumeration;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.kuali.student.r2.core.enumerationmanagement.service.EnumerationManagementService;

/**
 *
 * @author nwright
 */
public class EnumeratedValueLoaderFromCommandLine
{
  /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
  EnumeratedValueLoaderFromCommandLine instance =
   new EnumeratedValueLoaderFromCommandLine ();
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
  cfg.put (EnumeratedValueInputModelFactory.EXCEL_FILES_KEY + "1", inFile);
  EnumeratedValueInputModelFactory factory = new EnumeratedValueInputModelFactory ();
  factory.setConfig (cfg);
  EnumeratedValueInputModel evModel = factory.getModel ();
  EnumeratedValueLoader evLoader = new EnumeratedValueLoader ();
  EnumerationManagementServiceFactory servFact = new EnumerationManagementServiceFactory ();
  servFact.setHostUrl (EnumerationManagementServiceFactory.LOCAL_HOST_EMBEDDED_URL);
  EnumerationManagementService enumManService = servFact.getEnumerationManagementService ();
  evLoader.setEnumerationManagementService (enumManService);

  System.out.println (new Date () + " getting enumerated values...");
  List<EnumeratedValue> enumeratedValues = evModel.getEnumeratedValues ();

  System.out.println (new Date () + " loading " + enumeratedValues.size ()
                      + " enumerated values");
//  ccLoader.setSource (creditCourses.subList (0, 10).iterator ());
  evLoader.setInputDataSource (enumeratedValues);
  List<EnumeratedValueLoadResult> results = evLoader.update ();
  // output good results
  for (EnumeratedValueLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     System.out.println (result.getEnumeratedValueInfo ().getCode ()
                         + " " + result.getStatus () + " id = "
                         + result.getEnumeratedValueInfo ().getValue ());
   }
  }

  // output summary
  for (EnumeratedValueLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (enumeratedValues.size () + " enumerated values");
  for (EnumeratedValueLoadResult.Status status :
       EnumeratedValueLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (EnumeratedValueLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case VALIDATION_ERROR:
    case EXCEPTION:
     System.out.println (result);
   }
  }
  if (EnumeratedValueLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (EnumeratedValueLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (EnumeratedValueLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (EnumeratedValueLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
