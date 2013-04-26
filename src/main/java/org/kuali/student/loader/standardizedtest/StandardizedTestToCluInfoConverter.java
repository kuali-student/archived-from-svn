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
package org.kuali.student.loader.standardizedtest;

import org.kuali.student.loader.util.AdminOrgInfoHelper;
import org.kuali.student.loader.util.RichTextInfoHelper;
import org.kuali.student.r2.lum.clu.dto.AdminOrgInfo;
import org.kuali.student.r2.lum.clu.dto.CluIdentifierInfo;
import org.kuali.student.r2.lum.clu.dto.CluInfo;


/**
 *
 * @author nwright
 */
public class StandardizedTestToCluInfoConverter
{


 private StandardizedTest st;

 public StandardizedTestToCluInfoConverter (StandardizedTest st)
 {
  this.st = st;
 }

 public static final String ADMIN_ORG_TYPE = "kuali.adminOrg.type.TestOversightDivision";
 public static final String OFFICIAL_IDENTIFIER_TYPE = "kuali.lu.type.test.identifier.official";
 public CluInfo convert ()
 {
  CluInfo info = new CluInfo ();
  info.setId (st.getId ());
  AdminOrgInfo adminOrgInfo = new AdminOrgInfoHelper ().get (ADMIN_ORG_TYPE, st.getOrgId ());
  if (adminOrgInfo != null)
  {
   info.getAdminOrgs ().add (adminOrgInfo);
  }
  info.setDescr (new RichTextInfoHelper ().getFromPlain (st.getDescr ()));
  // TODO: figure out why the code calculation doesn't get triggered if I leave it null
  CluIdentifierInfo idInfo = new CluIdentifierInfo ();
  info.setOfficialIdentifier (idInfo);
  idInfo.setType (OFFICIAL_IDENTIFIER_TYPE);
  idInfo.setState ("Active");
  idInfo.setCode (st.getTest () + "-" + st.getComponent ());
  idInfo.setDivision (st.getTest ());
  idInfo.setSuffixCode (st.getComponent ());
  idInfo.setLevel (st.getLevel ());
  idInfo.setShortName (st.getShortName ());
  idInfo.setLongName (st.getLongName ());
  info.setType (st.getType ());
  info.setState (st.getState ());
  info.setEffectiveDate (st.getEffective ());
  info.setExpirationDate (st.getExpiration ());
  return info;
 }

}
