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
package org.kuali.student.loader.course;

/**
 *
 * @author nwright
 */
public class CreditCourse
{
private String id;
private String code;
private String subjectArea;
private String courseNumberSuffix;
private String variation;
private String administeringOrgName;
private String administeringOrg;
private String transcriptTitle;
private String courseTitle;
private String descr;
private String minCredits;
private String maxCredits;
private String restrictions;
private String prereq;
private String prereqNL;
private String coreq;
private String coreqNL;
private String equivalencies;
private String gradingOptions;
private String termsOffered;
private String requirementsMet;
private String learningObjectives;
private String finalExam;
private String finalExamRationale;
private String startTerm;
private String endTerm;
private String formatActivities;
private String lecHr;
private String labHr;
private boolean audit;
private boolean passFail;
private boolean specialTopics;

 public String getId ()
 {
  return id;
 }

 public void setId (String id)
 {
  this.id = id;
 }


 public String getCode ()
 {
  return code;
 }

 public void setCode (String code)
 {
  this.code = code;
 }

 public String getCoreq ()
 {
  return coreq;
 }

 public String getVariation ()
 {
  return variation;
 }

 public void setVariation (String variation)
 {
  this.variation = variation;
 }

 
 public void setCoreq (String coreq)
 {
  this.coreq = coreq;
 }

 public String getCoreqNL ()
 {
  return coreqNL;
 }

 public void setCoreqNL (String coreqNL)
 {
  this.coreqNL = coreqNL;
 }

 public String getMinCredits() {
	return minCredits;
}

public void setMinCredits(String minCredits) {
	this.minCredits = minCredits;
}

public String getMaxCredits() {
	return maxCredits;
}

public void setMaxCredits(String maxCredits) {
	this.maxCredits = maxCredits;
}

public String getDescr ()
 {
  return descr;
 }

 public void setDescr (String descr)
 {
  this.descr = descr;
 }

 public String getSubjectArea ()
 {
  return subjectArea;
 }

 public void setSubjectArea (String subjectArea)
 {
  this.subjectArea = subjectArea;
 }

 public String getEquivalencies ()
 {
  return equivalencies;
 }

 public void setEquivalencies (String equivalencies)
 {
  this.equivalencies = equivalencies;
 }

 public String getGradingOptions ()
 {
  return gradingOptions;
 }

 public void setGradingOptions (String gradingOptions)
 {
  this.gradingOptions = gradingOptions;
 }

 public String getLearningObjectives ()
 {
  return learningObjectives;
 }

 public void setLearningObjectives (String learningObjectives)
 {
  this.learningObjectives = learningObjectives;
 }

 public String getTermsOffered ()
 {
  return termsOffered;
 }

 public void setTermsOffered (String termsOffered)
 {
  this.termsOffered = termsOffered;
 }

 public String getPrereqNL ()
 {
  return prereqNL;
 }

 public void setPrereqNL (String prereqNL)
 {
  this.prereqNL = prereqNL;
 }

 public String getPrereq ()
 {
  return prereq;
 }

 public void setPrereq (String prereq)
 {
  this.prereq = prereq;
 }

 public String getAdministeringOrgName ()
 {
  return administeringOrgName;
 }

 public void setAdministeringOrgName (String name)
 {
  this.administeringOrgName = name;
 }

 public String getAdministeringOrg ()
 {
  return administeringOrg;
 }

 public void setAdministeringOrg (String orgId)
 {
  this.administeringOrg = orgId;
 }

 public String getRequirementsMet ()
 {
  return requirementsMet;
 }

 public void setRequirementsMet (String requirementsMet)
 {
  this.requirementsMet = requirementsMet;
 }

 public String getRestrictions ()
 {
  return restrictions;
 }

 public void setRestrictions (String restrictions)
 {
  this.restrictions = restrictions;
 }

 public String getTranscriptTitle ()
 {
  return transcriptTitle;
 }

 public void setTranscriptTitle (String title)
 {
  this.transcriptTitle = title;
 }

 public String getCourseTitle ()
 {
  return courseTitle;
 }

 public void setCourseTitle (String title)
 {
  this.courseTitle = title;
 }

 public String getCourseNumberSuffix ()
 {
  return courseNumberSuffix;
 }

 public void setCourseNumberSuffix (String suffixCode)
 {
  this.courseNumberSuffix = suffixCode;
 }

 public String getFinalExam ()
 {
  return finalExam;
 }

 public void setFinalExam (String finalExam)
 {
  this.finalExam = finalExam;
 }

 public String getFinalExamRationale ()
 {
  return finalExamRationale;
 }

 public void setFinalExamRationale (String finalExamRationale)
 {
  this.finalExamRationale = finalExamRationale;
 }

public String getStartTerm() {
	return startTerm;
}

public void setStartTerm(String startTerm) {
	this.startTerm = startTerm;
}

public String getEndTerm() {
	return endTerm;
}

public void setEndTerm(String endTerm) {
	this.endTerm = endTerm;
}

public String getFormatActivities() {
	return formatActivities;
}

public void setFormatActivities(String formatActivities) {
	this.formatActivities = formatActivities;
}

public String getLecHr() {
	return lecHr;
}

public void setLecHr(String lecHr) {
	this.lecHr = lecHr;
}

public String getLabHr() {
	return labHr;
}

public void setLabHr(String labHr) {
	this.labHr = labHr;
}

public boolean isAudit() {
	return audit;
}

public void setAudit(boolean audit) {
	this.audit = audit;
}

public boolean isPassFail() {
	return passFail;
}

public void setPassFail(boolean passFail) {
	this.passFail = passFail;
}

public boolean isSpecialTopics() {
	return specialTopics;
}

public void setSpecialTopics(boolean specialTopics) {
	this.specialTopics = specialTopics;
}

}
