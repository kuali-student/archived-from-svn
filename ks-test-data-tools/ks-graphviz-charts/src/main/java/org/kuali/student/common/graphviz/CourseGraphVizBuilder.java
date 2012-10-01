/*
 * Copyright 2012 The Kuali Foundation
 *
 * Licensed under the the Educational Community License, Version 1.0
 * (the "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl1.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.common.graphviz;

import org.kuali.student.r2.lum.course.infc.Activity;
import org.kuali.student.r2.lum.course.infc.Course;
import org.kuali.student.r2.lum.course.infc.Format;

/**
 * @author Kuali Student Team
 */
public class CourseGraphVizBuilder {

	public static GraphVizNode createCourseNode(Course course) {

		GraphVizNode courseNode = new GraphVizNode("Course");
		
		courseNode.setProperty ("ID", course.getId());
		courseNode.setProperty("State", course.getStateKey());
		
		for (Format format : course.getFormats()) {
	        
			GraphVizNode formatNode = createFormatNode(format);
        
			courseNode.addDependency(formatNode);
		}
		
		return courseNode;
		
	}

	public static GraphVizNode createFormatNode(Format format) {

		GraphVizNode formatNode = new GraphVizNode("Format");
		
		formatNode.setProperty ("ID", format.getId());
		formatNode.setProperty("State", format.getStateKey());
		
	for (Activity activity : format.getActivities()) {
	        
			GraphVizNode activityNode = createActivityNode(activity);
        
			formatNode.addDependency(activityNode);
		}
		
		return formatNode;
		
	}

	public static GraphVizNode createActivityNode(Activity activity) {
		
		GraphVizNode activityNode = new GraphVizNode("Activity");
		
		activityNode.setProperty("ID", activity.getId());
		activityNode.setProperty("State", activity.getStateKey());
		
		activityNode.setProperty("Type", activity.getTypeKey());
		
		return activityNode;
	}

	public static String generateGraphVizDotContent(Course course) {

		GraphVizBuilder builder = new GraphVizBuilder("course");
	
		GraphVizNode courseNode = createCourseNode(course);

		builder.addNode(courseNode);
		
		return builder.build();
		

	}

}
