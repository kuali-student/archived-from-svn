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
package org.kuali.student.loader.course;

import java.util.Date;
import java.util.List;
import java.util.Properties;


/**
 * 
 * @author Sedhu.Veera
 */
public class CourseDeleterFromCommandLine {

	/**
	 * @param args
	 *            the command line arguments
	 */
	public static void main(String[] args) {
		CourseDeleterFromCommandLine instance = new CourseDeleterFromCommandLine();
		instance.execute(args);

	}

	private void execute(String[] args) {
		if (args == null) {
			throw new RuntimeException("args is null");
		}
		if (args.length == 0) {
			throw new RuntimeException("no args specified");
		}
		if (args.length == 1) {
			throw new RuntimeException("no host url specified");
		}
		String in = args[0];
		String host = args[1];
		generate(in, host);
	}

	protected void generate(String inFile, String hostUrl) {
		Properties cfg = new Properties();
		cfg.put(CreditCourseInputModelFactory.EXCEL_FILES_KEY + "1", inFile);
		CreditCourseInputModelFactory factory = new CreditCourseInputModelFactory();
		factory.setConfig(cfg);
		CreditCourseInputModel ccModel = factory.getModel(CreditCourseInputModelFactory.CREDIT_COURSE_DELETER);
		CreditCourseDeleter ccDeleter = new CreditCourseDeleter();
		CourseServiceFactory servFactory = new CourseServiceFactory();
		servFactory.setHostUrl(hostUrl);
		ccDeleter.setCourseService(servFactory.getCourseService());


		System.out.println(new Date() + " getting credit courses...");
		List<CreditCourse> creditCourses = ccModel.getCreditCourses();

		System.out.println(new Date() + " loading " + creditCourses.size()
				+ " credit courses");
		// List<CreditCourse> list = creditCourses.subList (0, 10);
		List<CreditCourse> list = creditCourses;
		ccDeleter.setInputDataSource(list);
		List<CreditCourseDeleteResult> results = ccDeleter.update();

		// output good results
		for (CreditCourseDeleteResult result : results) {
			switch (result.getStatus()) {
			case DELETED:
				System.out.println(result.getCourseInfo().getCode() + " "
						+ result.getStatus() + " id = "
						+ result.getCreditCourse().getId());
			case DOES_NOT_EXISTS:
				System.out.println( result.getStatus() + " id = "
						+ result.getCreditCourse().getId());
			}
		}

		// output summary
		for (CreditCourseDeleteResult result : results) {
			result.getStatus().increment();
		}
		System.out.println(list.size() + " credit courses");
		for (CreditCourseDeleteResult.Status status : CreditCourseDeleteResult.Status
				.values()) {
			System.out.println("Total with status of " + status + " = "
					+ status.getCount());
		}

		// output errors
		for (CreditCourseDeleteResult result : results) {
			switch (result.getStatus()) {
			case DELETED:
			case DOES_NOT_EXISTS:
				break;
			default:
				System.out.println("CourseCode= " + result.getCourseInfo().getCode() +
						" " + result);
			}
		}
		if (CreditCourseDeleteResult.Status.DOES_NOT_EXISTS.getCount() > 0) {
			throw new RuntimeException(
					CreditCourseDeleteResult.Status.DOES_NOT_EXISTS.getCount()
							+ " records failed to load");
		}
		if (CreditCourseDeleteResult.Status.EXCEPTION.getCount() > 0) {
			throw new RuntimeException(
					CreditCourseDeleteResult.Status.EXCEPTION.getCount()
							+ "records failed to delete");
		}
	}
}
