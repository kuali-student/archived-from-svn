/*
 * Copyright 2014 The Kuali Foundation
 * 
 * Licensed under the Educational Community License, Version 1.0 (the
 * "License"); you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.opensource.org/licenses/ecl1.php
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.kuali.student.enrollment.class2.academicrecord.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.common.UUIDHelper;
import org.kuali.student.common.mock.MockService;
import org.kuali.student.enrollment.academicrecord.dto.GPAInfo;
import org.kuali.student.enrollment.academicrecord.dto.LoadInfo;
import org.kuali.student.enrollment.academicrecord.dto.StudentCourseRecordInfo;
import org.kuali.student.enrollment.academicrecord.dto.StudentCredentialRecordInfo;
import org.kuali.student.enrollment.academicrecord.dto.StudentProgramRecordInfo;
import org.kuali.student.enrollment.academicrecord.dto.StudentTestScoreRecordInfo;
import org.kuali.student.enrollment.academicrecord.service.AcademicRecordService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.MetaInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.common.exceptions.ReadOnlyException;
import org.kuali.student.r2.common.exceptions.VersionMismatchException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Kuali Student Team
 */
public class AcademicRecordServiceMapImpl implements
        AcademicRecordService, MockService {

    private static final Logger log = LoggerFactory
            .getLogger(AcademicRecordServiceMapImpl.class);

    private Map<String, GPAInfo> gpasMap = new LinkedHashMap<String, GPAInfo>();
    private List<StudentCourseRecordInfo> courseRecordInfoList = new ArrayList<StudentCourseRecordInfo>();        //to be replaced with studentToCourseRecordsMap
    private Map<String, LoadInfo> loadsMap = new LinkedHashMap<String, LoadInfo>();
    private Map<String, StudentCredentialRecordInfo> studentCredentialRecordsMap = new LinkedHashMap<String, StudentCredentialRecordInfo>();
    private Map<String, StudentTestScoreRecordInfo> studentTestScoreRecordsMap = new LinkedHashMap<String, StudentTestScoreRecordInfo>();

    private Map<String, List<StudentCourseRecordInfo>> studentToCourseRecordsMap = new HashMap<String, List<StudentCourseRecordInfo>>();
    private Map<String, List<StudentProgramRecordInfo>> studentToProgramRecordsMap = new LinkedHashMap<String, List<StudentProgramRecordInfo>>();
    private Map<String, List<StudentCourseRecordInfo>> termToCourseRecordsMap = new HashMap<String, List<StudentCourseRecordInfo>>();
    private Set<StudentCourseRecordInfo> studentCourseRecordsSet = new HashSet<StudentCourseRecordInfo>();

    // this is a bit of a hack until the record can contain the course id directly
    private Map<String, String> courseIdToCourseCodeMap = new HashMap<String, String>();

    private int countProgramId = 1;

    /* (non-Javadoc)
     * @see org.kuali.student.common.mock.MockService#clear()
     */
    @Override
    public void clear() {
        studentToCourseRecordsMap.clear();
        termToCourseRecordsMap.clear();
        courseIdToCourseCodeMap.clear();
        studentCourseRecordsSet.clear();

        gpasMap.clear();
        courseRecordInfoList.clear();
        loadsMap.clear();
        studentToProgramRecordsMap.clear();
        studentCredentialRecordsMap.clear();
        studentTestScoreRecordsMap.clear();
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getAttemptedCourseRecordsForTerm(java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentCourseRecordInfo> getAttemptedCourseRecordsForTerm(
            String personId,
            String termId,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        List<StudentCourseRecordInfo> courseRecords = new ArrayList<StudentCourseRecordInfo>();
        for (StudentCourseRecordInfo courseRecord : courseRecordInfoList) {
            if (courseRecord.getPersonId().equals(personId) && courseRecord.getTermName().equals(termId)) {
                courseRecords.add(courseRecord);
            }
        }
        return courseRecords;
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getCompletedCourseRecords(java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentCourseRecordInfo> getCompletedCourseRecords(
            String personId, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {

        if (!studentToCourseRecordsMap.keySet().contains(personId))
            throw new DoesNotExistException("No course records for student Id = " + personId);

        return studentToCourseRecordsMap.get(personId);
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getCompletedCourseRecordsForCourse(java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentCourseRecordInfo> getCompletedCourseRecordsForCourse(
            String personId, String courseId, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {

        List<StudentCourseRecordInfo> resultsList = new ArrayList<StudentCourseRecordInfo>();

        if (!studentToCourseRecordsMap.keySet().contains(personId))
            throw new DoesNotExistException("No course records for student Id = " + personId);

        // Should not throw exception, course could still exist in cluservice and i do want to check if any student has completed it.
        //if (!courseIdToCourseCodeMap.keySet().contains(courseId))
        //    throw new DoesNotExistException("No course records for course id = " + courseId);

        List<StudentCourseRecordInfo> records = studentToCourseRecordsMap.get(personId);

        String courseCode = courseIdToCourseCodeMap.get(courseId);

        for (StudentCourseRecordInfo studentCourseRecordInfo : records) {

            if (studentCourseRecordInfo.getCourseCode().equals(courseCode))
                resultsList.add(studentCourseRecordInfo);

        }

        return resultsList;
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getCompletedCourseRecordsForTerm(java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentCourseRecordInfo> getCompletedCourseRecordsForTerm(
            String personId,
            String termId,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        List<StudentCourseRecordInfo> courseRecords = new ArrayList<StudentCourseRecordInfo>();
        for (StudentCourseRecordInfo courseRecord : courseRecordInfoList) {
            if (courseRecord.getPersonId().equals(personId) && courseRecord.getTermName().equals(termId) && (courseRecord.getAssignedGradeValue() != null || courseRecord.getAdministrativeGradeValue() != null)) {
                courseRecords.add(courseRecord);
            }
        }
        return courseRecords;
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getGPAForTerm(java.lang.String, java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public GPAInfo getGPAForTerm(String personId,
                                 String termId,
                                 String calculationTypeKey,
                                 ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return gpasMap.get("gpa1");
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getCumulativeGPA(java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public GPAInfo getCumulativeGPA(
            String personId,
            String calculationTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return gpasMap.get("gpa3");
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#calculateGPA(java.util.List<org.kuali.student.enrollment.academicrecord.dto.StudentCourseRecordInfo>, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public GPAInfo calculateGPA(List<StudentCourseRecordInfo> studentCourseRecordInfoList, String calculationTypeKey, ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        //This is a mock GPA calculation
        float totalCredits = 0.0f;
        float gradePoints = 0.0f;
        for (StudentCourseRecordInfo info : studentCourseRecordInfoList){
            float creditsForGPA = Float.parseFloat(info.getCreditsForGPA());
            gradePoints += Float.parseFloat(info.getCalculatedGradeValue())*creditsForGPA;
            totalCredits += creditsForGPA;
        }

        GPAInfo gpa = new GPAInfo();
        gpa.setCalculationTypeKey(calculationTypeKey);
        gpa.setScaleKey("1");
        gpa.setValue(String.valueOf(gradePoints/totalCredits));
        return gpa;
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getCumulativeGPAForProgram(java.lang.String, java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public GPAInfo getCumulativeGPAForProgram(
            String personId,
            String programId,
            String calculationTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return gpasMap.get("gpa2");
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getCumulativeGPAForTermAndProgram(java.lang.String, java.lang.String, java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public GPAInfo getCumulativeGPAForTermAndProgram(
            String personId,
            String programId,
            String termKey,
            String calculationTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return gpasMap.get("gpa2");
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getLoadForTerm(java.lang.String, java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public LoadInfo getLoadForTerm(
            String personId,
            String termId,
            String calculationTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return loadsMap.get("mediumLoad");
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getProgramRecords(java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentProgramRecordInfo> getProgramRecords(
            String personId,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {

        List<StudentProgramRecordInfo> resultsList = new ArrayList<StudentProgramRecordInfo>();

        if (!studentToProgramRecordsMap.keySet().contains(personId))
            throw new DoesNotExistException("No program records for student Id = " + personId);

        return studentToProgramRecordsMap.get(personId);

    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getAwardedCredentials(java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentCredentialRecordInfo> getAwardedCredentials(
            String personId,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return Collections.singletonList(studentCredentialRecordsMap.get("1"));
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getTestScoreRecords(java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentTestScoreRecordInfo> getTestScoreRecords(
            String personId,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return Collections.singletonList(studentTestScoreRecordsMap.get("1"));
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getTestScoreRecordsByType(java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public List<StudentTestScoreRecordInfo> getTestScoreRecordsByType(
            String personId,
            String testTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        return Collections.singletonList(studentTestScoreRecordsMap.get("2"));
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getEarnedCreditsForTerm(java.lang.String, java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public String getEarnedCreditsForTerm(
            String personId,
            String termId,
            String calculationTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        Integer credits = 0;
        List<StudentCourseRecordInfo> records = studentToCourseRecordsMap.get(personId);
        for (StudentCourseRecordInfo studentCourseRecordInfo : records) {
            credits += Integer.parseInt(studentCourseRecordInfo.getCreditsEarned());
        }
        return String.valueOf(credits);
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getEarnedCredits(java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public String getEarnedCredits(
            String personId,
            String calculationTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        Integer credits = 0;
        List<StudentCourseRecordInfo> records = studentToCourseRecordsMap.get(personId);
        for (StudentCourseRecordInfo studentCourseRecordInfo : records) {
            credits += Integer.parseInt(studentCourseRecordInfo.getCreditsEarned());
        }
        return String.valueOf(credits);
    }

    /* (non-Javadoc)
     * @see org.kuali.student.enrollment.academicrecord.service.AcademicRecordService#getEarnedCumulativeCreditsForProgramAndTerm(java.lang.String, java.lang.String, java.lang.String, java.lang.String, org.kuali.student.r2.common.dto.ContextInfo)
     */
    @Override
    public String getEarnedCumulativeCreditsForProgramAndTerm(
            String personId,
            String programId,
            String termId,
            String calculationTypeKey,
            ContextInfo contextInfo)
            throws DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        Integer credits = 0;
        List<StudentCourseRecordInfo> records = studentToCourseRecordsMap.get(personId);
        for (StudentCourseRecordInfo studentCourseRecordInfo : records) {
            credits += Integer.parseInt(studentCourseRecordInfo.getCreditsEarned());
        }
        return String.valueOf(credits);
    }

    @Override
    public StudentProgramRecordInfo createStudentProgramRecord(String studentProgramRecordTypeKey,
                                                               String personId,
                                                               StudentProgramRecordInfo studentProgramRecord,
                                                               ContextInfo contextInfo) throws
            DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException, ReadOnlyException {

        if (!studentProgramRecordTypeKey.equals((studentProgramRecord.getTypeKey()))) {
            throw new InvalidParameterException("The typeKey parameter does not match the typeKey on the info object");
        }

        StudentProgramRecordInfo copy = new StudentProgramRecordInfo(studentProgramRecord);
        if (copy.getId() == null) {
            copy.setId(UUIDHelper.genStringUUID());
        }
        copy.setMeta(newMeta(contextInfo));

        // link to student
        List<StudentProgramRecordInfo> studentProgramList = studentToProgramRecordsMap.get(personId);

        if (studentProgramList == null) {
            studentProgramList = new ArrayList<StudentProgramRecordInfo>();
            studentToProgramRecordsMap.put(personId, studentProgramList);
        }

        studentProgramList.add(copy);
        return new StudentProgramRecordInfo(copy);
    }

    @Override
    public List<ValidationResultInfo> validateStudentProgramRecord(String validationTypeKey, String objectTypeKey, StudentProgramRecordInfo studentProgramRecordInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentProgramRecordInfo updateStudentProgramRecord(String studentProgramRecordId,
                                                               StudentProgramRecordInfo studentProgramRecord,
                                                               ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        String personId = studentProgramRecord.getPersonId();

        // link to student
        List<StudentProgramRecordInfo> studentProgramList = studentToProgramRecordsMap.get(personId);

        if (studentProgramList == null) {
            studentProgramList = new ArrayList<StudentProgramRecordInfo>();
            studentToProgramRecordsMap.put(personId, studentProgramList);
        }

        studentProgramList.add(studentProgramRecord);
        return studentProgramRecord;
    }

    @Override
    public StatusInfo deleteStudentProgramRecord(String studentProgramRecordId, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentCourseRecordInfo createStudentCourseRecord(String personId, String courseRegistrationId,
                                                             StudentCourseRecordInfo studentCourseRecord,
                                                             ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {

        String termId = studentCourseRecord.getTermId();
        String courseOfferingId = studentCourseRecord.getCourseOfferingId();


        studentCourseRecordsSet.add(studentCourseRecord);

        courseIdToCourseCodeMap.put(courseRegistrationId, studentCourseRecord.getCourseCode());

        // link to student
        List<StudentCourseRecordInfo> studentCourseList = studentToCourseRecordsMap.get(personId);

        if (studentCourseList == null) {
            studentCourseList = new ArrayList<StudentCourseRecordInfo>();
            studentToCourseRecordsMap.put(personId, studentCourseList);
        }

        studentCourseList.add(studentCourseRecord);

        // link to term

        List<StudentCourseRecordInfo> termCourseList = termToCourseRecordsMap.get(termId);

        if (termCourseList == null) {
            termCourseList = new ArrayList<StudentCourseRecordInfo>();
            termToCourseRecordsMap.put(termId, termCourseList);
        }

        termCourseList.add(studentCourseRecord);
        return studentCourseRecord;
    }

    @Override
    public List<ValidationResultInfo> validateStudentCourseRecord(String validationTypeKey, String objectTypeKey, StudentCourseRecordInfo studentCourseRecordInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentCourseRecordInfo updateStudentCourseRecord(String studentCourseRecordId,
                                                             StudentCourseRecordInfo studentCourseRecord,
                                                             ContextInfo contextInfo) throws
            DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StatusInfo deleteStudentCourseRecord(String studentCourseRecordId, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentCredentialRecordInfo createStudentCredentialRecord(String studentCredentialRecordTypeKey,
                                                                     String personId,
                                                                    StudentCredentialRecordInfo studentCredentialRecord,
                                                                    ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {
        studentCredentialRecordsMap.put(personId, studentCredentialRecord);
        return studentCredentialRecord;
    }

    @Override
    public List<ValidationResultInfo> validateStudentCredentialRecord(String validationTypeKey,
                                                                      String objectTypeKey,
                                                                      StudentCredentialRecordInfo studentCredentialRecordInfo,
                                                                      ContextInfo contextInfo)
            throws DoesNotExistException,
            InvalidParameterException,
            MissingParameterException,
            OperationFailedException,
            PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentCredentialRecordInfo updateStudentCredentialRecord(String studentCredentialRecordId,
                                                                    StudentCredentialRecordInfo studentCredentialRecord,
                                                                    ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StatusInfo deleteStudentCredentialRecord(String studentCredentialRecordId, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentTestScoreRecordInfo createStudentTestScoreRecord(String studentTestScoreRecordTypeKey,
                                                                   String personId,
                                                                   StudentTestScoreRecordInfo studentTestScoreRecord,
                                                                   ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {
        studentTestScoreRecordsMap.put(personId, studentTestScoreRecord);
        return studentTestScoreRecord;
    }

    @Override
    public List<ValidationResultInfo> validateStudentTestScoreRecord(String validationTypeKey, String objectTypeKey, StudentTestScoreRecordInfo studentTestScoreRecordInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentTestScoreRecordInfo updateStudentTestScoreRecord(String studentTestScoreRecordId,
                                                                   StudentTestScoreRecordInfo studentTestScoreRecord,
                                                                   ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StatusInfo deleteStudentTestScoreRecord(String studentTestScoreRecordId, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public GPAInfo createGPA(String gpaTypeKey, GPAInfo gpa, ContextInfo contextInfo) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException, MissingParameterException,
            OperationFailedException, PermissionDeniedException, ReadOnlyException {

        if (!gpaTypeKey.equals((gpa.getTypeKey()))) {
            throw new InvalidParameterException("The typeKey parameter does not match the typeKey on the info object");
        }

        GPAInfo copy = new GPAInfo(gpa);
        if (copy.getId() == null) {
            copy.setId(UUIDHelper.genStringUUID());
        }
        copy.setMeta(newMeta(contextInfo));

        gpasMap.put(copy.getPersonId(), gpa);

        return new GPAInfo(copy);
    }

    @Override
    public List<ValidationResultInfo> validateGPA(String validationTypeKey, String objectTypeKey, GPAInfo gpaInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public GPAInfo updateGPA(String gpaId, GPAInfo gpa, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StatusInfo deleteGPA(String gpaId, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public LoadInfo createLoad(String loadTypeKey, LoadInfo load, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {

        if (!loadTypeKey.equals((load.getTypeKey()))) {
            throw new InvalidParameterException("The typeKey parameter does not match the typeKey on the info object");
        }

        LoadInfo copy = new LoadInfo(load);
        if (copy.getId() == null) {
            copy.setId(UUIDHelper.genStringUUID());
        }
        copy.setMeta(newMeta(contextInfo));

        loadsMap.put(copy.getPersonId(), copy);
        return new LoadInfo(copy);
    }

    @Override
    public List<ValidationResultInfo> validateLoad(String validationTypeKey, String objectTypeKey, LoadInfo loadInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public LoadInfo updateLoad(String loadId, LoadInfo load, ContextInfo contextInfo)
            throws DataValidationErrorException, DoesNotExistException, InvalidParameterException,
            MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StatusInfo deleteLoad(String loadId, ContextInfo contextInfo) throws DataValidationErrorException,
            DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException,
            PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentProgramRecordInfo getStudentProgramRecord(String studentProgramRecordId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentCourseRecordInfo getStudentCourseRecord(String studentCourseRecordId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentCourseRecordInfo getStudentCredentialRecord(String studentCredentialRecordId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public StudentTestScoreRecordInfo getStudentTestScoreRecord(String studentTestScoreRecordId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public GPAInfo getGpa(String gpaId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public LoadInfo getLoad(String loadId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentProgramRecordInfo> getStudentProgramRecordsByIds(List<String> studentProgramRecordIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentCredentialRecordInfo> getStudentCredentialRecordsByIds(List<String> studentCredentialRecordIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentCourseRecordInfo> getStudentCourseRecordsByIds(List<String> studentCourseRecordIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentTestScoreRecordInfo> getStudentTestScoreRecordsByIds(List<String> studentTestScoreRecordIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<GPAInfo> getGpasByIds(List<String> gpaIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<LoadInfo> getLoadsByIds(List<String> loadIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> getStudentProgramRecordIdsByType(String studentProgramRecordTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> getStudentCourseRecordIdsByType(String studentCourseRecordTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> getStudentCredentialRecordIdsByType(String studentCredentialRecordTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> getStudentTestScoreIdsByType(String studentTestScoreTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> getGpaIdsByType(String gpaTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> getLoadIdsByType(String loadTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> searchForStudentProgramRecordIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> searchForStudentCourseRecordIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> searchForStudentTestScoreRecordIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> searchForStudentCredentialRecordIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> searchForGpaIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<String> searchForLoadIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentProgramRecordInfo> searchForStudentProgramRecords(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentCourseRecordInfo> searchForStudentCourseRecords(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentCredentialRecordInfo> searchForStudentCredentialRecords(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<StudentTestScoreRecordInfo> searchForStudentTestScoreRecords(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    @Override
    public List<GPAInfo> searchForGpas(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        throw new UnsupportedOperationException("This method is not yet supported.");
    }

    // simple sequence generator for testing
    private String generateProgramId() {
        return Integer.toString(this.countProgramId++);
    }

    private MetaInfo newMeta(ContextInfo context) {
        MetaInfo meta = new MetaInfo();
        meta.setCreateId(context.getPrincipalId());
        meta.setCreateTime(new Date());
        meta.setUpdateId(context.getPrincipalId());
        meta.setUpdateTime(meta.getCreateTime());
        meta.setVersionInd("0");
        return meta;
    }
}
