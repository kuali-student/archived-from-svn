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
package org.kuali.student.loader.program;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.kuali.student.loader.atp.AtpServiceFactory;
import org.kuali.student.loader.organization.OrganizationServiceFactory;
import org.kuali.student.r2.core.atp.service.AtpService;
import org.kuali.student.r2.core.organization.service.OrganizationService;

/**
 *
 * @author nwright
 */
public class ProgramLoaderFromCommandLine
{

 /**
  * @param args the command line arguments
  */
 public static void main (String[] args)
 {
  ProgramLoaderFromCommandLine instance =
                                    new ProgramLoaderFromCommandLine ();
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
  cfg.put (ProgramInputModelFactory.EXCEL_FILES_KEY + "1", inFile);
  ProgramInputModelFactory factory = new ProgramInputModelFactory ();
  factory.setConfig (cfg);
  ProgramInputModel progModel = factory.getModel ();
  ProgramLoader progLoader = new ProgramLoader ();
  ProgramServiceFactory servFactory = new ProgramServiceFactory ();
  servFactory.setHostUrl (hostUrl);
  progLoader.setProgramService (servFactory.getProgramService ());
  
  AtpServiceFactory aptServFactory = new AtpServiceFactory();
  aptServFactory.setHostUrl(hostUrl);
  AtpService atpService = aptServFactory.getAtpService();
  progLoader.getHelperService().put("atp", atpService);
  
  OrganizationServiceFactory orgServFactory = new OrganizationServiceFactory ();
  orgServFactory.setHostUrl (hostUrl);
  OrganizationService orgService = orgServFactory.getOrganizationService ();
  progLoader.getHelperService().put("org", orgService);
  
  System.out.println (new Date () + " getting programs...");
  List<Program> programs = progModel.getPrograms ();

  System.out.println (new Date () + " loading " + programs.size ()
                      + " programs");
//  List<Program> list = programs.subList (0, 10);
  List<Program> list = programs;
  progLoader.setInputDataSource (list);
  List<ProgramLoadResult> results = progLoader.update ();

  // output good results
  for (ProgramLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case MAJOR_DISCIPLINE_CREATED:
    case VARIATION_PROCESSED_WITH_MAJOR_DISCIPLINE:
     System.out.println (result.getMajorDisciplineInfo ().getCode ()
                         + " " + result.getStatus () + " id = "
                         + result.getMajorDisciplineInfo ().getId ());
   }
  }

  // output summary
  for (ProgramLoadResult result : results)
  {
   result.getStatus ().increment ();
  }
  System.out.println (list.size () + " programs");
  for (ProgramLoadResult.Status status :
       ProgramLoadResult.Status.values ())
  {
   System.out.println ("Total with status of " + status + " = "
                       + status.getCount ());
  }

  // output errors
  for (ProgramLoadResult result : results)
  {
   switch (result.getStatus ())
   {
    case MAJOR_DISCIPLINE_CREATED:
    case VARIATION_PROCESSED_WITH_MAJOR_DISCIPLINE:
     break;
    default:
     System.out.println (result);
   }
  }
  if (ProgramLoadResult.Status.VALIDATION_ERROR.getCount () > 0)
  {
   throw new RuntimeException (ProgramLoadResult.Status.VALIDATION_ERROR.getCount ()
                               + " records failed to load");
  }
  if (ProgramLoadResult.Status.EXCEPTION.getCount () > 0)
  {
   throw new RuntimeException (ProgramLoadResult.Status.EXCEPTION.getCount ()
                               + " records failed to load");
  }
 }
}
