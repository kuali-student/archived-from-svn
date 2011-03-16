/*
 * Copyright 2009 The Kuali Foundation
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
package org.kuali.student.contract.exception;

/**
 * Exception thrown when encounter an unexpected exeception when generating the dictionary
 * @author nwright
 */
public class DictionaryExecutionException extends DictionaryException
{

 public DictionaryExecutionException (Throwable cause)
 {
  super (cause);
 }

 public DictionaryExecutionException (String message, Throwable cause)
 {
  super (message, cause);
 }

 public DictionaryExecutionException (String message)
 {
  super (message);
 }

 public DictionaryExecutionException ()
 {
 }

}
