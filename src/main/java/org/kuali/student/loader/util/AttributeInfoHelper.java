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
package org.kuali.student.loader.util;

import java.util.ArrayList;
import java.util.List;

import org.kuali.student.r2.common.dto.AttributeInfo;

/**
 *
 * @author nwright
 */
public class AttributeInfoHelper
{

 public List<AttributeInfo> setValue (String key, Object value,
                                      List<AttributeInfo> attributes)
 {
  if (value == null)
  {
   if (attributes == null)
   {
    return null;
   }
   attributes.remove (key);
   return attributes;
  }
  if (attributes == null)
  {
   attributes = new ArrayList ();
  }
  if (key != null && !key.isEmpty() && value != null) {
	  AttributeInfo attInfo = new AttributeInfo();
	  attInfo.setKey(key);
	  attInfo.setValue(value.toString());
	  attributes.add(attInfo);
  }
  return attributes;
 }
}
