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

import java.util.Date;

/**
 *
 * @author nwright
 */
public class StandardizedTest
{

 private String id;
 private String parentId;
 private String test;
 private String component;
 private String type;
 private String state;
 private Date effective;
 private Date expiration;
 private String level;
 private String orgName;
 private String orgId;
 private String shortName;
 private String longName;
 private String descr;
 private String minScore;
 private String maxScore;


 public String getParentId ()
 {
  return parentId;
 }

 public void setParentId (String parentId)
 {
  this.parentId = parentId;
 }

 public String getComponent ()
 {
  return component;
 }

 public void setComponent (String component)
 {
  this.component = component;
 }

 public String getDescr ()
 {
  return descr;
 }

 public void setDescr (String descr)
 {
  this.descr = descr;
 }

 public Date getEffective ()
 {
  return effective;
 }

 public void setEffective (Date effective)
 {
  this.effective = effective;
 }

 public Date getExpiration ()
 {
  return expiration;
 }

 public void setExpiration (Date expiration)
 {
  this.expiration = expiration;
 }

 public String getId ()
 {
  return id;
 }

 public void setId (String id)
 {
  this.id = id;
 }

 public String getLevel ()
 {
  return level;
 }

 public void setLevel (String level)
 {
  this.level = level;
 }

 public String getLongName ()
 {
  return longName;
 }

 public void setLongName (String longName)
 {
  this.longName = longName;
 }

 public String getOrgId ()
 {
  return orgId;
 }

 public void setOrgId (String orgId)
 {
  this.orgId = orgId;
 }

 public String getOrgName ()
 {
  return orgName;
 }

 public void setOrgName (String orgName)
 {
  this.orgName = orgName;
 }

 public String getShortName ()
 {
  return shortName;
 }

 public void setShortName (String shortName)
 {
  this.shortName = shortName;
 }

 public String getState ()
 {
  return state;
 }

 public void setState (String state)
 {
  this.state = state;
 }

 public String getTest ()
 {
  return test;
 }

 public void setTest (String test)
 {
  this.test = test;
 }

 public String getType ()
 {
  return type;
 }

 public void setType (String type)
 {
  this.type = type;
 }

 public String getMaxScore ()
 {
  return maxScore;
 }

 public void setMaxScore (String maxScore)
 {
  this.maxScore = maxScore;
 }

 public String getMinScore ()
 {
  return minScore;
 }

 public void setMinScore (String minScore)
 {
  this.minScore = minScore;
 }

 
}
