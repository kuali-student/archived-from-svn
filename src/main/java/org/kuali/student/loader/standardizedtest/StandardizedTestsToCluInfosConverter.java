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

import java.util.ArrayList;
import java.util.List;

import org.kuali.student.r2.lum.clu.dto.CluInfo;

/**
 *
 * @author nwright
 */
public class StandardizedTestsToCluInfosConverter
{

 private List<StandardizedTest> sts;

 public StandardizedTestsToCluInfosConverter (List<StandardizedTest> sts)
 {
  this.sts = sts;
 }
 public static final String STANDARIZED_TEST_TYPE =
                            "kuali.lu.type.standardized.test";

 public List<StandardizedTestLoadResult> convert ()
 {
  List<StandardizedTestLoadResult> results = new ArrayList (this.sts.size ());
  int row = 0;
  // do non-components first
  for (StandardizedTest st : sts)
  {
   StandardizedTestLoadResult result = new StandardizedTestLoadResult ();
   results.add (result);
   result.setStandardizedTest (st);
   result.setRow (row);
   row ++;
   CluInfo info = new StandardizedTestToCluInfoConverter (st).convert ();
   result.setCluInfo (info);
  }
  return results;
 }
}
