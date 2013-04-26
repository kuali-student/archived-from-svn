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
package org.kuali.student.loader.program;

import java.util.Date;

/**
 *
 * @author nwright
 */
public class CIPCodeHelper
{

 public String formatCIP (String cip)
 {
  if (cip == null)
  {
   return null;
  }
  if (cip.length () == 6)
  {
   return cip.substring (0, 2) + "." + cip.substring (2);
  }
  if (cip.length () == 4)
  {
   return cip.substring (0, 2) + "." + cip.substring (2);
  }
  if (cip.length () == 2)
  {
   return cip;
  }
  return cip;
 }


 
}
