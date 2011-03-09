/*
 * Copyright 2011 The Kuali Foundation
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
package org.kuali.student.contract.writer;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.List;

import org.kuali.student.contract.exception.DictionaryExecutionException;

/**
 *
 * @author nwright
 */
public class HtmlWriter extends XmlWriter
{

 private String directory;
 private String fileName;
 private String title;
 private ByteArrayOutputStream body;

 public HtmlWriter (String directory, String fileName, String title)
 {
  super ();
  this.body = new ByteArrayOutputStream (1000);
  this.setOut (new PrintStream (body));
  this.setIndent (0);
  this.directory = directory;
  this.fileName = fileName;
  this.title = title;
 }

 public ByteArrayOutputStream getBody ()
 {
  return body;
 }

 public String getDirectory ()
 {
  return directory;
 }

 public String getFileName ()
 {
  return fileName;
 }

 public void writeHeader ()
 {
  indentPrintln ("<html>");
  indentPrintln ("<head>");
  this.writeTag ("title", title);
  indentPrintln ("</head>");
  indentPrintln ("<body bgcolor=\"#ffffff\" topmargin=0 marginheight=0>");
 }

 public void writeHeaderBodyAndFooterOutToFile ()
 {

  File dir = new File (this.directory);
  //System.out.println ("Writing java class: " + fileName + " to " + dir.getAbsolutePath ());

  if ( ! dir.exists ())
  {
   if ( ! dir.mkdirs ())
   {
    throw new DictionaryExecutionException ("Could not create directory "
                                            + this.directory);
   }
  }
  try
  {
   PrintStream out = new PrintStream (new FileOutputStream (this.directory + "/" + fileName, false));
   this.setOut (out);
  }
  catch (FileNotFoundException ex)
  {
   throw new DictionaryExecutionException (ex);
  }
  writeHeader ();
  indentPrintln (body.toString ());
  indentPrintln ("</body>");
  decrementIndent ();
  indentPrintln ("</html>");
 }

 public void writeTable (List<String> headers, List<List<String>> rows)
 {
  this.indentPrintln ("<table>");
  incrementIndent ();
  this.indentPrintln ("<tr>");
  for (String header : headers)
  {
   this.writeTag ("th", header);
  }
  this.indentPrintln ("</tr>");
  for (List<String> row : rows)
  {
   this.indentPrintln ("<tr>");
   for (String cell : row)
   {
    this.writeTag ("td", cell);
   }
   this.indentPrintln ("</tr>");
  }
  this.indentPrintln ("</table>");
 }
}
