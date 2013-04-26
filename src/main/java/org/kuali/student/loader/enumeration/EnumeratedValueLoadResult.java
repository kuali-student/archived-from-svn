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

import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.core.enumerationmanagement.dto.EnumeratedValueInfo;

/**
 *
 * @author nwright
 */
public class EnumeratedValueLoadResult
{

 public enum Status
 {

  CREATED,
  ALREADY_EXISTS,
  VALIDATION_ERROR,
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
   this.count ++;
  }
 };
 private Status status;
 private int row;
 private EnumeratedValue enumeratedValue;
 private EnumeratedValueInfo enumeratedValueInfo;
 private DataValidationErrorException dataValidationErrorException;
 private Exception exception;

 public EnumeratedValueInfo getEnumeratedValueInfo ()
 {
  return enumeratedValueInfo;
 }

 public void setEnumeratedValueInfo (EnumeratedValueInfo enumeratedValueInfo)
 {
  this.enumeratedValueInfo = enumeratedValueInfo;
 }

 public EnumeratedValue getEnumeratedValue ()
 {
  return enumeratedValue;
 }

 public void setEnumeratedValue (EnumeratedValue creditCourse)
 {
  this.enumeratedValue = creditCourse;
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
  builder.append (this.enumeratedValue.getCode ());
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
