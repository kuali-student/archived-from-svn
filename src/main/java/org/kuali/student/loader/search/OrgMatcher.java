/*
 * Copyright 2010 The Kuali Foundation
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
package org.kuali.student.loader.search;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import javax.xml.namespace.QName;


/**
 *
 * @author nwright
 */
public class OrgMatcher
{

 /**
  * find matching org
  * @param orgName
  * @param types
  * @return the matching org, null if none found
  */
 public OrgResultGeneric findMatch (String orgName, List<String> types, List<OrgResultGeneric> potential)
 {
  if (orgName == null)
  {
   return null;
  }

  List<OrgResultGeneric> matches = new ArrayList ();
  for (OrgResultGeneric org : potential)
  {
   if ( ! types.contains (org.getType ()))
   {
    continue;
   }
   if (org.getShortName ().toLowerCase ().contains (orgName.toLowerCase ()))
   {
    matches.add (org);
   }
   if (org.getLongName ().toLowerCase ().contains (orgName.toLowerCase ()))
   {
    matches.add (org);
   }
  }
  if (matches.size () == 1)
  {
   return matches.get (0);
  }
  return null;
 }

 
}
