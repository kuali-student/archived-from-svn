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
package org.kuali.student.loader.enumeration;

import java.util.Arrays;
import java.util.List;

import org.kuali.student.r2.common.dto.MetaInfo;
import org.kuali.student.r2.core.enumerationmanagement.dto.EnumeratedValueInfo;


/**
 *
 * @author nwright
 */
public class EnumeratedValueToEnumeratedValueInfoConverter
{


 private EnumeratedValue ev;

 public EnumeratedValueToEnumeratedValueInfoConverter (EnumeratedValue ev)
 {
  this.ev = ev;
 }

 public static final String ADMINISTRATION_ADMIN_ORG_TYPE = "kuali.adminOrg.type.Administration";
 public EnumeratedValueInfo convert ()
 {
  EnumeratedValueInfo info = new EnumeratedValueInfo ();
  info.setEnumerationKey(ev.getEnumerationKey());
  info.setCode (ev.getCode ());
  info.setAbbrevValue (ev.getAbbrevValue ());
  info.setValue (ev.getValue ());
  info.setEffectiveDate (ev.getEffectiveDate ());
  info.setExpirationDate (ev.getExpirationDate ());
  MetaInfo metaInfo = new MetaInfo();
  metaInfo.setCreateId("admin");
  info.setMeta(metaInfo);
  if (ev.getSortKey () != null)
  {
   info.setSortKey ("" + ev.getSortKey ());
  }
  return info;
 }


 private List<String> convertContexts (String contexts)
 {
  if (contexts == null)
  {
   return null;
  }
  return Arrays.asList (contexts.split (" "));
 }

}
