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
package org.kuali.student.loader.organization;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.kuali.student.r2.core.organization.service.OrganizationService;

/**
 *
 * @author nwright
 */
public class OrganizationLoaderFromCommandLine
{
  /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
  OrganizationLoaderFromCommandLine instance =
   new OrganizationLoaderFromCommandLine ();
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
  cfg.put (OrganizationInputModelFactory.EXCEL_FILES_KEY + "1", inFile);
  OrganizationInputModelFactory factory = new OrganizationInputModelFactory ();
  factory.setConfig (cfg);
  OrganizationInputModel orgModel = factory.getModel ();
  OrganizationLoader orgLoader = new OrganizationLoader ();
  OrganizationServiceFactory servFact = new OrganizationServiceFactory ();
  servFact.setHostUrl (hostUrl);
  OrganizationService organizationService = servFact.getOrganizationService ();
  orgLoader.setOrganizationService (organizationService);

  System.out.println (new Date () + " getting organizations...");
  List<Organization> organizations = orgModel.getOrganizations ();

  System.out.println (new Date () + " loading " + organizations.size ()
                      + " organizations");
//  ccLoader.setSource (organizations.subList (0, 10).iterator ());
  orgLoader.setInputDataSource (organizations);
  List<OrganizationLoadResult> results = orgLoader.load ();
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
  System.out.println (organizations.size () + " organizations");
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
