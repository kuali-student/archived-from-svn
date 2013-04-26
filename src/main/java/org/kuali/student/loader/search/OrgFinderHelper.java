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

import java.util.ArrayList;
import java.util.List;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;
import org.kuali.student.r2.core.search.dto.SearchParamInfo;
import org.kuali.student.r2.core.search.dto.SearchRequestInfo;
import org.kuali.student.r2.core.search.dto.SearchTypeInfo;
import org.kuali.student.r2.core.search.infc.SearchResult;
import org.kuali.student.r2.core.search.infc.SearchResultRow;
import org.kuali.student.r2.core.search.service.SearchService;


/**
 *
 * @author nwright
 */
public class OrgFinderHelper
{


 private SearchService searchService;

 public SearchService getSearchService ()
 {
  return searchService;
 }

 public void setSearchService (SearchService searchService)
 {
  this.searchService = searchService;
 }


 public List<OrgResultGeneric> getAll ()
 {
  SearchService service = getSearchService ();
ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();

//  System.out.println ("Invoking search request to get all org result generics...");
  SearchRequestInfo req = new SearchRequestInfo ();
  req.setSearchKey ("org.search.generic");
//  System.out.println ("getSearchKey ()=" + req.getSearchKey ());
  SearchResult result = null;
  try
  {
   result = service.search (req, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
//  System.out.println (result.getRows ().size () + " rows returned");
  List<OrgResultGeneric> list = new ArrayList ();
  for (SearchResultRow row : result.getRows ())
  {
   OrgResultGeneric org = new OrgResultGeneric ();
   org.setOrgId (row.getCells ().get (0).getValue ());
   org.setShortName (row.getCells ().get (1).getValue ());
   org.setLongName (row.getCells ().get (2).getValue ());
   org.setType (row.getCells ().get (3).getValue ());
  }
  return list;
 }

 public List<OrgResultGeneric> getAllWithType (String type)
 {
  SearchService service = getSearchService ();
  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
//  System.out.println ("Invoking search request to get all org result generics...");
  SearchRequestInfo req = new SearchRequestInfo ();
  req.setSearchKey ("org.search.generic");
  SearchParamInfo param = new SearchParamInfo ();
  param.setKey ("org.queryParam.orgOptionalType");
  List<String> values = new ArrayList<String>();
		  values.add(type);
  param.setValues (values);
  req.getParams ().add (param);
//  System.out.println ("getSearchKey ()=" + req.getSearchKey ());
  SearchResult result = null;
  try
  {
   result = service.search (req, ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
//  System.out.println (result.getRows ().size () + " rows returned");
  List<OrgResultGeneric> list = new ArrayList ();
  for (SearchResultRow row : result.getRows ())
  {
   OrgResultGeneric org = new OrgResultGeneric ();
   org.setOrgId (row.getCells ().get (0).getValue ());
   org.setShortName (row.getCells ().get (1).getValue ());
   org.setLongName (row.getCells ().get (2).getValue ());
   org.setType (row.getCells ().get (3).getValue ());
  }
  return list;
 }

 /**
  * find matching org
  * @param orgName
  * @param types
  * @return the orgId of the matching org, null if none found
  */
 public String findMatch (String orgName, List<String> types)
 {
  if (orgName == null)
  {
   return null;
  }

  OrgResultGeneric org = new OrgMatcher ().findMatch (orgName, types, getAll ());
  return org.getOrgId ();
 }

// public List<SearchTypeInfo> getSearchTypes ()
// {
//  SearchService service = getSearchService ();
//  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
////  System.out.println ("Invoking get search types search request...");
//  try
//  {
//   return (List<SearchTypeInfo>) service.getSearchTypes (ctxInfoHelper.getDefaultContextInfo());
//  }
//  catch (Exception ex)
//  {
//   throw new RuntimeException (ex);
//  }
// }

 public List<TypeInfo> getTypeInfos ()
 //TODO: Verify with the above implementation
 {
  SearchService service = getSearchService ();
  ContextInfoHelper ctxInfoHelper = new ContextInfoHelper();
//  System.out.println ("Invoking get search types search request...");
  try
  {
   return service.getSearchTypes (ctxInfoHelper.getDefaultContextInfo());
  }
  catch (Exception ex)
  {
   throw new RuntimeException (ex);
  }
 }
}
