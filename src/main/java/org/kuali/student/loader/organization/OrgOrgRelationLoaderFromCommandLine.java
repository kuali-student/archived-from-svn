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
public class OrgOrgRelationLoaderFromCommandLine
{
  /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
   OrgOrgRelationLoaderFromCommandLine instance =
   new OrgOrgRelationLoaderFromCommandLine ();
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
  OrgOrgRelationInputModelFactory factory = new OrgOrgRelationInputModelFactory ();
  factory.setConfig (cfg);
  OrgOrgRelationInputModel orgModel = factory.getModel ();
  OrgOrgRelationLoader orgLoader = new OrgOrgRelationLoader ();
  OrganizationServiceFactory servFact = new OrganizationServiceFactory ();
  servFact.setHostUrl (hostUrl);
  OrganizationService organizationService = servFact.getOrganizationService ();
  orgLoader.setOrganizationService (organizationService);

  System.out.println (new Date () + " getting orgorgrelations...");
  List<OrgOrgRelation> orgRelations = orgModel.getOrgOrgRelations();

  System.out.println (new Date () + " loading " + orgRelations.size ()
                      + " orgorgrelations");

  orgLoader.setInputDataSource (orgRelations);
  List<OrgOrgRelationLoadResult> results = orgLoader.load ();
  // output good results
  for (OrgOrgRelationLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     System.out.println (result.getRelationInfo().getOrgId()
                         + " to " + result.getRelationInfo().getRelatedOrgId() 
                         + " relation " + result.getStatus () + " id = "
                         + result.getRelationInfo ().getId ());
   }
  }

  // output summary
  for (OrgOrgRelationLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (orgRelations.size () + " orgorgrelations");
  for (OrgOrgRelationLoadResult.Status status :
	  OrgOrgRelationLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (OrgOrgRelationLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     break;
    default:
     System.out.println (result);
   }
  }
  if (OrgOrgRelationLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (OrgOrgRelationLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (OrgOrgRelationLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (OrgOrgRelationLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
