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
package org.kuali.student.loader.rules;

import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r1.core.statement.dto.*;
import org.kuali.student.r1.core.statement.service.StatementService;
import org.kuali.student.r2.common.exceptions.*;
import org.kuali.student.r2.lum.course.dto.CourseInfo;
import org.kuali.student.r2.lum.course.service.CourseService;

import java.util.ArrayList;
import java.util.List;

/**
 * @author christoff.botha
 * @info This class helps the loader gain access to any data related to the CM format of rules.
 */
public class StatementHelper {
    //private CriteriaLookupService criteriaLookupService;
    ContextInfoHelper contextInfoHelper = new ContextInfoHelper();
    private StatementService statementService;
    private CourseService courseService;

    public List<StatementTreeViewInfo> getRootStatements() {
        List<StatementInfo> allStatements = new ArrayList<StatementInfo>();
        List<StatementTreeViewInfo> rootStatements = new ArrayList<StatementTreeViewInfo>();
        String[] types = new String[]{
                "kuali.statement.type.course.academicReadiness.antireq",
                "kuali.statement.type.course.academicReadiness.coreq",
                "kuali.statement.type.course.academicReadiness.prereq",
                "kuali.statement.type.course.academicReadiness.studentEligibility",
                "kuali.statement.type.course.academicReadiness.studentEligibilityPrereq",
                "kuali.statement.type.course.credit.repeatable",
                "kuali.statement.type.course.credit.restriction",
                "kuali.statement.type.course.recommendedPreparation"
        };
        try {
            for (String type : types) {
                List<StatementInfo> statements = statementService.getStatementsByType(type);
                if (statements != null) {
                    for (StatementInfo statement : statements) {
                        if (statement.getState().equals("Active")) {
                            allStatements.add(statement);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        for (StatementInfo info : allStatements) {
            try {
                List<RefStatementRelationInfo> rels = statementService.getRefStatementRelationsByStatement(info.getId());
                if (rels != null) {
                    for (RefStatementRelationInfo relation : rels) {
                        try {
                            CourseInfo course = courseService.getCourse(relation.getRefObjectId(), contextInfoHelper.getDefaultContextInfo());
                            rootStatements.add(statementService.getStatementTreeView(relation.getStatementId()));
                        } catch (DoesNotExistException e) {
                            continue;
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
        }
        return rootStatements;
    }

    public List<StatementInfo> getChildStatementsForStatement(String statementId) {
        List<StatementInfo> children = null;
        try {
            children = statementService.getStatementsUsingStatement(statementId);
        } catch (DoesNotExistException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (InvalidParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (MissingParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (OperationFailedException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        return children;
    }

    public CourseInfo getRelatedCourseFromStatement(String statementId) {
        try {
            List<RefStatementRelationInfo> refStatementRelationInfoList = statementService.getRefStatementRelationsByStatement(statementId);
            if (refStatementRelationInfoList != null) {
                for (RefStatementRelationInfo relation : refStatementRelationInfoList) {
                    if (relation.getRefObjectTypeKey().equals("kuali.lu.type.CreditCourse")) {
                        try {
                            CourseInfo course = courseService.getCourse(relation.getRefObjectId(), contextInfoHelper.getDefaultContextInfo());
                            return course;
                        } catch (DoesNotExistException e) {
                            System.out.println("Error: statement relation exists but clu does not exist. CLUID: " + relation.getRefObjectId());
                            return null;
                        }
                    }
                }
            }
        } catch (DoesNotExistException e) {
            e.printStackTrace();
        } catch (InvalidParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (MissingParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (OperationFailedException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (PermissionDeniedException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        return null;
    }

    public String getStatementTypeNameFromTypeId(String statementTypeId) {
        try {
            StatementTypeInfo type = statementService.getStatementType(statementTypeId);
            return type.getName();
        } catch (DoesNotExistException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (InvalidParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (MissingParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (OperationFailedException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        return "error";
    }

    public List<ReqComponentInfo> getReqCompsByIds(List<String> reqComponentIds) {
        List<ReqComponentInfo> reqComps = new ArrayList<ReqComponentInfo>();
        for (String id : reqComponentIds) {
            try {
                reqComps.add(statementService.getReqComponent(id));
            } catch (DoesNotExistException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            } catch (InvalidParameterException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            } catch (MissingParameterException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            } catch (OperationFailedException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
        }
        return reqComps;
    }


    public StatementService getStatementService() {
        return statementService;
    }

    public void setStatementService(StatementService statementService) {
        this.statementService = statementService;
    }

    public CourseService getCourseService() {
        return courseService;
    }

    public void setCourseService(CourseService courseService) {
        this.courseService = courseService;
    }


}
