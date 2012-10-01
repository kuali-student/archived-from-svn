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
package org.kuali.student.service.decorator;

import java.util.ArrayList;
import java.util.List;

import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.enrollment.courseoffering.dto.AOClusterVerifyResultsInfo;
import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingClusterInfo;
import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingDisplayInfo;
import org.kuali.student.enrollment.courseoffering.dto.ActivityOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.CourseOfferingDisplayInfo;
import org.kuali.student.enrollment.courseoffering.dto.CourseOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.FormatOfferingInfo;
import org.kuali.student.enrollment.courseoffering.dto.RegistrationGroupInfo;
import org.kuali.student.enrollment.courseoffering.dto.SeatPoolDefinitionInfo;
import org.kuali.student.enrollment.courseoffering.service.CourseOfferingService;
import org.kuali.student.enrollment.courseofferingset.dto.SocRolloverResultItemInfo;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.AlreadyExistsException;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DependentObjectsExistException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.common.exceptions.ReadOnlyException;
import org.kuali.student.r2.common.exceptions.VersionMismatchException;
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;

/**
 * @author Kuali Student Team
 * 
 * There is a bug in the 2.3.8 version of CXF that is included from rice.
 * 
 * It causes nulls to be returned where a collection has zero elements.
 * 
 * This decorator will wrap the methods that return List<?> and return an empty list if the CXF proxy returns null.
 * 
 */
public class NullSafeCXFCourseOfferingServiceDecorator implements
        CourseOfferingService {

	private CourseOfferingService nextDecorator;
	
	/**
	 * 
	 */
	public NullSafeCXFCourseOfferingServiceDecorator() {
		// TODO Auto-generated constructor stub
	}
	
	

	public void setNextDecorator(CourseOfferingService nextDecorator) {
		this.nextDecorator = nextDecorator;
	}



	public StatusInfo generateRegistrationGroupsForFormatOffering(String formatOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            DataValidationErrorException {
	    return nextDecorator.generateRegistrationGroupsForFormatOffering(
	            formatOfferingId, context);
    }



	public StatusInfo generateRegistrationGroupsForCluster(String activityOfferingClusterId,
            ContextInfo contextInfo) throws DoesNotExistException,
            DataValidationErrorException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
	    return nextDecorator.generateRegistrationGroupsForCluster(
	            activityOfferingClusterId, contextInfo);
    }



	public TypeInfo getCourseOfferingType(String courseOfferingTypeKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getCourseOfferingType(courseOfferingTypeKey,
	            contextInfo);
    }



	public List<TypeInfo> getCourseOfferingTypes(ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<TypeInfo> list = nextDecorator.getCourseOfferingTypes(contextInfo);

	    if (list == null)
	    	return new ArrayList<TypeInfo>();
	    else
	    	return list;
    }



	public List<TypeInfo> getInstructorTypesForCourseOfferingType(String courseOfferingTypeKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<TypeInfo> list = nextDecorator.getInstructorTypesForCourseOfferingType(
	            courseOfferingTypeKey, contextInfo);

	    if (list == null)
	    	return new ArrayList<TypeInfo>();
	    else
	    	return list;
    }



	public CourseOfferingInfo getCourseOffering(String courseOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getCourseOffering(courseOfferingId, contextInfo);
    }



	public CourseOfferingDisplayInfo getCourseOfferingDisplay(String courseOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getCourseOfferingDisplay(courseOfferingId,
	            contextInfo);
    }



	public List<CourseOfferingInfo> getCourseOfferingsByIds(List<String> courseOfferingIds,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    List<CourseOfferingInfo> list = nextDecorator.getCourseOfferingsByIds(courseOfferingIds,
	            contextInfo);
	    

	    if (list == null)
	    	return new ArrayList<CourseOfferingInfo>();
	    else
	    	return list;
    }



	public List<CourseOfferingDisplayInfo> getCourseOfferingDisplaysByIds(List<String> courseOfferingIds,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<CourseOfferingDisplayInfo> list = nextDecorator.getCourseOfferingDisplaysByIds(courseOfferingIds,
	            contextInfo);
		

	    if (list == null)
	    	return new ArrayList<CourseOfferingDisplayInfo>();
	    else
	    	return list;
	    
    }



	public List<String> getCourseOfferingIdsByType(String courseOfferingypeKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<String> list = nextDecorator.getCourseOfferingIdsByType(courseOfferingypeKey,
	            contextInfo);
		

	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<CourseOfferingInfo> getCourseOfferingsByCourse(String courseId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<CourseOfferingInfo> list = nextDecorator.getCourseOfferingsByCourse(courseId, contextInfo);

	    if (list == null)
	    	return new ArrayList<CourseOfferingInfo>();
	    else
	    	return list;
    }



	public List<CourseOfferingInfo> getCourseOfferingsByCourseAndTerm(String courseId,
            String termId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<CourseOfferingInfo> list = nextDecorator.getCourseOfferingsByCourseAndTerm(courseId,
	            termId, contextInfo);
		

	    if (list == null)
	    	return new ArrayList<CourseOfferingInfo>();
	    else
	    	return list;
    }



	public List<String> getCourseOfferingIdsByTerm(String termId,
            Boolean useIncludedTerm,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<String> list = nextDecorator.getCourseOfferingIdsByTerm(termId,
	            useIncludedTerm, contextInfo);
		

	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<String> getCourseOfferingIdsByTermAndSubjectArea(String termId,
            String subjectArea,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<String> list = nextDecorator.getCourseOfferingIdsByTermAndSubjectArea(termId,
	            subjectArea, contextInfo);

	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<CourseOfferingInfo> getCourseOfferingsByTermAndInstructor(String termId,
            String instructorId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<CourseOfferingInfo> list = nextDecorator.getCourseOfferingsByTermAndInstructor(termId,
	            instructorId, contextInfo);
		

	    if (list == null)
	    	return new ArrayList<CourseOfferingInfo>();
	    else
	    	return list;
    }



	public List<String> getCourseOfferingIdsByTermAndUnitsContentOwner(String termId,
            String unitsContentOwnerId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<String> list = nextDecorator.getCourseOfferingIdsByTermAndUnitsContentOwner(
	            termId, unitsContentOwnerId, contextInfo);
		

	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<String> searchForCourseOfferingIds(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<String> list = nextDecorator.searchForCourseOfferingIds(criteria, contextInfo);
		

	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<CourseOfferingInfo> searchForCourseOfferings(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<CourseOfferingInfo> list = nextDecorator.searchForCourseOfferings(criteria, contextInfo);
		

	    if (list == null)
	    	return new ArrayList<CourseOfferingInfo>();
	    else
	    	return list;
    }



	public List<String> getValidCanonicalCourseToCourseOfferingOptionKeys(ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            ReadOnlyException {
		List<String> list = nextDecorator
	            .getValidCanonicalCourseToCourseOfferingOptionKeys(contextInfo);
		

	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<String> getValidRolloverOptionKeys(ContextInfo contextInfo)
            throws InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            ReadOnlyException {
		List<String> list = nextDecorator.getValidRolloverOptionKeys(contextInfo);
		
		if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
		
    }



	public List<ValidationResultInfo> validateCourseOffering(String validationType,
            CourseOfferingInfo courseOfferingInfo,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException {
		List<ValidationResultInfo> list = nextDecorator.validateCourseOffering(validationType,
	            courseOfferingInfo, contextInfo);
		
		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public CourseOfferingInfo createCourseOffering(String courseId,
            String termId,
            String courseOfferingTypeKey,
            CourseOfferingInfo courseOfferingInfo,
            List<String> optionKeys,
            ContextInfo context) throws DoesNotExistException,
            DataValidationErrorException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException {
	    return nextDecorator.createCourseOffering(courseId, termId,
	            courseOfferingTypeKey, courseOfferingInfo, optionKeys, context);
    }



	public SocRolloverResultItemInfo rolloverCourseOffering(String sourceCourseOfferingId,
            String targetTermId,
            List<String> optionKeys,
            ContextInfo context) throws AlreadyExistsException,
            DoesNotExistException, DataValidationErrorException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            ReadOnlyException {
	    return nextDecorator.rolloverCourseOffering(sourceCourseOfferingId,
	            targetTermId, optionKeys, context);
    }



	public CourseOfferingInfo updateCourseOffering(String courseOfferingId,
            CourseOfferingInfo courseOfferingInfo,
            ContextInfo context) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException,
            VersionMismatchException {
	    return nextDecorator.updateCourseOffering(courseOfferingId,
	            courseOfferingInfo, context);
    }



	public StatusInfo updateCourseOfferingState(String courseOfferingId,
            String nextStateKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.updateCourseOfferingState(courseOfferingId,
	            nextStateKey, contextInfo);
    }



	public CourseOfferingInfo updateCourseOfferingFromCanonical(String courseOfferingId,
            List<String> optionKeys,
            ContextInfo context) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, VersionMismatchException {
	    return nextDecorator.updateCourseOfferingFromCanonical(
	            courseOfferingId, optionKeys, context);
    }



	public StatusInfo deleteCourseOffering(String courseOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            DependentObjectsExistException {
	    return nextDecorator.deleteCourseOffering(courseOfferingId, context);
    }



	public StatusInfo deleteCourseOfferingCascaded(String courseOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.deleteCourseOfferingCascaded(courseOfferingId,
	            context);
    }



	public List<ValidationResultInfo> validateCourseOfferingFromCanonical(CourseOfferingInfo courseOfferingInfo,
            List<String> optionKeys,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException {
		List<ValidationResultInfo> list = nextDecorator.validateCourseOfferingFromCanonical(
	            courseOfferingInfo, optionKeys, context);
		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public FormatOfferingInfo getFormatOffering(String formatOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getFormatOffering(formatOfferingId, context);
    }



	public List<FormatOfferingInfo> getFormatOfferingsByCourseOffering(String courseOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<FormatOfferingInfo> list = nextDecorator.getFormatOfferingsByCourseOffering(
	            courseOfferingId, context);
		if (list == null)
	    	return new ArrayList<FormatOfferingInfo>();
	    else
	    	return list;
    }



	public FormatOfferingInfo createFormatOffering(String courseOfferingId,
            String formatId,
            String formatOfferingType,
            FormatOfferingInfo formatOfferingInfo,
            ContextInfo context) throws DoesNotExistException,
            DataValidationErrorException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException {
	    return nextDecorator.createFormatOffering(courseOfferingId, formatId,
	            formatOfferingType, formatOfferingInfo, context);
    }



	public FormatOfferingInfo updateFormatOffering(String formatOfferingId,
            FormatOfferingInfo formatOfferingInfo,
            ContextInfo context) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException,
            VersionMismatchException {
	    return nextDecorator.updateFormatOffering(formatOfferingId,
	            formatOfferingInfo, context);
    }



	public StatusInfo updateFormatOfferingState(String formatOfferingId,
            String nextStateKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.updateFormatOfferingState(formatOfferingId,
	            nextStateKey, contextInfo);
    }



	public List<ValidationResultInfo> validateFormatOffering(String validationType,
            FormatOfferingInfo formatOfferingInfo,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException {
		List<ValidationResultInfo>list = nextDecorator.validateFormatOffering(validationType,
	            formatOfferingInfo, context);
		
		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public StatusInfo deleteFormatOffering(String formatOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            DependentObjectsExistException {
	    return nextDecorator.deleteFormatOffering(formatOfferingId, context);
    }



	public StatusInfo deleteFormatOfferingCascaded(String formatOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.deleteFormatOfferingCascaded(formatOfferingId,
	            context);
    }



	public List<String> searchForFormatOfferingIds(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
	    List<String> list = nextDecorator.searchForFormatOfferingIds(criteria, contextInfo);
	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<FormatOfferingInfo> searchForFormatOfferings(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<FormatOfferingInfo> list = nextDecorator.searchForFormatOfferings(criteria, contextInfo);
		if (list == null)
	    	return new ArrayList<FormatOfferingInfo>();
	    else
	    	return list;
    }



	public TypeInfo getActivityOfferingType(String activityOfferingTypeKey,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getActivityOfferingType(activityOfferingTypeKey,
	            context);
    }



	public List<TypeInfo> getActivityOfferingTypes(ContextInfo context)
            throws InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<TypeInfo> list = nextDecorator.getActivityOfferingTypes(context);
		
		if (list == null)
	    	return new ArrayList<TypeInfo>();
	    else
	    	return list;
    }



	public List<TypeInfo> getActivityOfferingTypesForActivityType(String activityTypeKey,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<TypeInfo> list = nextDecorator.getActivityOfferingTypesForActivityType(
	            activityTypeKey, context);
		
		if (list == null)
	    	return new ArrayList<TypeInfo>();
	    else
	    	return list;
    }



	public List<TypeInfo> getInstructorTypesForActivityOfferingType(String activityOfferingTypeKey,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<TypeInfo> list = nextDecorator.getInstructorTypesForActivityOfferingType(
	            activityOfferingTypeKey, context);
		
		if (list == null)
	    	return new ArrayList<TypeInfo>();
	    else
	    	return list;
    }



	public ActivityOfferingInfo getActivityOffering(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getActivityOffering(activityOfferingId, context);
    }



	public ActivityOfferingDisplayInfo getActivityOfferingDisplay(String activityOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getActivityOfferingDisplay(activityOfferingId,
	            contextInfo);
    }



	public List<ActivityOfferingInfo> getActivityOfferingsByIds(List<String> activityOfferingIds,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<ActivityOfferingInfo> list = nextDecorator.getActivityOfferingsByIds(activityOfferingIds,
	            context);
		
		if (list == null)
	    	return new ArrayList<ActivityOfferingInfo>();
	    else
	    	return list;
    }



	public List<ActivityOfferingDisplayInfo> getActivityOfferingDisplaysByIds(List<String> activityOfferingIds,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    List<ActivityOfferingDisplayInfo> list = nextDecorator.getActivityOfferingDisplaysByIds(
	            activityOfferingIds, contextInfo);
    
	    if (list == null)
	    	return new ArrayList<ActivityOfferingDisplayInfo>();
	    else
	    	return list;
	}



	public List<ActivityOfferingInfo> getActivityOfferingsByCourseOffering(String courseOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<ActivityOfferingInfo> list = nextDecorator.getActivityOfferingsByCourseOffering(
	            courseOfferingId, context);
		if (list == null)
	    	return new ArrayList<ActivityOfferingInfo>();
	    else
	    	return list;
    }



	public List<ActivityOfferingDisplayInfo> getActivityOfferingDisplaysForCourseOffering(String courseOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    List<ActivityOfferingDisplayInfo> list = nextDecorator.getActivityOfferingDisplaysForCourseOffering(
	            courseOfferingId, contextInfo);
	    if (list == null)
	    	return new ArrayList<ActivityOfferingDisplayInfo>();
	    else
	    	return list;
    }



	public List<ActivityOfferingInfo> getActivityOfferingsByCluster(String activityOfferingClusterId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    List<ActivityOfferingInfo> list = nextDecorator.getActivityOfferingsByCluster(
	            activityOfferingClusterId, contextInfo);
	    
	    if (list == null)
	    	return new ArrayList<ActivityOfferingInfo>();
	    else
	    	return list;
    }



	public List<ActivityOfferingInfo> getActivityOfferingsByFormatOffering(String formatOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<ActivityOfferingInfo> list = nextDecorator.getActivityOfferingsByFormatOffering(
	            formatOfferingId, context);
		
		 if (list == null)
		    	return new ArrayList<ActivityOfferingInfo>();
		    else
		    	return list;
    }



	public List<ActivityOfferingInfo> getActivityOfferingsWithoutClusterByFormatOffering(String formatOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<ActivityOfferingInfo> list = nextDecorator
	            .getActivityOfferingsWithoutClusterByFormatOffering(
	                    formatOfferingId, contextInfo);
		
		if (list == null)
	    	return new ArrayList<ActivityOfferingInfo>();
	    else
	    	return list;
    }



	public List<ActivityOfferingInfo> getActivityOfferingsByFormatOfferingWithoutRegGroup(String formatOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		
		List<ActivityOfferingInfo> list = nextDecorator
	            .getActivityOfferingsByFormatOfferingWithoutRegGroup(
	                    formatOfferingId, context);
		
		if (list == null)
	    	return new ArrayList<ActivityOfferingInfo>();
	    else
	    	return list;
    }



	public List<String> searchForActivityOfferingIds(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<String> list = nextDecorator
	            .searchForActivityOfferingIds(criteria, contextInfo);
		
		if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<ActivityOfferingInfo> searchForActivityOfferings(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<ActivityOfferingInfo> list = nextDecorator.searchForActivityOfferings(criteria, contextInfo);
		
		if (list == null)
	    	return new ArrayList<ActivityOfferingInfo>();
	    else
	    	return list;
    }



	public ActivityOfferingInfo createActivityOffering(String formatOfferingId,
            String activityId,
            String activityOfferingTypeKey,
            ActivityOfferingInfo activityOfferingInfo,
            ContextInfo context) throws DoesNotExistException,
            DataValidationErrorException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException {
	    return nextDecorator.createActivityOffering(formatOfferingId,
	            activityId, activityOfferingTypeKey, activityOfferingInfo,
	            context);
    }



	public ActivityOfferingInfo copyActivityOffering(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            DataValidationErrorException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException {
	    return nextDecorator.copyActivityOffering(activityOfferingId, context);
    }



	public List<ActivityOfferingInfo> generateActivityOfferings(String formatOfferingId,
            String activityOfferingType,
            Integer quantity,
            ContextInfo context) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
	    List<ActivityOfferingInfo> list = nextDecorator.generateActivityOfferings(formatOfferingId,
	            activityOfferingType, quantity, context);
	    
		if (list == null)
	    	return new ArrayList<ActivityOfferingInfo>();
	    else
	    	return list;
    
	
	}



	public ActivityOfferingInfo updateActivityOffering(String activityOfferingId,
            ActivityOfferingInfo activityOfferingInfo,
            ContextInfo context) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, VersionMismatchException,
            ReadOnlyException {
	    return nextDecorator.updateActivityOffering(activityOfferingId,
	            activityOfferingInfo, context);
    }



	public StatusInfo updateActivityOfferingState(String activityOfferingId,
            String nextStateKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.updateActivityOfferingState(activityOfferingId,
	            nextStateKey, contextInfo);
    }



	public StatusInfo deleteActivityOffering(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            DependentObjectsExistException {
	    return nextDecorator
	            .deleteActivityOffering(activityOfferingId, context);
    }



	public StatusInfo deleteActivityOfferingCascaded(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.deleteActivityOfferingCascaded(activityOfferingId,
	            context);
    }



	public StatusInfo scheduleActivityOffering(String activityOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.scheduleActivityOffering(activityOfferingId,
	            contextInfo);
    }



	public List<ValidationResultInfo> validateActivityOffering(String validationType,
            ActivityOfferingInfo activityOfferingInfo,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException {
		List<ValidationResultInfo> list = nextDecorator.validateActivityOffering(validationType,
	            activityOfferingInfo, context);
		
		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public Float calculateInClassContactHoursForTerm(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.calculateInClassContactHoursForTerm(
	            activityOfferingId, context);
    }



	public Float calculateOutofClassContactHoursForTerm(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.calculateOutofClassContactHoursForTerm(
	            activityOfferingId, context);
    }



	public Float calculateTotalContactHoursForTerm(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.calculateTotalContactHoursForTerm(
	            activityOfferingId, context);
    }



	public RegistrationGroupInfo getRegistrationGroup(String registrationGroupId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getRegistrationGroup(registrationGroupId, context);
    }



	public List<RegistrationGroupInfo> getRegistrationGroupsByIds(List<String> registrationGroupIds,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<RegistrationGroupInfo> list = nextDecorator.getRegistrationGroupsByIds(registrationGroupIds,
	            context);
		
		if (list == null)
	    	return new ArrayList<RegistrationGroupInfo>();
	    else
	    	return list;
    }



	public List<RegistrationGroupInfo> getRegistrationGroupsForCourseOffering(String courseOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<RegistrationGroupInfo> list = nextDecorator.getRegistrationGroupsForCourseOffering(
	            courseOfferingId, context);
		

		if (list == null)
	    	return new ArrayList<RegistrationGroupInfo>();
	    else
	    	return list;
    }



	public List<RegistrationGroupInfo> getRegistrationGroupsWithActivityOfferings(List<String> activityOfferingIds,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<RegistrationGroupInfo> list = nextDecorator.getRegistrationGroupsWithActivityOfferings(
	            activityOfferingIds, context);
		

		if (list == null)
	    	return new ArrayList<RegistrationGroupInfo>();
	    else
	    	return list;
    }



	public List<RegistrationGroupInfo> getRegistrationGroupsByFormatOffering(String formatOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<RegistrationGroupInfo> list = nextDecorator.getRegistrationGroupsByFormatOffering(
	            formatOfferingId, context);
		

		if (list == null)
	    	return new ArrayList<RegistrationGroupInfo>();
	    else
	    	return list;
    }



	public List<RegistrationGroupInfo> getRegistrationGroupsByActivityOfferingCluster(String activityOfferingClusterId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<RegistrationGroupInfo> list = nextDecorator.getRegistrationGroupsByActivityOfferingCluster(
	            activityOfferingClusterId, contextInfo);
		

		if (list == null)
	    	return new ArrayList<RegistrationGroupInfo>();
	    else
	    	return list;
    }



	public List<String> searchForRegistrationGroupIds(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<String> list = nextDecorator.searchForRegistrationGroupIds(criteria,
	            contextInfo);
		

		if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<RegistrationGroupInfo> searchForRegistrationGroups(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<RegistrationGroupInfo> list = nextDecorator.searchForRegistrationGroups(criteria, contextInfo);
		

		if (list == null)
	    	return new ArrayList<RegistrationGroupInfo>();
	    else
	    	return list;
    }



	public List<ValidationResultInfo> validateRegistrationGroup(String validationType,
            String activityOfferingClusterId,
            String registrationGroupType,
            RegistrationGroupInfo registrationGroupInfo,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException {
		List<ValidationResultInfo> list = nextDecorator.validateRegistrationGroup(validationType,
	            activityOfferingClusterId, registrationGroupType,
	            registrationGroupInfo, contextInfo);
		

		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public RegistrationGroupInfo createRegistrationGroup(String formatOfferingId,
            String activityOfferingClusterId,
            String registrationGroupType,
            RegistrationGroupInfo registrationGroupInfo,
            ContextInfo context) throws DoesNotExistException,
            DataValidationErrorException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException {
	    return nextDecorator.createRegistrationGroup(formatOfferingId,
	            activityOfferingClusterId, registrationGroupType,
	            registrationGroupInfo, context);
    }



	public RegistrationGroupInfo updateRegistrationGroup(String registrationGroupId,
            RegistrationGroupInfo registrationGroupInfo,
            ContextInfo context) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException,
            VersionMismatchException {
	    return nextDecorator.updateRegistrationGroup(registrationGroupId,
	            registrationGroupInfo, context);
    }



	public StatusInfo updateRegistrationGroupState(String registrationGroupId,
            String nextStateKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.updateRegistrationGroupState(registrationGroupId,
	            nextStateKey, contextInfo);
    }



	public StatusInfo deleteRegistrationGroup(String registrationGroupId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.deleteRegistrationGroup(registrationGroupId,
	            context);
    }



	public StatusInfo deleteRegistrationGroupsByFormatOffering(String formatOfferingId,
            ContextInfo context) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
	    return nextDecorator.deleteRegistrationGroupsByFormatOffering(
	            formatOfferingId, context);
    }



	public StatusInfo deleteGeneratedRegistrationGroupsByFormatOffering(String formatOfferingId,
            ContextInfo context) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
	    return nextDecorator.deleteGeneratedRegistrationGroupsByFormatOffering(
	            formatOfferingId, context);
    }



	public StatusInfo deleteRegistrationGroupsForCluster(String activityOfferingClusterId,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
	    return nextDecorator.deleteRegistrationGroupsForCluster(
	            activityOfferingClusterId, contextInfo);
    }



	public List<ValidationResultInfo> verifyRegistrationGroup(String registrationGroupId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException {
		List<ValidationResultInfo> list = nextDecorator.verifyRegistrationGroup(registrationGroupId,
	            contextInfo);
		

		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public ActivityOfferingClusterInfo getActivityOfferingCluster(String activityOfferingClusterId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getActivityOfferingCluster(
	            activityOfferingClusterId, contextInfo);
    }



	public List<ActivityOfferingClusterInfo> getActivityOfferingClustersByFormatOffering(String formatOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    List<ActivityOfferingClusterInfo> list = nextDecorator.getActivityOfferingClustersByFormatOffering(
	            formatOfferingId, contextInfo);
	    
	    if (list == null)
	    	return new ArrayList<ActivityOfferingClusterInfo>();
	    else
	    	return list;
    }



	public List<String> getActivityOfferingClustersIdsByFormatOffering(String formatOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    List<String> list = nextDecorator.getActivityOfferingClustersIdsByFormatOffering(
	            formatOfferingId, contextInfo);
	    if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<ValidationResultInfo> validateActivityOfferingCluster(String validationTypeKey,
            String formatOfferingId,
            ActivityOfferingClusterInfo activityOfferingClusterInfo,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException {
	    List<ValidationResultInfo> list = nextDecorator.validateActivityOfferingCluster(validationTypeKey,
	            formatOfferingId, activityOfferingClusterInfo, contextInfo);
	    

		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public ActivityOfferingClusterInfo createActivityOfferingCluster(String formatOfferingId,
            String activityOfferingClusterTypeKey,
            ActivityOfferingClusterInfo activityOfferingClusterInfo,
            ContextInfo contextInfo) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException {
		return nextDecorator.createActivityOfferingCluster(formatOfferingId,
	            activityOfferingClusterTypeKey, activityOfferingClusterInfo,
	            contextInfo);
    }



	public ActivityOfferingClusterInfo updateActivityOfferingCluster(String formatOfferingId,
            String activityOfferingClusterId,
            ActivityOfferingClusterInfo activityOfferingClusterInfo,
            ContextInfo contextInfo) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException,
            VersionMismatchException {
	    return nextDecorator.updateActivityOfferingCluster(formatOfferingId,
	            activityOfferingClusterId, activityOfferingClusterInfo,
	            contextInfo);
    }



	public StatusInfo updateActivityOfferingClusterState(String activityOfferingClusterId,
            String nextStateKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.updateActivityOfferingClusterState(
	            activityOfferingClusterId, nextStateKey, contextInfo);
    }



	public StatusInfo deleteActivityOfferingCluster(String activityOfferingClusterId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            DependentObjectsExistException {
	    return nextDecorator.deleteActivityOfferingCluster(
	            activityOfferingClusterId, contextInfo);
    }



	public StatusInfo deleteActivityOfferingClusterCascaded(String activityOfferingClusterId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.deleteActivityOfferingClusterCascaded(
	            activityOfferingClusterId, contextInfo);
    }



	public AOClusterVerifyResultsInfo verifyActivityOfferingClusterForGeneration(String activityOfferingClusterId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.verifyActivityOfferingClusterForGeneration(
	            activityOfferingClusterId, contextInfo);
    }



	public List<String> searchForActivityOfferingClusterIds(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<String> list = nextDecorator.searchForActivityOfferingClusterIds(criteria,
	            contextInfo);
		

		if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<ActivityOfferingClusterInfo> searchForActivityOfferingClusters(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<ActivityOfferingClusterInfo> list = nextDecorator.searchForActivityOfferingClusters(criteria,
	            contextInfo);
		
		if (list == null)
	    	return new ArrayList<ActivityOfferingClusterInfo>();
	    else
	    	return list;
    }



	public SeatPoolDefinitionInfo getSeatPoolDefinition(String seatPoolDefinitionId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.getSeatPoolDefinition(seatPoolDefinitionId,
	            context);
    }



	public List<SeatPoolDefinitionInfo> getSeatPoolDefinitionsForActivityOffering(String activityOfferingId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
		List<SeatPoolDefinitionInfo> list = nextDecorator.getSeatPoolDefinitionsForActivityOffering(
	            activityOfferingId, context);
		
		if (list == null)
	    	return new ArrayList<SeatPoolDefinitionInfo>();
	    else
	    	return list;
    }



	public List<String> searchForSeatpoolDefinitionIds(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<String> list = nextDecorator.searchForSeatpoolDefinitionIds(criteria,
	            contextInfo);
		
		if (list == null)
	    	return new ArrayList<String>();
	    else
	    	return list;
    }



	public List<SeatPoolDefinitionInfo> searchForSeatpoolDefinitions(QueryByCriteria criteria,
            ContextInfo contextInfo) throws InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
		List<SeatPoolDefinitionInfo> list = nextDecorator
	            .searchForSeatpoolDefinitions(criteria, contextInfo);
		
		if (list == null)
	    	return new ArrayList<SeatPoolDefinitionInfo>();
	    else
	    	return list;
    }



	public SeatPoolDefinitionInfo createSeatPoolDefinition(SeatPoolDefinitionInfo seatPoolDefinitionInfo,
            ContextInfo context) throws DataValidationErrorException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException,
            ReadOnlyException {
	    return nextDecorator.createSeatPoolDefinition(seatPoolDefinitionInfo,
	            context);
    }



	public SeatPoolDefinitionInfo updateSeatPoolDefinition(String seatPoolDefinitionId,
            SeatPoolDefinitionInfo seatPoolDefinitionInfo,
            ContextInfo context) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, ReadOnlyException,
            VersionMismatchException {
	    return nextDecorator.updateSeatPoolDefinition(seatPoolDefinitionId,
	            seatPoolDefinitionInfo, context);
    }



	public StatusInfo updateSeatPoolDefinitionState(String seatPoolDefinitionId,
            String nextStateKey,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.updateSeatPoolDefinitionState(
	            seatPoolDefinitionId, nextStateKey, contextInfo);
    }



	public List<ValidationResultInfo> validateSeatPoolDefinition(String validationTypeKey,
            SeatPoolDefinitionInfo seatPoolDefinitionInfo,
            ContextInfo context) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException, VersionMismatchException {
		List<ValidationResultInfo> list = nextDecorator.validateSeatPoolDefinition(validationTypeKey,
	            seatPoolDefinitionInfo, context);
		
		if (list == null)
	    	return new ArrayList<ValidationResultInfo>();
	    else
	    	return list;
    }



	public StatusInfo deleteSeatPoolDefinition(String seatPoolDefinitionId,
            ContextInfo context) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.deleteSeatPoolDefinition(seatPoolDefinitionId,
	            context);
    }



	public StatusInfo addSeatPoolDefinitionToActivityOffering(String seatPoolDefinitionId,
            String activityOfferingId,
            ContextInfo contextInfo) throws AlreadyExistsException,
            DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
	    return nextDecorator.addSeatPoolDefinitionToActivityOffering(
	            seatPoolDefinitionId, activityOfferingId, contextInfo);
    }



	public StatusInfo removeSeatPoolDefinitionFromActivityOffering(String seatPoolDefinitionId,
            String activityOfferingId,
            ContextInfo contextInfo) throws DoesNotExistException,
            InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException {
	    return nextDecorator.removeSeatPoolDefinitionFromActivityOffering(
	            seatPoolDefinitionId, activityOfferingId, contextInfo);
    }


}
