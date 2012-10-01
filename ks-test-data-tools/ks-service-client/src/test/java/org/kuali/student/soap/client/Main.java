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
package org.kuali.student.soap.client;

import java.io.File;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.common.graphviz.CourseOfferingGraphVizBuilder;
import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.CourseOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.FormatOfferingInfo;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author Kuali Student Team
 */
public class Main {

	private static final int ACTIVITY_LIMIT = 25;
	private static Logger log = LoggerFactory.getLogger(Main.class);
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		ClassPathXmlApplicationContext applicationContext = new ClassPathXmlApplicationContext("applicationContext.xml");
		
		CourseOfferingService coService = applicationContext.getBean("coService", CourseOfferingService.class);

		ContextInfo contextInfo = new ContextInfo();
		
		contextInfo.setCurrentDate(new Date());
		contextInfo.setPrincipalId("soap-client");
		contextInfo.setAuthenticatedPrincipalId("soap-client");
		
		File outputDirectory= new File("dot");
		
		FileUtils.deleteQuietly(outputDirectory);
		
		outputDirectory.mkdirs();
		
		
		
		try {
			
//		 List<String> courseIds = courseService.searchForCourseIds(QueryByCriteria.Builder.create().fromPredicates(), contextInfo);
	     
//		 log.warn(courseIds.size() + " course ids");
		
			List<CourseOfferingInfo> cos = coService.searchForCourseOfferings(QueryByCriteria.Builder.create().build(), contextInfo);
			
			Set<CourseOfferingInfo>largeNumberOfActivitiesSet = new HashSet<CourseOfferingInfo>();
			
			int counter = 0;
			
			for (CourseOfferingInfo courseOfferingInfo : cos) {
	            
				List<ActivityOfferingInfo> aos = coService.getActivityOfferingsByCourseOffering(courseOfferingInfo.getId(), contextInfo);
				
				
				
				if (aos == null) {
					// this is a CXF bug.
					// zero activityOfferings results in nulls.
//					log.warn("aos == null for course offering: " + courseOfferingInfo.toString());
				}
				if (aos != null && aos.size() > ACTIVITY_LIMIT) {
					
					List<FormatOfferingInfo>fos = coService.getFormatOfferingsByCourseOffering(courseOfferingInfo.getId(), contextInfo);
					
					Set<String>formatTypes = new LinkedHashSet<String>();
					
					for (FormatOfferingInfo formatOfferingInfo : fos) {
	                    
						formatTypes.addAll(formatOfferingInfo.getActivityOfferingTypeKeys());
						
                    }
					
					counter++;
					
					log.warn(counter + "adding course " + courseOfferingInfo.getId() + " with " + StringUtils.join(formatTypes, ", ") + " activity types and " +aos.size() + " activities");
					
					String graphVizChartContent = CourseOfferingGraphVizBuilder.generateGraphVizDotContent(coService, courseOfferingInfo, contextInfo);
					
					FileUtils.write(new File (outputDirectory, counter + "-aos-" + aos.size() + ".dat"), graphVizChartContent);
					
					largeNumberOfActivitiesSet.add(courseOfferingInfo);
				}
            }
			
			log.info(largeNumberOfActivitiesSet.size() + " courses with > " + ACTIVITY_LIMIT + " activities");
			
			
			
//			List<FormatOfferingInfo>fos = coService.searchForFormatOfferings(QueryByCriteria.Builder.create().build(), contextInfo);
//			List<ActivityOfferingInfo> aos = coService.searchForActivityOfferings(QueryByCriteria.Builder.create().build(), contextInfo);
//			List<ActivityOfferingClusterInfo>aocs = coService.searchForActivityOfferingClusters(QueryByCriteria.Builder.create().build(), contextInfo);
	        
			log.warn(cos.size() + " course offerings.");
//			log.warn(fos.size() + " course offerings.");
//			log.warn(aos.size() + " course offerings.");
//			log.warn(aocs.size() + " course offerings.");
	       
        } catch (Exception e) {
        	log.error("fatal error: ", e);
        } 
		
	}

}
