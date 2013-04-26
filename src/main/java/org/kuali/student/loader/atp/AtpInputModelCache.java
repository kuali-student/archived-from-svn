/*
d * Copyright 2010 The Kuali Foundation
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
package org.kuali.student.loader.atp;

import java.util.List;


/**
 *
 * @author nwright
 */
public class AtpInputModelCache implements AtpInputModel
{

 public AtpInputModelCache (AtpInputModel model)
 {
  this.model = model;
 }

 private AtpInputModel model;

 public AtpInputModel getLoaderModel ()
 {
  return model;
 }

 public void setLoaderModel (AtpInputModel loaderModel)
 {
  this.model = loaderModel;
 }

 private static List<Atp> atps = null;

 @Override
 public List<Atp> getAtps ()
 {
  if (atps != null)
  {
   return atps;
  }
  atps = model.getAtps ();
  return atps;
 }


}
