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

import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.lum.clu.dto.CluInfo;
import org.kuali.student.r2.lum.clu.dto.CluSetInfo;

/**
 *
 * @author nwright
 */
public class StandardizedTestLoadResult
{

 public enum Status
 {
  CREATED_JUST_CLUSET,
  CREATED_BOTH,
  CREATED_JUST_CLU,
  NOT_PROCESSED_BOTH_ALREADY_EXISTS,
  CLU_VALIDATION_ERROR,
  CLUSET_VALIDATION_ERROR,
  EXCEPTION;

  private int count = 0;

  public int getCount ()
  {
   return count;
  }

  public void setCount (int count)
  {
   this.count = count;
  }

  public void increment ()
  {
   this.count++;
  }
 };
 private Status status;
 private int row;
 private StandardizedTest standardizedTest;
 private CluInfo cluInfo;
 private DataValidationErrorException dataValidationErrorException;
 private Exception exception;

 public CluInfo getCluInfo ()
 {
  return cluInfo;
 }

 public void setCluInfo (CluInfo cluInfo)
 {
  this.cluInfo = cluInfo;
 }

 private CluSetInfo cluSetInfo;

 public CluSetInfo getCluSetInfo ()
 {
  return cluSetInfo;
 }

 public void setCluSetInfo (CluSetInfo cluSetInfo)
 {
  this.cluSetInfo = cluSetInfo;
 }



 public StandardizedTest getStandardizedTest ()
 {
  return standardizedTest;
 }

 public void setStandardizedTest (StandardizedTest standardizedTest)
 {
  this.standardizedTest = standardizedTest;
 }

 public DataValidationErrorException getDataValidationErrorException ()
 {
  return dataValidationErrorException;
 }

 public void setDataValidationErrorException (
   DataValidationErrorException dataValidationErrorException)
 {
  this.dataValidationErrorException = dataValidationErrorException;
 }

 public Exception getException ()
 {
  return exception;
 }

 public void setException (Exception exception)
 {
  this.exception = exception;
 }

 public int getRow ()
 {
  return row;
 }

 public void setRow (int row)
 {
  this.row = row;
 }

 public Status getStatus ()
 {
  return status;
 }

 public void setStatus (Status status)
 {
  this.status = status;
 }

 @Override
 public String toString ()
 {
  StringBuilder builder = new StringBuilder ();
  builder.append (row);
  builder.append (". ");
  builder.append (status);
  builder.append (": ");
  builder.append (this.standardizedTest.getTest () + "-" + this.standardizedTest.getComponent ());
  builder.append (": ");
  if (this.exception != null)
  {
   builder.append (this.exception.getClass ().getName ());
   builder.append (": ");
   builder.append (this.exception.getMessage ());
  }
  if (this.dataValidationErrorException != null)
  {
   String comma = "";
   for (ValidationResultInfo vri :
        this.dataValidationErrorException.getValidationResults ())
   {
    builder.append (comma);
    comma = ", ";
    builder.append (vri);
   }
  }
  return builder.toString ();
 }
}
