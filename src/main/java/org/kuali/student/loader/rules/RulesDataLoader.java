package org.kuali.student.loader.rules;

import org.apache.cxf.common.logging.LogUtils;
import org.apache.log4j.Logger;
import org.kuali.rice.krms.api.repository.LogicalOperator;
import org.kuali.rice.krms.api.repository.agenda.AgendaDefinition;
import org.kuali.rice.krms.api.repository.agenda.AgendaItemDefinition;
import org.kuali.rice.krms.api.repository.proposition.PropositionDefinition;
import org.kuali.rice.krms.api.repository.proposition.PropositionParameter;
import org.kuali.rice.krms.api.repository.proposition.PropositionParameterType;
import org.kuali.rice.krms.api.repository.proposition.PropositionType;
import org.kuali.rice.krms.api.repository.reference.ReferenceObjectBinding;
import org.kuali.rice.krms.api.repository.rule.RuleDefinition;
import org.kuali.rice.krms.api.repository.term.TermDefinition;
import org.kuali.rice.krms.api.repository.term.TermParameterDefinition;
import org.kuali.rice.krms.api.repository.term.TermSpecificationDefinition;
import org.kuali.student.krms.naturallanguage.util.KsKrmsConstants;
import org.kuali.student.r1.core.statement.dto.*;
import org.kuali.student.r2.lum.course.dto.CourseInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: christoff
 * @info This class takes in rules data in the CM format, converts it to the KRMS format and persists it via the KRMSHelper
 */
public class RulesDataLoader {
    private static final Logger log = Logger
            .getLogger(RulesDataLoader.class);

    private KRMSHelper krmsHelper;
    private StatementHelper statementHelper;


    private Map<String,String> statementTypeToruleTypeConversionMap;
    private Map<String,String> ruleTypeToAgendaTypeRelationMap;
    private Map<String,String> reqCompTypeToPropositionTypeConversionMap;
    private Map<String,String> reqCompFieldTypeToTermParameterTypeConversionMap;
    private Map<String,TemplateInfo> propositionTypeTemplateInfoMap;
    private AgendaDefinition currentAgenda = null;
    AgendaItemDefinition previousAgendaItem = null;
    CourseInfo currentRelatedCourse = null;

    public void startConversion(){
        if(statementTypeToruleTypeConversionMap == null || ruleTypeToAgendaTypeRelationMap == null){
            initTypeConversionMaps();
        }
        List<StatementInfo> rootStatements = statementHelper.getRootStatements();
        for(StatementInfo statement : rootStatements){
            RuleDefinition rootRule = null;
            currentRelatedCourse =  statementHelper.getRelatedCourseFromStatement(statement.getId());
            if(currentRelatedCourse == null){
                System.out.println("Error: No relation to a clu, skipping this root statement: "+statement.getId());
                continue; //skip this statement
            }
            //Create new Agenda
            String typeName = statementHelper.getStatementTypeNameFromTypeId(statement.getType());
            if(statementTypeToruleTypeConversionMap.containsKey(statement.getType())){
                String krmsRuleType = statementTypeToruleTypeConversionMap.get(statement.getType());
                String krmsAgendaType = ruleTypeToAgendaTypeRelationMap.get(krmsRuleType);// krms type type relation
                String krmsAgendaTypeID = krmsHelper.getTypeByName(krmsAgendaType,KsKrmsConstants.NAMESPACE_CODE).getId();
                AgendaDefinition agenda = AgendaDefinition.Builder.create(null, currentRelatedCourse.getCode()+" "+typeName, krmsAgendaTypeID, "10000").build();
                currentAgenda = krmsHelper.createAgenda(agenda);

                //create a link between this agenda and clu that was linked to this statement
                ReferenceObjectBinding.Builder refBldr = ReferenceObjectBinding.Builder.create("Agenda", currentAgenda.getId(), KsKrmsConstants.NAMESPACE_CODE, "kuali.lu.type.CreditCourse", currentRelatedCourse.getId());
                refBldr.setCollectionName("Course");
                refBldr.setActive(true);
                krmsHelper.createReferenceObjectBinding(refBldr.build());

                //Create root rule
                String krmsRuleTypeID = krmsHelper.getTypeByName(krmsRuleType, KsKrmsConstants.NAMESPACE_CODE).getId();
                rootRule = krmsHelper.createRule(RuleDefinition.Builder.create(null, currentRelatedCourse.getCode() + " " + typeName, KsKrmsConstants.NAMESPACE_CODE, krmsRuleTypeID, null).build());
            }else{
                //TODO LOG that there is no mapping to a rule type for this statement type
                System.out.println("Error: There is no mapping to a rule type for this statement type: "+statement.getType());
                continue; // skip this statement
            }
            //Create agenda item
            AgendaItemDefinition.Builder agendaItemBuilder = AgendaItemDefinition.Builder.create(null,currentAgenda.getId());
            agendaItemBuilder.setRuleId(rootRule.getId());
            previousAgendaItem = krmsHelper.createAgendaItem(agendaItemBuilder.build());

            //Update the agenda's first item field with the id of the agenda item
            AgendaDefinition.Builder agendaBuilder = AgendaDefinition.Builder.create(currentAgenda);
            agendaBuilder.setFirstItemId(previousAgendaItem.getId());
            krmsHelper.updateAgenda(agendaBuilder.build());
            //process the required components for this rule
            processReqCompsForRule(rootRule,statement);

            //process the children of this statement
            processSubStatementsForStatement(statement);
            System.out.println("Finished Processing Statement: "+statement.getId());
        }
    }

    private void processSubStatementsForStatement(StatementInfo statement){
        List<StatementInfo> subStatements = statementHelper.getChildStatementsForStatement(statement.getId());
        RuleDefinition subRule = null;
        for(StatementInfo subStatement : subStatements){
            //String courseCode = statementHelper.getCourseCodeFromStatement(subStatement.getId());
            String typeName = statementHelper.getStatementTypeNameFromTypeId(subStatement.getType());
            //Create rule
            if(statementTypeToruleTypeConversionMap.containsKey(subStatement.getType())){
                String krmsRuleType = statementTypeToruleTypeConversionMap.get(subStatement.getType());
                String krmsRuleTypeID = krmsHelper.getTypeByName(krmsRuleType,KsKrmsConstants.NAMESPACE_CODE).getId();
                subRule = krmsHelper.createRule(RuleDefinition.Builder.create(null, currentRelatedCourse.getCode() + " " + typeName, KsKrmsConstants.NAMESPACE_CODE, krmsRuleTypeID, null).build());

            }else{
                //TODO LOG that there is no mapping to a rule type for this statement type
                System.out.println("Error: There is no mapping to a rule type for this statement type: "+statement.getType());
                continue; // skip this statement
            }

            //Create agenda item
            AgendaItemDefinition.Builder agendaItemBuilder = AgendaItemDefinition.Builder.create(null,currentAgenda.getId());
            agendaItemBuilder.setRuleId(subRule.getId());
            AgendaItemDefinition newAgendaItem = krmsHelper.createAgendaItem(agendaItemBuilder.build());

            // set the when true field of the previous item to the id of this one
            agendaItemBuilder = AgendaItemDefinition.Builder.create(previousAgendaItem);
            agendaItemBuilder.setWhenTrueId(newAgendaItem.getId());
            krmsHelper.updateAgendaItem(agendaItemBuilder.build());
            previousAgendaItem = newAgendaItem;
            // process the required components for this rule
            processReqCompsForRule(subRule,subStatement);
            //process the children for this statement
            processSubStatementsForStatement(subStatement);
        }
    }

    private void processReqCompsForRule(RuleDefinition rule, StatementInfo statement){
        List<ReqComponentInfo> reqComponentInfoList = statementHelper.getReqCompsByIds(statement.getReqComponentIds());
        //if statemtent has more than 1 reqcomp then create compound prop
        PropositionDefinition.Builder initPropBuilder = null;
        if(reqComponentInfoList.size() > 1){
            //create the proposition
            String propositionTypeID = null;
            if(statement.getOperator().equals(StatementOperatorTypeKey.AND)){
                propositionTypeID = krmsHelper.getTypeByName("kuali.krms.proposition.type.compound.and",KsKrmsConstants.NAMESPACE_CODE).getId();
                initPropBuilder = PropositionDefinition.Builder.create(null, PropositionType.COMPOUND.getCode(), rule.getId(), propositionTypeID, null);
                initPropBuilder.setCompoundOpCode(LogicalOperator.AND.getCode());
            }else{
                propositionTypeID = krmsHelper.getTypeByName("kuali.krms.proposition.type.compound.or",KsKrmsConstants.NAMESPACE_CODE).getId();
                initPropBuilder = PropositionDefinition.Builder.create(null, PropositionType.COMPOUND.getCode(), rule.getId(), propositionTypeID, null);
                initPropBuilder.setCompoundOpCode(LogicalOperator.OR.getCode());
            }
        }
        //create a simple prop for each reqcomp
        for(ReqComponentInfo reqComponent : reqComponentInfoList){
            //lookup proptype
            String propositionType = reqCompTypeToPropositionTypeConversionMap.get(reqComponent.getType());
            String propositionTypeID = krmsHelper.getTypeByName(propositionType,KsKrmsConstants.NAMESPACE_CODE).getId();
            TemplateInfo template = propositionTypeTemplateInfoMap.get(propositionType);
            //get termspec
            TermSpecificationDefinition termSpec =  krmsHelper.getTermSpecificationByNameAndNamespace(template.getTermSpecName(), KsKrmsConstants.NAMESPACE_CODE);

            //create term
            TermDefinition.Builder termBuilder = TermDefinition.Builder.create(null,TermSpecificationDefinition.Builder.create(termSpec),null);
            TermDefinition term = krmsHelper.createTerm(termBuilder.build());
            List<TermParameterDefinition.Builder> parameters = new ArrayList<TermParameterDefinition.Builder>();
            String constantParam = null;
            for(ReqCompFieldInfo reqCompField : reqComponent.getReqCompFields()){
                if(reqCompField.getType().equals("kuali.reqComponent.field.type.value.positive.integer")){
                    constantParam = reqCompField.getValue();
                    continue; //this constant will be set as a parameter on the proposition
                }
                String termParamType =  reqCompFieldTypeToTermParameterTypeConversionMap.get(reqCompField.getType());
                String termParamTypeID = krmsHelper.getTypeByName(termParamType,KsKrmsConstants.NAMESPACE_CODE).getId();

                //create term parameter
                TermParameterDefinition.Builder termParamBuilder = TermParameterDefinition.Builder.create(null,term.getId(),termParamTypeID,reqCompField.getValue());//TODO translation to our uuids
                parameters.add(termParamBuilder);
            }
            // update the term with the created parameters
            termBuilder = TermDefinition.Builder.create(term);
            termBuilder.setParameters(parameters);
            krmsHelper.updateTerm(termBuilder.build());

            //build proposition parameters for simple proposition
            List< PropositionParameter.Builder> propParams = new ArrayList<PropositionParameter.Builder>();
            propParams.add(PropositionParameter.Builder.create(null, null, term.getId(), PropositionParameterType.TERM.getCode(), 1));
            propParams.add(PropositionParameter.Builder.create(null, null, (constantParam == null ? template.getValue() : constantParam), PropositionParameterType.CONSTANT.getCode(), 2));
            propParams.add(PropositionParameter.Builder.create(null, null, template.getOperator(), PropositionParameterType.OPERATOR.getCode(), 3));

            //create the proposition
            PropositionDefinition.Builder propBuilder = PropositionDefinition.Builder.create(null, PropositionType.SIMPLE.getCode(), rule.getId(), propositionTypeID, propParams);

            //if initProp is not set then this becomes the initProp
            if(initPropBuilder == null){
                initPropBuilder = propBuilder;
            }else{//else add this prop as a child of initProp
                List<PropositionDefinition.Builder> childProps = initPropBuilder.getCompoundComponents();
                childProps.add(propBuilder);
                initPropBuilder.setCompoundComponents(childProps);
            }
        }

        //save init prop
        PropositionDefinition prop = krmsHelper.createProposition(initPropBuilder.build());

        //update the init prop id on rule
        RuleDefinition.Builder ruleBuilder = RuleDefinition.Builder.create(rule);
        ruleBuilder.setPropId(prop.getId());
        rule = ruleBuilder.build();
        krmsHelper.updateRule(rule);

    }

    private void initTypeConversionMaps(){

        statementTypeToruleTypeConversionMap = new HashMap<String,String>();
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.academicReadiness.studentEligibility","kuali.krms.rule.type.course.academicReadiness.studentEligibility");
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.academicReadiness.studentEligibilityPrereq", "kuali.krms.rule.type.course.academicReadiness.studentEligibilityPrereq");
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.academicReadiness.prereq", "kuali.krms.rule.type.course.academicReadiness.prereq");
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.academicReadiness.coreq", "kuali.krms.rule.type.course.academicReadiness.coreq");
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.academicReadiness.antireq", "kuali.krms.rule.type.course.academicReadiness.antireq");
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.recommendedPreparation", "kuali.krms.rule.type.course.recommendedPreparation");
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.credit.repeatable", "kuali.krms.rule.type.course.credit.repeatable"); //type not in ref data
        statementTypeToruleTypeConversionMap.put("kuali.statement.type.course.credit.restriction", "kuali.krms.rule.type.course.credit.restriction");

        propositionTypeTemplateInfoMap = new HashMap<String,TemplateInfo>();
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.success.compl.course",new TemplateInfo("CompletedCourse","=","true"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.success.course.courseset.completed.all",new TemplateInfo("CompletedCourses","=","true"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.completed.nof",new TemplateInfo("NumberOfCompletedCourses","&gt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.success.course.courseset.completed.nof",new TemplateInfo("NumberOfCompletedCourses","&lt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.completed.none",new TemplateInfo("NumberOfCompletedCourses","=","0"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.notcompleted",new TemplateInfo("CompletedCourse","=","false"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.credits.completed.nof",new TemplateInfo("NumberOfCreditsFromCompletedCourses","&lt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.success.credit.courseset.completed.nof",new TemplateInfo("NumberOfCreditsFromCompletedCourses","&gt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.credits.completed.none",new TemplateInfo("NumberOfCreditsFromCompletedCourses","=","0"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.enrolled.all",new TemplateInfo("EnrolledCourses","=","true"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.enrolled.nof",new TemplateInfo("NumberOfEnrolledCourses","&gt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.enrolled",new TemplateInfo("EnrolledCourses","=","true"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.gpa.min",new TemplateInfo("GPAForCourses","&gt;=","gpa"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.cumulative.gpa.min",new TemplateInfo("GPAForCourses","&gt;=","gpa"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.duration.cumulative.gpa.min",new TemplateInfo("GPAForCourses","&gt;=","gpa"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.grade.max",new TemplateInfo("GradeTypeForCourses","&lt;","grade"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.grade.min",new TemplateInfo("GradeTypeForCourses","&gt;=","grade"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.courseset.nof.grade.min",new TemplateInfo("GradeTypeForCourses","&gt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.credits.earned.min",new TemplateInfo("NumberOfCredits","&gt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.credits.repeat.max",new TemplateInfo("NumberOfCredits","&lt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.freeform.text",new TemplateInfo("FreeFormText","=","true"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.success.credits.courseset.completed.nof.org",new TemplateInfo("NumberOfCreditsFromOrganization","&gt;=","n"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.test.score.max",new TemplateInfo("ScoreOnTest","&lt;=","score"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.course.test.score.min",new TemplateInfo("ScoreOnTest","&gt;=","score"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.no.repeat.course",new TemplateInfo("CompletedCourse","=","0"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.no.repeat.courses",new TemplateInfo("CompletedCourses","=","0"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.permission.admin.org",new TemplateInfo("AdminOrganizationPermissionRequired","=","true"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.test.score",new TemplateInfo("ScoreOnTest","&gt;=","score"));
        propositionTypeTemplateInfoMap.put("kuali.krms.proposition.type.admitted.to.program",new TemplateInfo("AdmittedToProgram","=","true"));
        //propositionTypeTemplateInfoMap.put("",new TemplateInfo("termspecname","operator","value"));






        ruleTypeToAgendaTypeRelationMap = new HashMap<String,String>();
        ruleTypeToAgendaTypeRelationMap.put("kuali.krms.rule.type.course.academicReadiness.antireq", "kuali.krms.agenda.type.course.enrollmentEligibility");
        ruleTypeToAgendaTypeRelationMap.put("kuali.krms.rule.type.course.academicReadiness.coreq", "kuali.krms.agenda.type.course.enrollmentEligibility");
        ruleTypeToAgendaTypeRelationMap.put("kuali.krms.rule.type.course.recommendedPreparation", "kuali.krms.agenda.type.course.enrollmentEligibility");
        ruleTypeToAgendaTypeRelationMap.put("kuali.krms.rule.type.course.academicReadiness.studentEligibilityPrereq", "kuali.krms.agenda.type.course.enrollmentEligibility");
        ruleTypeToAgendaTypeRelationMap.put("kuali.krms.rule.type.course.credit.repeatable", "kuali.krms.agenda.type.course.creditConstraints");
        ruleTypeToAgendaTypeRelationMap.put("kuali.krms.rule.type.course.credit.restriction", "kuali.krms.agenda.type.course.creditConstraints");

        reqCompTypeToPropositionTypeConversionMap = new HashMap<String,String>();
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.completed.nof","kuali.krms.proposition.type.course.courseset.completed.nof");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.completed.none","kuali.krms.proposition.type.course.courseset.completed.none");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.credits.completed.nof","kuali.krms.proposition.type.success.credit.courseset.completed.nof");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.credits.completed.none","kuali.krms.proposition.type.course.courseset.credits.completed.none");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.enrolled.all","kuali.krms.proposition.type.course.courseset.enrolled.all");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.enrolled.nof","kuali.krms.proposition.type.course.courseset.enrolled.nof");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.gpa.min","kuali.krms.proposition.type.course.courseset.gpa.min");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.grade.max","kuali.krms.proposition.type.course.courseset.grade.max");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.grade.min","kuali.krms.proposition.type.course.courseset.grade.min");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.nof.grade.min","kuali.krms.proposition.type.course.courseset.nof.grade.min");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.credits.repeat.max","kuali.krms.proposition.type.course.credits.repeat.max");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.enrolled","kuali.krms.proposition.type.course.enrolled");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.test.score.max","kuali.krms.proposition.type.course.test.score.max");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.test.score.min","kuali.krms.proposition.type.course.test.score.min");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.program.programset.completed.all","kuali.krms.proposition.type.success.course.courseset.completed.all");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.freeform.text","kuali.krms.proposition.type.freeform.text");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.notcompleted","kuali.krms.proposition.type.course.notcompleted");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.permission.instructor.required.preco","kuali.krms.proposition.type.permission.instructor.required");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.permission.org.required.preco","kuali.krms.proposition.type.permission.admin.org");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.completed","kuali.krms.proposition.type.success.compl.course");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.completed.all","kuali.krms.proposition.type.success.course.courseset.completed.all");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.courseset.completed.enrolled.all","kuali.krms.proposition.type.course.courseset.enrolled.all");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.credits.min","kuali.krms.proposition.type.credits.earned.min");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.cumulative.gpa.min","kuali.krms.proposition.type.cumulative.gpa.min");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.permission.instructor.required","kuali.krms.proposition.type.permission.instructor.required");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.permission.org.required","kuali.krms.proposition.type.permission.admin.org");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.program.admitted","kuali.krms.proposition.type.admitted.to.program");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.program.notadmitted","kuali.krms.proposition.type.not.admitted.to.program");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.course.standing","kuali.krms.proposition.type.greater.than.class.standing");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.major.org","kuali.krms.proposition.type.admitted.to.program.org");
        reqCompTypeToPropositionTypeConversionMap.put("kuali.reqComponent.type.program.cumulative.gpa.min","kuali.krms.proposition.type.cumulative.gpa.min");
        //reqCompTypeToPropositionTypeConversionMap.put("","");

        reqCompFieldTypeToTermParameterTypeConversionMap = new HashMap<String,String>();
        //reqCompFieldTypeToTermParameterTypeConversionMap.put("kuali.reqComponent.field.type.value.positive.integer","");
        reqCompFieldTypeToTermParameterTypeConversionMap.put("kuali.reqComponent.field.type.value.freeform.text","kuali.term.parameter.type.free.text");
        reqCompFieldTypeToTermParameterTypeConversionMap.put("kuali.reqComponent.field.type.course.cluSet.id","kuali.term.parameter.type.course.cluSet.id");
        reqCompFieldTypeToTermParameterTypeConversionMap.put("kuali.reqComponent.field.type.course.clu.id","kuali.term.parameter.type.course.clu.id");
        reqCompFieldTypeToTermParameterTypeConversionMap.put("kuali.reqComponent.field.type.grade.id","kuali.term.parameter.type.grade.id");
        reqCompFieldTypeToTermParameterTypeConversionMap.put("kuali.reqComponent.field.type.org.id","kuali.term.parameter.type.org.id");
    }

    public StatementHelper getStatementHelper() {
        return statementHelper;
    }

    public void setStatementHelper(StatementHelper statementHelper) {
        this.statementHelper = statementHelper;
    }

    public KRMSHelper getKrmsHelper() {
        return krmsHelper;
    }

    public void setKrmsHelper(KRMSHelper krmsHelper) {
        this.krmsHelper = krmsHelper;
    }

}
