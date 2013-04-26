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
public class PosRestrictionLoaderFromCommandLine
{
  /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
   PosRestrictionLoaderFromCommandLine instance =
   new PosRestrictionLoaderFromCommandLine ();
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
  cfg.put (PositionRestrictionInputModelFactory.EXCEL_FILES_KEY + "1", inFile);
  PositionRestrictionInputModelFactory factory = new PositionRestrictionInputModelFactory ();
  factory.setConfig (cfg);
  PositionRestrictionInputModel orgModel = factory.getModel ();
  PositionRestrictionLoader orgLoader = new PositionRestrictionLoader ();
  OrganizationServiceFactory servFact = new OrganizationServiceFactory ();
  servFact.setHostUrl (hostUrl);
  OrganizationService organizationService = servFact.getOrganizationService ();
  orgLoader.setOrganizationService (organizationService);

  System.out.println (new Date () + " getting positionrestrictions...");
  List<OrgPositionRestriction> posRestrictions = orgModel.getOrgPositionRestrictions();

  System.out.println (new Date () + " loading " + posRestrictions.size ()
                      + " positionrestrictions");

  orgLoader.setInputDataSource (posRestrictions);
  List<PositionRestrictionLoadResult> results = orgLoader.load ();
  // output good results
  for (PositionRestrictionLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     System.out.println (result.getPosRestriction().getOrgShortName()
                         + " " + result.getStatus () + " id = "
                         + result.getPosRestrictionInfo().getId ());
   }
  }

  // output summary
  for (PositionRestrictionLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (posRestrictions.size () + " OrgPositionRestrictions");
  for (PositionRestrictionLoadResult.Status status :
	  PositionRestrictionLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (PositionRestrictionLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case CREATED:
     break;
    default:
     System.out.println (result);
   }
  }
  if (PositionRestrictionLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (PositionRestrictionLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (PositionRestrictionLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (PositionRestrictionLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
