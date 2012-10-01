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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingClusterInfo;
import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingSetInfo;
import org.kuali.student.enrollment.courseoffering.dto.FormatOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.RegistrationGroupInfo;
import org.kuali.student.enrollment.courseoffering.infc.CourseOffering;
import org.kuali.student.enrollment.courseoffering.infc.FormatOffering;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;

/**
 * @author Kuali Student Team
 */
public class CourseOfferingGraphVizBuilder {

	private static GraphVizNode createCourseOfferingNode(CourseOffering course) {

		GraphVizNode courseNode = new GraphVizNode("Course Offering");

		courseNode.setProperty("ID", course.getId());
		courseNode.setProperty("State", course.getStateKey());

		return courseNode;

	}

	private static GraphVizNode createFormatOfferingNode(FormatOffering format) {

		GraphVizNode formatNode = new GraphVizNode("Format");

		formatNode.setProperty("ID", format.getId());
		formatNode.setProperty("State", format.getStateKey());

		return formatNode;

	}

	private static GraphVizNode createActivityOfferingNode(ActivityOfferingInfo activity) {

		GraphVizNode activityNode = new GraphVizNode("Activity");

		activityNode.setProperty("ID", activity.getId());
		activityNode.setProperty("State", activity.getStateKey());

		activityNode.setProperty("Type", activity.getTypeKey());

		return activityNode;
	}

	private static GraphVizNode createActivityOfferingSetNode(ActivityOfferingSetInfo activityOfferingSetInfo) {

		GraphVizNode activityNode = new GraphVizNode("AOSet");

		activityNode.setProperty("ID", activityOfferingSetInfo.getId());
		activityNode.setProperty("Type",
		        activityOfferingSetInfo.getActivityOfferingType());

		return activityNode;
	}

	private static GraphVizNode createActivityOfferingClusterNode(ActivityOfferingClusterInfo activityOfferingClusterInfo) {

		GraphVizNode activityNode = new GraphVizNode("AOC");

		activityNode.setProperty("ID", activityOfferingClusterInfo.getId());

		return activityNode;
	}

	private static GraphVizNode createRegistrationGroupNode(RegistrationGroupInfo registrationGroupInfo) {

		GraphVizNode activityNode = new GraphVizNode("Reg Group");

		activityNode.setProperty("ID", registrationGroupInfo.getId());
		activityNode.setProperty("State", registrationGroupInfo.getStateKey());
		
		return activityNode;
	}

	public static String generateGraphVizDotContent(CourseOfferingService service,
	        CourseOffering course,
	        ContextInfo contextInfo) throws DoesNotExistException,
	        InvalidParameterException, MissingParameterException,
	        OperationFailedException, PermissionDeniedException {

		Map<String, GraphVizNode> formatOfferingIdToNode = new HashMap<String, GraphVizNode>();
		Map<String, GraphVizNode> activitiyOfferingIdToNode = new HashMap<String, GraphVizNode>();

		GraphVizBuilder builder = new GraphVizBuilder("courseoffering");

		GraphVizNode courseNode = createCourseOfferingNode(course);

		builder.addNode(courseNode);

		// process formats
		List<FormatOfferingInfo> formatOfferings = service
		        .getFormatOfferingsByCourseOffering(course.getId(), contextInfo);

		for (FormatOfferingInfo format : formatOfferings) {

			GraphVizNode formatNode = createFormatOfferingNode(format);

			courseNode.addDependency(formatNode);

			formatOfferingIdToNode.put(format.getId(), formatNode);

			// load in all of the AO's for the format
			List<ActivityOfferingInfo> activities = service
			        .getActivityOfferingsByFormatOffering(format.getId(),
			                contextInfo);

			for (ActivityOfferingInfo activityOfferingInfo : activities) {

				GraphVizNode activityNode = createActivityOfferingNode(activityOfferingInfo);

				// formatNode.addDependency(activityNode);

				activitiyOfferingIdToNode.put(activityOfferingInfo.getId(),
				        activityNode);

			}

			// load in all of the AOC
			List<ActivityOfferingClusterInfo> aocs = service
			        .getActivityOfferingClustersByFormatOffering(
			                format.getId(), contextInfo);

			for (ActivityOfferingClusterInfo activityOfferingClusterInfo : aocs) {

				GraphVizNode aocNode = createActivityOfferingClusterNode(activityOfferingClusterInfo);

				formatNode.addDependency(aocNode);

				GraphVizSubGraphBuilder subGraphBuilder = new GraphVizSubGraphBuilder(extractGraphName(activityOfferingClusterInfo)
				        );

				builder.addSubGraphBuilder(subGraphBuilder);

				subGraphBuilder.addNode(aocNode);

				List<RegistrationGroupInfo> regGroups = service
				        .getRegistrationGroupsByActivityOfferingCluster(
				                activityOfferingClusterInfo.getId(),
				                contextInfo);

				for (RegistrationGroupInfo registrationGroupInfo : regGroups) {

					GraphVizNode regGroupNode = createRegistrationGroupNode(registrationGroupInfo);

					// not sure if this link is needed.
					// aocNode.addDependency(regGroupNode);

					List<String> containedAOIds = registrationGroupInfo
					        .getActivityOfferingIds();

					for (String activityOfferingId : containedAOIds) {

						GraphVizNode activityNode = activitiyOfferingIdToNode
						        .get(activityOfferingId);

						subGraphBuilder.addNode(activityNode);

						activityNode.addDependency(regGroupNode);
					}
				}

			}

			// check for unassigned AO's
			List<ActivityOfferingInfo> unassignedAOs = service
			        .getActivityOfferingsWithoutClusterByFormatOffering(
			                format.getId(), contextInfo);

			if (unassignedAOs.size() > 0) {
				GraphVizSubGraphBuilder unassignedBuilder = new GraphVizSubGraphBuilder(
				        "Unassigned");

				builder.addSubGraphBuilder(unassignedBuilder);

				for (ActivityOfferingInfo unassignedAO : unassignedAOs) {

					GraphVizNode aoNode = activitiyOfferingIdToNode
					        .get(unassignedAO.getId());

					unassignedBuilder.addNode(aoNode);
					
					formatNode.addDependency(aoNode);

				}
			}
		}

		return builder.build();

	}

	private static String extractGraphName(ActivityOfferingClusterInfo activityOfferingClusterInfo) {
		
		String name = activityOfferingClusterInfo.getName();
		
		String privateName = activityOfferingClusterInfo.getPrivateName();
		
		if (privateName == null)
			return name;
		else
			return name + "(" + privateName + ")";
    }

}
