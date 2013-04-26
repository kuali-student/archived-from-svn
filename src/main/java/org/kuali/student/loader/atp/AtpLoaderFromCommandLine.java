/*
 * Copyright 2009 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.atp/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.loader.atp;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.kuali.student.r2.core.atp.service.AtpService;

/**
 *
 * @author nwright
 */
public class AtpLoaderFromCommandLine
{

 /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
  AtpLoaderFromCommandLine instance =
                           new AtpLoaderFromCommandLine ();
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
  cfg.put (AtpInputModelFactory.EXCEL_FILES_KEY + "1", inFile);
  AtpInputModelFactory factory = new AtpInputModelFactory ();
  factory.setConfig (cfg);
  AtpInputModel atpModel = factory.getModel ();
  AtpLoader atpLoader = new AtpLoader ();
  AtpServiceFactory servFact = new AtpServiceFactory ();
  servFact.setHostUrl (hostUrl);
  AtpService atpService = servFact.getAtpService ();
  atpLoader.setAtpService (atpService);

  System.out.println (new Date () + " getting atps...");
  List<Atp> atps = atpModel.getAtps ();

  System.out.println (new Date () + " loading " + atps.size ()
                      + " atps");
//  ccLoader.setSource (atps.subList (0, 10).iterator ());
  atpLoader.setInputDataSource (atps);
  List<AtpLoadResult> results = atpLoader.load ();
  // output good results
  for (AtpLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     System.out.println (result.getAtpInfo ().getId ()
                         + " " + result.getStatus ());
   }
  }
  for (AtpLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case UPDATED:
     System.out.println (result.getAtpInfo ().getId ()
                         + " " + result.getStatus ());
   }
  }


  // output summary
  for (AtpLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (atps.size () + " atps");
  for (AtpLoadResult.Status status :
       AtpLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (AtpLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
    case UPDATED:
    case NO_CHANGE:
     break;
    default:
     System.out.println (result);
   }
  }
  if (AtpLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (AtpLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (AtpLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (AtpLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
