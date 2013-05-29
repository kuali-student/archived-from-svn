package org.kuali.student.loader.rules;

import org.kuali.rice.krms.api.repository.RuleManagementService;
import org.kuali.rice.krms.api.repository.agenda.AgendaDefinition;
import org.kuali.rice.krms.api.repository.agenda.AgendaItemDefinition;
import org.kuali.rice.krms.api.repository.agenda.AgendaTreeDefinition;
import org.kuali.rice.krms.api.repository.agenda.AgendaTreeEntryDefinitionContract;
import org.kuali.rice.krms.api.repository.proposition.PropositionDefinition;
import org.kuali.rice.krms.api.repository.proposition.PropositionParameter;
import org.kuali.rice.krms.api.repository.proposition.PropositionParameterType;
import org.kuali.rice.krms.api.repository.proposition.PropositionType;
import org.kuali.rice.krms.api.repository.reference.ReferenceObjectBinding;
import org.kuali.rice.krms.api.repository.rule.RuleDefinition;
import org.kuali.rice.krms.api.repository.term.TermDefinition;
import org.kuali.rice.krms.api.repository.term.TermParameterDefinition;
import org.kuali.rice.krms.api.repository.term.TermRepositoryService;
import org.kuali.rice.krms.api.repository.term.TermSpecificationDefinition;
import org.kuali.rice.krms.api.repository.type.KrmsTypeRepositoryService;
import org.kuali.student.krms.naturallanguage.util.KsKrmsConstants;
import org.kuali.student.loader.util.ContextInfoHelper;
import org.kuali.student.r1.core.statement.service.StatementService;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.core.versionmanagement.dto.VersionDisplayInfo;
import org.kuali.student.r2.lum.course.dto.CourseInfo;
import org.kuali.student.r2.lum.course.service.CourseService;
import org.kuali.student.r2.lum.util.constants.CluServiceConstants;
import org.kuali.student.r2.lum.util.constants.CourseServiceConstants;

import java.util.*;

/**
 * Created with IntelliJ IDEA.
 * User: christoff
 * Date: 2013/05/22
 */
public class RulesDataCLUtoCOCopier {
    ContextInfo contextInfo;
    private CourseService courseService;
    private RuleManagementService ruleManagementService;
    private KrmsTypeRepositoryService krmsTypeRepositoryService;
    private TermRepositoryService termRepositoryService;
    private Map<String, List<LuiInfoHelper>> luiMap;
    //private RuleDefinition currentRule;

    RulesDataCLUtoCOCopier() {
        contextInfo = new ContextInfo();
        contextInfo.setPrincipalId("RULECOPY");
        contextInfo.setCurrentDate(new Date());
        luiMap = new HashMap<String, List<LuiInfoHelper>>();
        loadCluToLuiData();
    }

    public void setCourseService(CourseService courseServ) {
        this.courseService = courseServ;
    }

    public void setRuleManagementService(RuleManagementService ruleManagementServ) {
        this.ruleManagementService = ruleManagementServ;
    }

    public void setKrmsTypeRepositoryService(KrmsTypeRepositoryService krmsTypeRepositoryService) {
        this.krmsTypeRepositoryService = krmsTypeRepositoryService;
    }

    public void setTermRepositoryService(TermRepositoryService termRepositoryService) {
        this.termRepositoryService = termRepositoryService;
    }

    public void startCopy() {
        for (String cluID : luiMap.keySet()) {
            copyFromCluToLuis(cluID, luiMap.get(cluID));
        }
    }

    private void copyFromCluToLuis(String cluID, List<LuiInfoHelper> luiList) {
        //get the agendas linked to this clu
        List<ReferenceObjectBinding> refs = this.ruleManagementService.findReferenceObjectBindingsByReferenceObject("kuali.lu.type.CreditCourse", cluID);
        for (ReferenceObjectBinding reference : refs) {
            AgendaTreeDefinition agendaTree = ruleManagementService.getAgendaTree(reference.getKrmsObjectId());
            //copy to all the luis linked to this clu and term
            for (LuiInfoHelper lui : luiList) {

                AgendaDefinition clonedAgenda = deepCloneAgenda(agendaTree, lui.getLuiID(), lui.getLuiCode(), lui.getAtpCode());

                //create reference between lui and cloned agenda
                ReferenceObjectBinding.Builder refBldr = ReferenceObjectBinding.Builder.create("Agenda", clonedAgenda.getId(), KsKrmsConstants.NAMESPACE_CODE, "kuali.lui.type.course.offering", lui.getLuiID());
                refBldr.setCollectionName("CourseOffering");
                refBldr.setActive(true);
                ReferenceObjectBinding refBinding = ruleManagementService.createReferenceObjectBinding(refBldr.build());
                System.out.println("Created reference between Agenda: "+clonedAgenda.getId()+" and Course Offering: "+lui.getLuiID());
            }
            System.out.println("Cloned Agenda: "+agendaTree.getAgendaId()+" for "+luiList.size()+" course offerings");
        }
    }

    private AgendaDefinition deepCloneAgenda(AgendaTreeDefinition agendaTree, String luiID, String luiCode, String atpCode) {
        //clone the Agenda
        AgendaDefinition oldAgenda = ruleManagementService.getAgenda(agendaTree.getAgendaId());
        String agendaTypeName = oldAgenda.getName().substring(oldAgenda.getName().lastIndexOf(" ") + 1);
        AgendaDefinition agenda = AgendaDefinition.Builder.create(null, atpCode + " " + luiCode + " " + agendaTypeName, oldAgenda.getTypeId(), oldAgenda.getContextId()).build();
        agenda = ruleManagementService.createAgenda(agenda);
        System.out.println("Created Agenda: " + agenda.getId() + " from " + oldAgenda.getId());
        System.out.println("Created Agenda Item: " + agenda.getFirstItemId());

        boolean firstRule = true;
        for (AgendaTreeEntryDefinitionContract entry : agendaTree.getEntries()) {
            AgendaItemDefinition currentAgendaItem = ruleManagementService.getAgendaItem(entry.getAgendaItemId());
            //process the rule
            RuleDefinition currentRule = currentAgendaItem.getRule();
            String ruleTypeName = currentRule.getName().substring(currentRule.getName().lastIndexOf(" ") + 1);
            RuleDefinition.Builder ruleBuilder = RuleDefinition.Builder.create(null, atpCode + " " + luiCode + " " + ruleTypeName, currentRule.getNamespace(), currentRule.getTypeId(), null);

            //update/create agenda item for this new rule
            String ruleID = null;
            if (firstRule) { //update first item auto created with agenda
                AgendaItemDefinition.Builder agendaItemBuilder = AgendaItemDefinition.Builder.create(ruleManagementService.getAgendaItem(agenda.getFirstItemId()));
                if (agendaItemBuilder.getRuleId() == null) {
                    agendaItemBuilder.setRule(ruleBuilder);
                    ruleManagementService.updateAgendaItem(agendaItemBuilder.build());
                }
                ruleID = ruleManagementService.getAgendaItem(agendaItemBuilder.getId()).getRuleId();
            } else { //create new agenda item for this new rule
                AgendaItemDefinition.Builder agendaItemBuilder = AgendaItemDefinition.Builder.create(null, agenda.getId());
                agendaItemBuilder.setRule(ruleBuilder);
                AgendaItemDefinition newItem = ruleManagementService.createAgendaItem(agendaItemBuilder.build());
                System.out.println("Created Agenda Item: " + newItem.getId());
                ruleID = newItem.getRuleId();
                //TODO update the ifTrue field on the previous agenda item
            }
            System.out.println("Created Rule: " + ruleID);

            //recursively process the propositions
            PropositionDefinition rootProp = currentRule.getProposition();
            PropositionDefinition.Builder newProp = cloneProposition(rootProp, ruleID);
            //update the init prop id on rule
            ruleBuilder = RuleDefinition.Builder.create(ruleManagementService.getRule(ruleID));
            ruleBuilder.setProposition(newProp);
            ruleManagementService.updateRule(ruleBuilder.build());
            System.out.println("Created Root Proposition: " + ruleManagementService.getRule(ruleID).getProposition().getId());
            firstRule = false;
        }
        return agenda;
    }

    private PropositionDefinition.Builder cloneProposition(PropositionDefinition currentProp, String clonedRuleID) {
        //process current prop
        List<PropositionParameter.Builder> propParams = null;
        if (currentProp.getPropositionTypeCode().equals(PropositionType.SIMPLE.getCode())) {
            //create Term with TermParams
            //build proposition parameters for simple proposition
            List<PropositionParameter> currentPropParams = currentProp.getParameters();
            propParams = new ArrayList<PropositionParameter.Builder>();

            //loop through the current prop params copy values
            for (PropositionParameter currentPropParam : currentPropParams) {
                if (PropositionParameterType.TERM.getCode().equals(currentPropParam.getParameterType())) {
                    //clone the term and its parameters
                    TermDefinition currentTerm = currentPropParam.getTermValue();
                    List<TermParameterDefinition> currentTermParams = currentTerm.getParameters();
                    TermDefinition.Builder termBuilder = TermDefinition.Builder.create(null, TermSpecificationDefinition.Builder.create(currentTerm.getSpecification()), null);
                    List<TermParameterDefinition.Builder> termParameters = new ArrayList<TermParameterDefinition.Builder>();
                    for(TermParameterDefinition currentTermParam : currentTermParams){
                        termParameters.add(TermParameterDefinition.Builder.create(null,null,currentTermParam.getName(),currentTermParam.getValue()));
                    }
                    termBuilder.setDescription(currentTerm.getDescription());
                    termBuilder.setParameters(termParameters);
                    TermDefinition term = termRepositoryService.createTerm(termBuilder.build());
                    System.out.println("Created Term: " + term.getId());
                    propParams.add(PropositionParameter.Builder.create(null, null, term.getId(), PropositionParameterType.TERM.getCode(), 1));
                }
                else {
                    propParams.add(PropositionParameter.Builder.create(null, null, currentPropParam.getValue(), currentPropParam.getParameterType(), currentPropParam.getSequenceNumber()));
                }
            }
        }
        PropositionDefinition.Builder propBuilder = PropositionDefinition.Builder.create(null, currentProp.getPropositionTypeCode(), clonedRuleID, currentProp.getTypeId(), propParams);
        propBuilder.setDescription(currentProp.getDescription());


        //if compound proposition, process each child proposition
        if (currentProp.getPropositionTypeCode().equals(PropositionType.COMPOUND.getCode())) {
            propBuilder.setCompoundOpCode(currentProp.getCompoundOpCode());
            List<PropositionDefinition> currentCompoundProps = currentProp.getCompoundComponents();
            List<PropositionDefinition.Builder> clonedCompoundProps = new ArrayList<PropositionDefinition.Builder>();
            for(int i = 0; i< currentCompoundProps.size();i++){
                PropositionDefinition currentCompoundProp  = currentCompoundProps.get(i);
                PropositionDefinition.Builder clonedProposition = cloneProposition(currentCompoundProp, clonedRuleID);
                clonedProposition.setCompoundSequenceNumber(currentCompoundProp.getCompoundSequenceNumber());
                clonedCompoundProps.add(clonedProposition);
            }
            propBuilder.setCompoundComponents(clonedCompoundProps);
        }

        return propBuilder;
    }

    private void addToLuiMap(String cluId, LuiInfoHelper info) {
        if (luiMap.containsKey(cluId)) {
            luiMap.get(cluId).add(info);
        } else {
            List<LuiInfoHelper> newList = new ArrayList<LuiInfoHelper>();
            newList.add(info);
            luiMap.put(cluId, newList);
        }
    }

    private void loadCluToLuiData() {
        addToLuiMap("002df664-1ad0-4fa3-9138-087112bce072", new LuiInfoHelper("ff883e0c-f100-48ad-a158-3b84f3cb17dd", "ENGL310", "201208"));
        addToLuiMap("01434648-64fc-4d04-b95f-06fd0236525c", new LuiInfoHelper("15ddce85-8838-414e-bdf8-da589ccdec1d", "ENGL388P", "201208"));
        addToLuiMap("01434648-64fc-4d04-b95f-06fd0236525c", new LuiInfoHelper("6561ecc7-846f-427e-bcd2-092aeebc7b55", "ENGL388V", "201208"));
        addToLuiMap("01434648-64fc-4d04-b95f-06fd0236525c", new LuiInfoHelper("a3583263-6ecd-409b-ba83-a2c37c5f5b57", "ENGL388A", "201208"));
        addToLuiMap("01434648-64fc-4d04-b95f-06fd0236525c", new LuiInfoHelper("a7be321b-1c7a-418a-ba13-ec20892256c7", "ENGL388T", "201208"));
        addToLuiMap("01434648-64fc-4d04-b95f-06fd0236525c", new LuiInfoHelper("c29c4cc3-58cf-4254-9967-843f364b0cf1", "ENGL388W", "201208"));
        addToLuiMap("01434648-64fc-4d04-b95f-06fd0236525c", new LuiInfoHelper("c38d22d5-debd-4aee-9f57-6fc6a0b3540b", "ENGL388D", "201208"));
        addToLuiMap("01434648-64fc-4d04-b95f-06fd0236525c", new LuiInfoHelper("d2b8930e-b615-4a2e-99fb-df513c4d0283", "ENGL388R", "201208"));
        addToLuiMap("0a2b8b92-b001-4802-8872-f3505ee59fa0", new LuiInfoHelper("ce952e26-0dfc-4903-9879-de76dfd20d52", "HIST810", "201208"));
        addToLuiMap("0a36bf3c-13ab-4a46-89d1-bf983fcf5f40", new LuiInfoHelper("89309ceb-878f-4a3f-94bb-752e751c986d", "HIST395", "201208"));
        addToLuiMap("0c433ac2-1f8d-449f-9f2c-532f2f4a48ac", new LuiInfoHelper("f30dfd98-e7c9-42b4-bc29-54323826d411", "BSCI329", "201208"));
        addToLuiMap("0c74e0f2-229e-4b0a-98b4-b65c6e0ecce3", new LuiInfoHelper("30930997-03a7-4301-8df4-f037605bb47b", "PHYS420", "201208"));
        addToLuiMap("0cfa8dfc-ae4f-43f0-9abb-1b7b3ae26c20", new LuiInfoHelper("dc6c5174-0f95-4ab1-b880-2bdc05bf4dc6", "ENGL311", "201208"));
        addToLuiMap("0d9c40b8-8a8b-4532-846b-953bb04ba618", new LuiInfoHelper("0994250e-3bdf-4fa7-8bbf-a9d6ba1d4a96", "ENGL395", "201208"));
        addToLuiMap("0e04c46d-4322-4e17-9d42-60d16b7cfb7e", new LuiInfoHelper("0452a908-9dc0-4653-966e-b3c9f26ea746", "ENGL478M", "201208"));
        addToLuiMap("0f757521-4861-4955-ac24-5fcfdc0a7df9", new LuiInfoHelper("cde14b2e-62cd-48d5-a7ca-ef629fbdc94a", "PHYS141", "201208"));
        addToLuiMap("0fd71585-b967-49f6-bd5a-6b7137070a0d", new LuiInfoHelper("ccacb87d-fb1a-45e3-a7ba-6426108a68da", "BSCI289", "201208"));
        addToLuiMap("121176a2-bd12-49e1-9c68-5976152800be", new LuiInfoHelper("59c680a6-b97c-4fc9-87c2-b2e48b8c8c83", "ENGL233", "201208"));
        addToLuiMap("1dfceb69-3534-4f69-8fc8-34cacd0962bb", new LuiInfoHelper("6c910aec-2972-49a0-aa73-4d20bab20c42", "ENGL305", "201208"));
        addToLuiMap("1e42c91e-2831-44f9-8565-a013a97110b8", new LuiInfoHelper("49104ca3-aa50-43f2-ad68-c15f56a6b32c", "ENGL402", "201208"));
        addToLuiMap("1ec7256d-51b3-40ac-8c0b-d1042a3b5b17", new LuiInfoHelper("977f5cfe-dc4d-4cbb-9526-b15011630e05", "ENGL440", "201208"));
        addToLuiMap("20e17225-ef77-4434-8731-c83e69656e83", new LuiInfoHelper("1d11945f-5fe1-42ab-870d-d5b4d3fc1ba5", "HIST356", "201208"));
        addToLuiMap("22c763ad-5212-4cc9-8099-31d75992abf7", new LuiInfoHelper("fccf688f-685d-4dae-84e9-610807445d33", "BSCI207", "201208"));
        addToLuiMap("2440d47b-4b57-44f9-881f-1f2608cff950", new LuiInfoHelper("671cd822-834b-4b55-af3f-631ae85033b6", "ENGL404", "201208"));
        addToLuiMap("244840aa-4e66-4a6b-9151-86d9ab6b4b9c", new LuiInfoHelper("d55f3531-b165-4566-9723-ff62f4cabeb0", "ENGL454", "201208"));
        addToLuiMap("25102d6b-6e3d-49f3-981f-6a065a6599f6", new LuiInfoHelper("9c7df0ed-b121-44dd-ada0-ae30210a79c3", "HIST354", "201208"));
        addToLuiMap("25bebef3-96b2-4d46-9531-362303d5f2c2", new LuiInfoHelper("f765d5f9-c1f0-45de-a677-ab9ad758f1fb", "PHYS174", "201208"));
        addToLuiMap("26418faf-6bd2-4dac-9570-d1ac09c5eab0", new LuiInfoHelper("cd05c291-7bf3-4ea7-bfb6-0432b32013ac", "ENGL304", "201208"));
        addToLuiMap("2a1b541e-f9c2-4ac6-b774-5f31c4f6e498", new LuiInfoHelper("c9f64290-4926-4d84-98b0-b83d812d1aed", "ENGL373", "201208"));
        addToLuiMap("2b8546bc-9f4d-423b-999f-532307e9841b", new LuiInfoHelper("c24dc181-fdf8-42f0-acd3-99b0557690c2", "BSCI283", "201208"));
        addToLuiMap("2d69d93d-c0c4-4e76-bfa4-0ed5828cdac9", new LuiInfoHelper("23f45fe5-4a89-4f03-9925-caf1a377e531", "PHYS161", "201208"));
        addToLuiMap("2f064a39-e998-4720-8b34-0b38a3cf7e2c", new LuiInfoHelper("6fa3c3c1-f7d0-42de-a6f0-aa1c37e98566", "BSCI440", "201208"));
        addToLuiMap("30a3b114-6251-433c-b759-0236fb49638b", new LuiInfoHelper("de21023c-2432-4cc3-a052-3e54c6c36dc8", "BSCI363", "201208"));
        addToLuiMap("31d1514a-7665-4b57-bcc4-66ff7e6a1208", new LuiInfoHelper("da1ade3d-ebca-40f3-b1f1-ceb24290384e", "ENGL494", "201208"));
        addToLuiMap("321f58af-a09e-4b33-aec1-030f1711ebad", new LuiInfoHelper("a3295808-3c0d-482b-aac9-5964f18f58b4", "WMST601", "201208"));
        addToLuiMap("32ccb0b6-bc84-4f5d-8a0f-939ea550c4da", new LuiInfoHelper("b407841c-0bd3-4f50-9a38-4e312632745d", "BSCI360", "201208"));
        addToLuiMap("3804374c-89ec-43ff-a1ac-2fbe46b8bffe", new LuiInfoHelper("edda3734-51dc-461c-a406-62b6deb68783", "HIST355", "201208"));
        addToLuiMap("39b47c39-451a-4aff-9c87-47092e8627f0", new LuiInfoHelper("d2d9c623-1407-450d-81b0-8a9a04a6a3cc", "BSCI258", "201208"));
        addToLuiMap("3aa939f6-cb83-431c-9fc5-04bb1189f8b8", new LuiInfoHelper("97c1843c-c0e7-44f4-9b28-3b38a592c24d", "BSCI393", "201208"));
        addToLuiMap("3bf6727d-0e78-4a8b-9e40-a80f0c0509d6", new LuiInfoHelper("bb4913fe-d354-43d1-ab11-36efcb754d46", "PHYS270", "201208"));
        addToLuiMap("3bfe8a66-01ba-4e60-bc91-3267f01e5998", new LuiInfoHelper("ac725ab1-d886-4e55-b09a-c3b41e41adbc", "BSCI425", "201208"));
        addToLuiMap("3cb6152f-d1a0-4fb1-a446-bd976430e263", new LuiInfoHelper("7dade84a-80eb-4b41-b589-4cd312e47db9", "ENGL392", "201208"));
        addToLuiMap("3d82d97d-9d16-4023-944b-477b2f512108", new LuiInfoHelper("4775a35b-fe83-4ac2-8630-c0b4558a913d", "PHYS272H", "201208"));
        addToLuiMap("3d82d97d-9d16-4023-944b-477b2f512108", new LuiInfoHelper("ffeffe93-79cf-4cf2-bedd-ffbad2128c77", "PHYS272", "201208"));
        addToLuiMap("3e20cee4-ec0c-414c-bd29-d7e5cdf3b76c", new LuiInfoHelper("ad4051e1-3ba2-44bf-b89c-3832b55eb473", "ENGL403", "201208"));
        addToLuiMap("40f3db39-f3e9-432e-945b-dbaf2bed7ed4", new LuiInfoHelper("22f75db7-d9ac-4da7-ba0c-6def7b544718", "CHEM682", "201208"));
        addToLuiMap("41fa80ff-9191-4cf8-92b0-8995b3eb0476", new LuiInfoHelper("8f367f09-baf4-45cf-a16d-6a3646d3a205", "BSCI392", "201208"));
        addToLuiMap("42e895c9-2b95-44e4-8540-36aa54d010e8", new LuiInfoHelper("3bbd4bd7-003e-4560-9683-4fa6cd1b3b5d", "BSCI421", "201208"));
        addToLuiMap("43db5040-aeb6-44f6-8928-852557e7518d", new LuiInfoHelper("86f0b22d-32d3-4e98-ae98-7e466cb7f7fb", "PHYS171", "201208"));
        addToLuiMap("43db5040-aeb6-44f6-8928-852557e7518d", new LuiInfoHelper("f37332df-a330-4419-8ba9-43adf7526c19", "PHYS171H", "201208"));
        addToLuiMap("446974e6-f969-4218-8f25-1a48c42824ca", new LuiInfoHelper("852e6b6d-6506-45b9-8137-f04b4bf5092c", "PHYS121", "201208"));
        addToLuiMap("44ceae2e-c770-406d-a872-8b0bd1f14515", new LuiInfoHelper("f6c520dc-bb8c-4a1b-a0e6-423e224811b5", "BSCI446", "201208"));
        addToLuiMap("45c6d476-c887-4002-9100-1a1c71b2f7fe", new LuiInfoHelper("20560029-ab47-4746-9123-e9002f63ec6e", "WMST499", "201208"));
        addToLuiMap("4989573b-e84d-457e-8082-ab547230f3b2", new LuiInfoHelper("61c3c379-a6c7-4f55-92c9-b38b38b703b7", "ENGL479N", "201208"));
        addToLuiMap("4989573b-e84d-457e-8082-ab547230f3b2", new LuiInfoHelper("808d4df8-9780-4553-bb5b-e7c6df8f7550", "ENGL479M", "201208"));
        addToLuiMap("4989573b-e84d-457e-8082-ab547230f3b2", new LuiInfoHelper("86bfeb70-f5e3-4b02-834f-53a67bc825be", "ENGL479E", "201208"));
        addToLuiMap("4989573b-e84d-457e-8082-ab547230f3b2", new LuiInfoHelper("b6e1cf4d-e056-4e4c-81d0-1088a6aea6e0", "ENGL479V", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("54a1f697-b8b8-478a-be64-b728fddcf9c4", "BSCI279Q", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("87df8aed-2868-4e52-ad3c-19796969702f", "BSCI279L", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("8daa31a5-a12c-459d-9210-81bff91de04f", "BSCI279R", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("a9aadcbd-dfae-436d-bf71-5ce3079a21a0", "BSCI279P", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("afa3f491-9f31-41a6-8fb2-e122de0c2705", "BSCI279B", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("bc6a0281-c8e6-40ec-8413-3e5836a05e52", "BSCI279", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("d2916a9b-5253-49c0-b660-5e1b12b36f05", "BSCI279N", "201208"));
        addToLuiMap("4a12c632-8806-470d-8646-59e7b6786318", new LuiInfoHelper("f6f63909-59a7-47a1-8f40-e019c6af7bcd", "BSCI279V", "201208"));
        addToLuiMap("4dd8552d-b0f9-4229-ba86-c7055e68e37a", new LuiInfoHelper("d77e987a-47a8-4e0b-9d57-b496bb1c0bbd", "BSCI443", "201208"));
        addToLuiMap("5030c77c-dcd9-4906-8d7a-18c41bf3c44e", new LuiInfoHelper("26a78093-b489-4eb7-8671-74e5c1aac82a", "ENGL313", "201208"));
        addToLuiMap("50ac6ec5-5846-4a9b-b1ae-5e99da800fd7", new LuiInfoHelper("5ea24d4a-4c2f-40a0-b2d2-80c61edcd438", "PHYS405", "201208"));
        addToLuiMap("51f228a4-d464-48eb-b7aa-ec5dc535aa68", new LuiInfoHelper("97dced0b-c580-4d74-b426-3a142613c451", "ENGL408B", "201208"));
        addToLuiMap("527df0aa-98d3-48ac-a21c-aff3a5b13e89", new LuiInfoHelper("774e1ed1-b2f6-4bc5-83ef-9c27f275a06f", "ENGL465", "201208"));
        addToLuiMap("55f24c68-57d0-4c33-889a-7313cc81d108", new LuiInfoHelper("41d7a5dc-408d-42ef-b4ed-86a0760c6104", "WMST386", "201208"));
        addToLuiMap("57230088-c649-47d4-9966-773fd200ec60", new LuiInfoHelper("44ffeb07-05ff-409f-b806-b2bb5c591989", "HIST332", "201208"));
        addToLuiMap("58946f65-4ef5-4ee1-b89e-9a67d91d9d9d", new LuiInfoHelper("20ee579b-3ac1-4708-b07e-c6f5ab939963", "PHYS407", "201208"));
        addToLuiMap("5a4d3135-f16c-4f11-ba91-ec603d825903", new LuiInfoHelper("f49a4305-4dbd-48e6-8d3c-a1b5e93a85a7", "BSCI394", "201208"));
        addToLuiMap("5ca26aad-6388-40cd-bee6-69e5829b1ea7", new LuiInfoHelper("3e41692e-d32e-4709-b659-382daef72d32", "PHYS276", "201208"));
        addToLuiMap("5cbb5be7-32d6-483c-9fcc-ee62fd9ce7ff", new LuiInfoHelper("6d96c4f2-677d-4d70-b396-3c9bff3e4ac9", "HIST462", "201208"));
        addToLuiMap("5db19137-3986-43f9-8eb2-526cfc4276f1", new LuiInfoHelper("5a5efee0-3bd7-411a-b369-103dafd9e511", "BSCI437", "201208"));
        addToLuiMap("5f267393-58e2-4483-8d94-f3d8ff284963", new LuiInfoHelper("60556923-b372-47cc-be8d-3e34a7d62fd8", "BSCI465", "201208"));
        addToLuiMap("5f53c3db-a2fc-4ad7-a8ae-5b5ff66b1bf2", new LuiInfoHelper("2331ab10-a658-4a2e-acd2-0f7274295f5c", "WMST400", "201208"));
        addToLuiMap("5f8f97ac-0138-4a3f-930e-43f8782e8345", new LuiInfoHelper("9afc90f8-a1ce-47f9-9833-4b48e665b83d", "BSCI410", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("438c5eb6-4340-4a56-b74f-634c0393390c", "HIST408D", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("80f6db4d-0aa8-47f2-a638-a9961c0e2eae", "HIST408F", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("84eb9460-3a90-41ec-bc1a-e7cd92faf0dc", "HIST408R", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("c0784e9b-cfbf-4a52-a319-dfb16619d4d3", "HIST408P", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("d26a0b48-1b4b-4a0f-bfdd-f6f33869c527", "HIST408N", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("de4ca7fe-0824-49cd-b2d3-8cc3621e978f", "HIST408Y", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("eccc7c54-24f7-46cd-81ca-76ebcc131bd9", "HIST408G", "201208"));
        addToLuiMap("64195984-a054-4921-b5bc-900922bb36ca", new LuiInfoHelper("fffcff08-331b-420e-bf1b-0631c3ac0ad5", "HIST408I", "201208"));
        addToLuiMap("646488d9-1dad-48c6-bbb9-ce46d1781a37", new LuiInfoHelper("1d9e36ba-d17e-4977-9eae-f908fd411362", "BSCI453", "201208"));
        addToLuiMap("6962d16c-0d7b-4add-922e-338ae9a6636c", new LuiInfoHelper("605e8fb7-4082-4142-889d-db9b6e406a86", "ENGL455", "201208"));
        addToLuiMap("6a81b2da-a809-4ce4-9c7d-6bc90ba28be1", new LuiInfoHelper("6f6719f3-a416-4863-8a80-81cdca53d9f8", "BSCI420", "201208"));
        addToLuiMap("6ba96f9e-fa38-45db-b06b-59991c1c63eb", new LuiInfoHelper("0f074dc5-91ec-4a9d-9f27-decbdbb79e8e", "PHYS832", "201208"));
        addToLuiMap("6dccaf6a-a7ae-4e7c-b2f6-8a07ed68f376", new LuiInfoHelper("9930d57f-d4ee-4029-be49-0bd478d4c175", "ENGL466", "201208"));
        addToLuiMap("6efed35c-8a4c-46d0-9859-44e5c190f72b", new LuiInfoHelper("3878fd27-bd5f-4547-94c7-969a725f1b3e", "WMST444", "201208"));
        addToLuiMap("6efed35c-8a4c-46d0-9859-44e5c190f72b", new LuiInfoHelper("3878fd27-bd5f-4547-94c7-969a725f1b3e", "ENGL444", "201208"));
        addToLuiMap("6f6f7cf2-e746-423b-ba7e-de8d924700f1", new LuiInfoHelper("65810eb5-1512-49e5-9b46-ee5542d234e2", "BSCI426", "201208"));
        addToLuiMap("6f7eeec8-866e-4b11-81b2-6f091b79b6f4", new LuiInfoHelper("a6e22a6d-9118-488f-b560-cb08a5a5e67c", "WMST300", "201208"));
        addToLuiMap("70af693e-ca8c-4181-b0ce-754a22f1ea19", new LuiInfoHelper("53fa8783-bd3c-47c2-aeb5-8f7dd901dcac", "BSCI473", "201208"));
        addToLuiMap("724972ae-61ff-4792-8e8a-700bac3fb942", new LuiInfoHelper("116c6d6a-4da3-4922-894b-fd7c868835b8", "PHYS410", "201208"));
        addToLuiMap("73acba95-b7ab-494c-a726-6accd2de5257", new LuiInfoHelper("075b54a0-133a-4e58-9b89-99cb1498e0f0", "CHEM399A", "201208"));
        addToLuiMap("73acba95-b7ab-494c-a726-6accd2de5257", new LuiInfoHelper("26a79829-b42c-441b-b9cf-0d8f7a35629f", "CHEM399C", "201208"));
        addToLuiMap("73acba95-b7ab-494c-a726-6accd2de5257", new LuiInfoHelper("84d4cc82-a24f-4775-8374-a5a4ebcab530", "CHEM399X", "201208"));
        addToLuiMap("73acba95-b7ab-494c-a726-6accd2de5257", new LuiInfoHelper("9a3126b4-bcad-403a-87ba-ddc438141039", "CHEM399B", "201208"));
        addToLuiMap("77cd596a-25a1-417d-a6be-b6a34d53dee1", new LuiInfoHelper("8102a69b-84ee-4821-ac13-0db5dc500ab7", "HIST398", "201208"));
        addToLuiMap("78383c62-4c90-44cb-990c-e4520cb21a38", new LuiInfoHelper("c8beee82-c736-48c0-ae94-50f43ee5d6eb", "BSCI414", "201208"));
        addToLuiMap("79b5efd6-15c9-442a-bee4-3bd5a80b033f", new LuiInfoHelper("2580ca0a-fbb1-4747-a4c5-b906e7b8ea12", "ENGL475", "201208"));
        addToLuiMap("79cb36dd-96a7-4f9e-8d4b-ef6223cb343a", new LuiInfoHelper("5d173609-7c64-4b7a-bc16-b51c1f0905b7", "PHYS131", "201208"));
        addToLuiMap("7b753b62-ef54-485c-9cb7-3afd92d071ae", new LuiInfoHelper("a2955a85-ca3f-4e1b-9327-6b7a612e82aa", "PHYS273H", "201208"));
        addToLuiMap("7b753b62-ef54-485c-9cb7-3afd92d071ae", new LuiInfoHelper("a74e81c6-a581-44c9-85d9-7585b7c19715", "PHYS273", "201208"));
        addToLuiMap("7c553f44-61a5-4ebd-bb55-9df5e90c307a", new LuiInfoHelper("870f21e1-c44f-416e-bdad-b63f58ab5201", "PHYS431", "201208"));
        addToLuiMap("8597c766-5cf9-4223-90bd-0c18d697ec28", new LuiInfoHelper("ad8229d3-dbca-4830-a9cd-4fb1b8b36143", "WMST336", "201208"));
        addToLuiMap("8bdc6414-4b96-4069-97bf-e572e5f90525", new LuiInfoHelper("2e46125f-03cc-4e7f-b39e-3b7320c7f6c7", "ENGL420", "201208"));
        addToLuiMap("8dfe51b0-eb43-49d9-aab6-a1b1d83be4ed", new LuiInfoHelper("04c96d30-ff49-4f6f-b6da-b0c18ae825b8", "PHYS275", "201208"));
        addToLuiMap("8e9304fb-9003-4ec2-8b93-d24a4a64c1ee", new LuiInfoHelper("92f16bdf-3fed-4728-8993-8e7469d660c9", "BSCI422", "201208"));
        addToLuiMap("8f924f66-a2dc-4834-bfad-1cb6c6faf2df", new LuiInfoHelper("93ad4328-e7c4-4a52-b6b6-d5878416abc4", "BSCI427", "201208"));
        addToLuiMap("91ac48e7-5df9-4bc8-be86-44c52e66cf06", new LuiInfoHelper("3cbfe0c9-9f2d-4b9f-a362-5c8a2fd91d17", "ENGL312", "201208"));
        addToLuiMap("941a37ab-cf17-4b25-adf7-c23fd098cf18", new LuiInfoHelper("bc54bfe3-72be-47dc-b993-f3ce7fb115d1", "BSCI462", "201208"));
        addToLuiMap("9820f4f3-b90e-4678-bb6d-57c17887ce6e", new LuiInfoHelper("da771868-8217-4779-b100-c0bd171cae8a", "ENGL457", "201208"));
        addToLuiMap("9d4104bd-b99d-4bbc-9e3a-8507ed8b607d", new LuiInfoHelper("d4b0c19a-09d9-41ea-a3a6-0ff5c1a02fa2", "BSCI481", "201208"));
        addToLuiMap("9da9fee3-588a-4d67-b620-615226fc177d", new LuiInfoHelper("97134099-1307-4c0b-b64b-6b7ff97a7e69", "ENGL301", "201208"));
        addToLuiMap("9ece45f8-ae91-421a-8f4e-20f120ea6929", new LuiInfoHelper("7c685fab-c924-4c43-a9c2-bf0f41b964ad", "PHYS102", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("00905570-addc-40ec-bdb6-e1ce635e05be", "WMST498R", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("33148f61-b2da-44a7-86ba-ed06c009c555", "WMST498D", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("4d535f9c-5971-4668-a0da-215a5ae4e5a2", "WMST498O", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("716faf6a-426a-4e39-b9ab-15d8bb15b93c", "WMST498Y", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("8ab488f9-ffe3-452b-9326-7f49f3130641", "WMST498I", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("9ac5e072-a9cc-4646-a3c6-ef7f1ded83a0", "WMST498H", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("e915b5b1-7b2e-4166-a293-091245dcbdb2", "WMST498C", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("e9a30bdb-667d-4831-86b4-7e3796309cbc", "WMST498A", "201208"));
        addToLuiMap("9fb75593-9445-44ce-8d82-53e1634ae52d", new LuiInfoHelper("e9c4e961-e9db-45ce-b4b2-d83aec0dbd0d", "WMST498E", "201208"));
        addToLuiMap("CLUID-BSCI330-200708000000", new LuiInfoHelper("be1052b5-5c16-4a1c-94a7-73de24f62556", "BSCI330", "201208"));
        addToLuiMap("CLUID-BSCI373-199908000000", new LuiInfoHelper("9c98b778-def8-453e-954c-579dc84e26fa", "BSCI373", "201208"));
        addToLuiMap("CLUID-BSCI379-199908000000", new LuiInfoHelper("591811e9-2f79-4a30-87df-d52c23ece266", "BSCI379H", "201208"));
        addToLuiMap("CLUID-BSCI379-199908000000", new LuiInfoHelper("b4d29631-5bf5-4b87-ba9c-e96290773959", "BSCI379P", "201208"));
        addToLuiMap("CLUID-BSCI379-199908000000", new LuiInfoHelper("b42a5add-c003-4e76-a5db-f3bf4e9df873", "BSCI379G", "201208"));
        addToLuiMap("CLUID-CHEM132-200508000000", new LuiInfoHelper("56802cf2-5577-4163-9fa7-a356396e8d45", "CHEM132C", "201208"));
        addToLuiMap("CLUID-CHEM132-200508000000", new LuiInfoHelper("5fc5ff07-eb70-4c0a-b549-124eb879c8cb", "CHEM132S", "201208"));
        addToLuiMap("CLUID-CHEM132-200508000000", new LuiInfoHelper("ee786c4b-57c9-4237-9519-4bdb961ca5d4", "CHEM132", "201208"));
        addToLuiMap("CLUID-CHEM136-200108000000", new LuiInfoHelper("e960defa-3c0c-4bf6-bb2f-0ec13d80096d", "CHEM136", "201208"));
        addToLuiMap("CLUID-CHEM147-200508000000", new LuiInfoHelper("bc3cafeb-5c1a-452c-9ab3-dabb992d1178", "CHEM147", "201208"));
        addToLuiMap("CLUID-CHEM247-199508000000", new LuiInfoHelper("759bba9a-0ccf-4ddd-bdb9-8abe46f2b784", "CHEM247", "201208"));
        addToLuiMap("CLUID-CHEM272-200508000000", new LuiInfoHelper("fdfd8711-e66e-4618-8321-f4bc74062792", "CHEM272", "201208"));
        addToLuiMap("CLUID-CHEM277-200608000000", new LuiInfoHelper("8e7fa3b9-9560-4f2e-88c5-59c29dc9f126", "CHEM277", "201208"));
        addToLuiMap("CLUID-CHEM403-198001000000", new LuiInfoHelper("0c5fcfef-11dd-4e89-b9ab-a28b4b2d7fb0", "CHEM403", "201208"));
        addToLuiMap("CLUID-CHEM441-198001000000", new LuiInfoHelper("e67d87d6-8d89-401a-86ac-08ca8bd5195b", "CHEM441", "201208"));
        addToLuiMap("CLUID-CHEM460-199501000000", new LuiInfoHelper("6f2cb68a-b09d-4b2b-8459-7fe17de11055", "CHEM460", "201208"));
        addToLuiMap("CLUID-CHEM474-198001000000", new LuiInfoHelper("abf9196f-a0d2-4558-b47b-308bf0257c35", "CHEM474", "201208"));
        addToLuiMap("CLUID-CHEM482-198001000000", new LuiInfoHelper("99f82ba5-ad01-4489-b446-99ea8f62d292", "CHEM482", "201208"));
        addToLuiMap("CLUID-CHEM608-198001000000", new LuiInfoHelper("eb942c03-0e7e-4bd7-a774-d26cb1c64f25", "CHEM608K", "201208"));
        addToLuiMap("CLUID-CHEM625-198001000000", new LuiInfoHelper("9dd9724e-efd6-4d31-9624-b46450b57027", "CHEM625", "201208"));
        addToLuiMap("CLUID-CHEM684-198001000000", new LuiInfoHelper("4a6f4368-2a17-4bef-b62c-872fa66f8211", "CHEM684", "201208"));
        addToLuiMap("CLUID-CHEM699-198001000000", new LuiInfoHelper("ce30b18d-5003-430c-9b8d-07d320785f4d", "CHEM699", "201208"));
        addToLuiMap("CLUID-ENGL293-201101000000", new LuiInfoHelper("8c8ed771-2e0e-46c0-ae7e-ccb2773abd2d", "ENGL293", "201208"));
        addToLuiMap("CLUID-ENGL334-201108000000", new LuiInfoHelper("78e9eb94-3bb4-4935-b119-b8a6c1eefb44", "ENGL334", "201208"));
        addToLuiMap("CLUID-ENGL346-200701000000", new LuiInfoHelper("59fedaaa-e123-4689-8a4c-c4c327be63b7", "ENGL346", "201208"));
        addToLuiMap("CLUID-ENGL349-200208000000", new LuiInfoHelper("7cb7df16-0f6f-4e38-91c4-e6382537789d", "ENGL349B", "201208"));
        addToLuiMap("CLUID-ENGL381-198405000000", new LuiInfoHelper("2ac31757-e96f-4440-b899-4abe8b45b9cb", "ENGL381", "201208"));
        addToLuiMap("CLUID-ENGL390-200608000000", new LuiInfoHelper("c84f4345-43e2-4614-a0c8-b07979255b2b", "ENGL390", "201208"));
        addToLuiMap("CLUID-ENGL391-198001000000", new LuiInfoHelper("6f4597e1-4df6-4697-960d-4633c95813ca", "ENGL391", "201208"));
        addToLuiMap("CLUID-ENGL391-198001000000", new LuiInfoHelper("ddca6d81-5afe-4f97-ae9e-2962a71c640d", "ENGL391H", "201208"));
        addToLuiMap("CLUID-ENGL393-198001000000", new LuiInfoHelper("5bff7d60-ba98-4931-84e5-49cfe277cc50", "ENGL393X", "201208"));
        addToLuiMap("CLUID-ENGL393-198001000000", new LuiInfoHelper("8486ece6-c5bb-45d4-b7f8-44447b2c8abd", "ENGL393H", "201208"));
        addToLuiMap("CLUID-ENGL393-198001000000", new LuiInfoHelper("994b5530-8c9f-49bb-ba7a-9fe3f13f9b44", "ENGL393", "201208"));
        addToLuiMap("CLUID-ENGL394-198808000000", new LuiInfoHelper("8654b604-c60c-4042-a726-f02dfbed5362", "ENGL394", "201208"));
        addToLuiMap("CLUID-ENGL398-200608000000", new LuiInfoHelper("12536289-900d-4a13-a9ed-4a63ae3295b0", "ENGL398N", "201208"));
        addToLuiMap("CLUID-ENGL398-200608000000", new LuiInfoHelper("2d176b34-bb47-4a9a-b423-d4da4675dc1c", "ENGL398E", "201208"));
        addToLuiMap("CLUID-ENGL398-200608000000", new LuiInfoHelper("4238bd82-ccc0-4dc9-b1ac-ffbbaf1e4e0b", "ENGL398R", "201208"));
        addToLuiMap("CLUID-ENGL398-200608000000", new LuiInfoHelper("439e9a06-ca61-4dc6-b827-2e5b1fbaa1d4", "ENGL398L", "201208"));
        addToLuiMap("CLUID-ENGL398-200608000000", new LuiInfoHelper("5eea1b4d-c2c7-451e-b667-5b5c023f6d3d", "ENGL398C", "201208"));
        addToLuiMap("CLUID-ENGL398-200608000000", new LuiInfoHelper("8f9a1188-4d01-40f7-ad82-2dd22b7b28d6", "ENGL398A", "201208"));
        addToLuiMap("CLUID-ENGL398-200608000000", new LuiInfoHelper("cb611853-db92-44d2-a983-2bf0faeb0541", "ENGL398V", "201208"));
        addToLuiMap("CLUID-ENGL428-200508000000", new LuiInfoHelper("097fee89-3f6c-4ff2-887e-c06afcff28ab", "ENGL428X", "201208"));
        addToLuiMap("CLUID-ENGL467-200408000000", new LuiInfoHelper("89f8d1ab-18ca-4f26-8560-ebc82a214a73", "ENGL467", "201208"));
        addToLuiMap("CLUID-ENGL611-198001000000", new LuiInfoHelper("af70dace-d04c-445d-bc40-43dfa4860144", "ENGL611", "201208"));
        addToLuiMap("CLUID-ENGL688-198901000000", new LuiInfoHelper("c567753a-6ad7-4014-96dd-d476a1241bb4", "ENGL688", "201208"));
        addToLuiMap("CLUID-ENGL689-198901000000", new LuiInfoHelper("4ac25b25-f8a0-459d-890b-f0d8adf0170c", "ENGL689", "201208"));
        addToLuiMap("CLUID-ENGL699-198001000000", new LuiInfoHelper("b5bfb12c-d0dc-4d5a-a0f5-62f48769a3b9", "ENGL699", "201208"));
        addToLuiMap("CLUID-ENGL702-200208000000", new LuiInfoHelper("455ed826-50de-4a92-ba09-60da7722e315", "ENGL702", "201208"));
        addToLuiMap("CLUID-ENGL798-200208000000", new LuiInfoHelper("ad37535b-b5b3-405d-b558-44f366938dbe", "ENGL798B", "201208"));
        addToLuiMap("CLUID-HIST208-200208000000", new LuiInfoHelper("357a9a6f-c67f-48f1-a07d-e748d6b140af", "HIST208Q", "201208"));
        addToLuiMap("CLUID-HIST208-200208000000", new LuiInfoHelper("71efd160-2c1c-485e-833b-8923ce371f9e", "HIST208G", "201208"));
        addToLuiMap("CLUID-HIST208-200208000000", new LuiInfoHelper("73828f6b-6123-45d1-9147-d56cfec6b18c", "HIST208E", "201208"));
        addToLuiMap("CLUID-HIST208-200208000000", new LuiInfoHelper("dbb97e50-b737-4b3c-955e-4d81e9f58b1f", "HIST208D", "201208"));
        addToLuiMap("CLUID-HIST208-200208000000", new LuiInfoHelper("f4df6060-9ce8-4a0b-88de-c3cb85e0d0ca", "HIST208R", "201208"));
        addToLuiMap("CLUID-HIST299-200108000000", new LuiInfoHelper("82b97445-2f9b-49b8-839a-2e61a5f78786", "HIST299", "201208"));
        addToLuiMap("CLUID-HIST326-198108000000", new LuiInfoHelper("d2d6f51e-ecba-46a3-b59c-167bd568657e", "HIST326", "201208"));
        addToLuiMap("CLUID-HIST352-199501000000", new LuiInfoHelper("3bd925af-bc10-41de-ae7e-35d62ded96f1", "HIST352", "201208"));
        addToLuiMap("CLUID-HIST353-199501000000", new LuiInfoHelper("3a7d5985-02ca-4ff7-83fc-75909528786d", "HIST353", "201208"));
        addToLuiMap("CLUID-HIST357-199501000000", new LuiInfoHelper("ad0653ed-b829-4c48-af30-45703e073eca", "HIST357", "201208"));
        addToLuiMap("CLUID-HIST499-198801000000", new LuiInfoHelper("54a54861-fca3-41a5-ad5f-fcc611bc0149", "HIST499", "201208"));
        addToLuiMap("CLUID-HIST811-200301000000", new LuiInfoHelper("5e4ae1c0-1757-437c-841c-237c62c2d9df", "HIST811", "201208"));
        addToLuiMap("CLUID-PHYS170-199608000000", new LuiInfoHelper("19e6f37a-1a72-4542-9397-c536c8f13eed", "PHYS170", "201208"));
        addToLuiMap("CLUID-PHYS261-200308000000", new LuiInfoHelper("9d6310d5-a4fa-4d75-a9d6-35d3aee62622", "PHYS261", "201208"));
        addToLuiMap("CLUID-PHYS261-200308000000", new LuiInfoHelper("e8729cde-1afa-4d3c-aecb-055651de0155", "PHYS261M", "201208"));
        addToLuiMap("CLUID-PHYS271-200308000000", new LuiInfoHelper("a35ae6ea-652c-4e1b-b053-089123dca4b6", "PHYS271", "201208"));
        addToLuiMap("CLUID-PHYS271-200308000000", new LuiInfoHelper("b18d15d2-0357-463a-9032-26f6caaf87b4", "PHYS271M", "201208"));
        addToLuiMap("CLUID-PHYS299-198001000000", new LuiInfoHelper("b5a51944-7966-47c8-9e49-903c85fd30fb", "PHYS299", "201208"));
        addToLuiMap("CLUID-PHYS374-199701000000", new LuiInfoHelper("717f613e-9b73-4315-9b88-25e3bd03f08d", "PHYS374", "201208"));
        addToLuiMap("CLUID-PHYS389-198001000000", new LuiInfoHelper("e0ed00e0-fede-4e11-881e-c899d3487c88", "PHYS389", "201208"));
        addToLuiMap("CLUID-PHYS399-198001000000", new LuiInfoHelper("a59d59cc-6af1-40f2-95c6-a605a82d35b0", "PHYS399", "201208"));
        addToLuiMap("CLUID-PHYS402-199708000000", new LuiInfoHelper("483d6c1c-72a4-46d6-a46c-93451f07d12c", "PHYS402", "201208"));
        addToLuiMap("CLUID-PHYS601-198001000000", new LuiInfoHelper("fa089c19-308e-4996-8bc6-e78467cda2fd", "PHYS601", "201208"));
        addToLuiMap("CLUID-PHYS604-198001000000", new LuiInfoHelper("e8dac437-f6a8-46dd-8ed8-6c1143d194e5", "PHYS604", "201208"));
        addToLuiMap("CLUID-PHYS622-198001000000", new LuiInfoHelper("ecfe534a-c526-4805-904c-644bc5b59aa7", "PHYS622", "201208"));
        addToLuiMap("CLUID-PHYS624-198001000000", new LuiInfoHelper("45297ff5-8c62-4ee1-8c7c-e22c138e12db", "PHYS624", "201208"));
        addToLuiMap("CLUID-PHYS675-199301000000", new LuiInfoHelper("031b74e9-b72a-4cb0-8d65-11b2b76022e6", "PHYS675", "201208"));
        addToLuiMap("CLUID-PHYS711-198001000000", new LuiInfoHelper("877ab3f3-2eff-49fa-8c7e-f89e35497f54", "PHYS711", "201208"));
        addToLuiMap("CLUID-PHYS715-199301000000", new LuiInfoHelper("ed154e38-cbbf-4c52-baf6-54ebfe3538d2", "PHYS715", "201208"));
        addToLuiMap("CLUID-PHYS751-198001000000", new LuiInfoHelper("c98c549f-3284-438c-907a-ca30eb58428d", "PHYS751", "201208"));
        addToLuiMap("CLUID-PHYS761-198001000000", new LuiInfoHelper("d4b02d05-5391-47ad-a8b1-13cad0f683f2", "PHYS761", "201208"));
        addToLuiMap("CLUID-WMST325-199501000000", new LuiInfoHelper("256892a0-de49-4aee-9fec-e659256c3af7", "WMST325", "201208"));
        addToLuiMap("CLUID-WMST348-199501000000", new LuiInfoHelper("b421eeff-f858-4e23-96ec-bd12471bf326", "WMST348A", "201208"));
        addToLuiMap("CLUID-WMST348-199501000000", new LuiInfoHelper("e6894f2d-fa8c-47e2-8869-6cd443836ba4", "WMST348F", "201208"));
        addToLuiMap("CLUID-WMST408-199501000000", new LuiInfoHelper("9ee777fc-55de-4c0a-b830-42dd30012dbd", "WMST408B", "201208"));
        addToLuiMap("CLUID-WMST488-199408000000", new LuiInfoHelper("9fc91894-4275-4e7c-92ea-8703d67d02c0", "WMST488S", "201208"));
        addToLuiMap("CLUID-WMST488-199408000000", new LuiInfoHelper("e4714f32-6174-495a-96ea-4598509bd55c", "WMST488J", "201208"));
        addToLuiMap("CLUID-WMST618-199801000000", new LuiInfoHelper("821eb198-f199-42d7-a102-5ca9fb1b8e00", "WMST618", "201208"));
        addToLuiMap("CLUID-WMST619-199801000000", new LuiInfoHelper("e1ee5297-e8df-41ca-863a-ad750f71aeb0", "WMST619", "201208"));
        addToLuiMap("CLUID-WMST698-199008000000", new LuiInfoHelper("cef1f697-fa74-4b68-a1c5-b6b2b62ff73d", "WMST698D", "201208"));
        addToLuiMap("CLUID-WMST699-198701000000", new LuiInfoHelper("a6d1cd26-ff6a-4323-8267-23b2ef2a16a3", "WMST699", "201208"));
        addToLuiMap("a0849169-fdf9-4918-9e3a-2571a3931332", new LuiInfoHelper("c28af84f-d257-43d2-b43b-7dc7f07fcccf", "ENGL495", "201208"));
        addToLuiMap("a1e31e75-3d71-4ebf-96c5-12a25d55d23a", new LuiInfoHelper("19bb06aa-a076-4937-8fc4-acccf85b9828", "CHEM611", "201208"));
        addToLuiMap("a3492b05-f0dd-4e5e-9380-a67850ec36a2", new LuiInfoHelper("53ccaf5f-3790-442e-b9e0-463d1e5d69f0", "ENGL379V", "201208"));
        addToLuiMap("a3492b05-f0dd-4e5e-9380-a67850ec36a2", new LuiInfoHelper("6daf0595-8283-464e-bc25-36740a1e2ef7", "ENGL379J", "201208"));
        addToLuiMap("a3492b05-f0dd-4e5e-9380-a67850ec36a2", new LuiInfoHelper("8be414db-39b2-479c-9386-1ea3d788f97a", "ENGL379P", "201208"));
        addToLuiMap("a3492b05-f0dd-4e5e-9380-a67850ec36a2", new LuiInfoHelper("97ca0c50-4286-45a4-9d3f-d2385c88dc04", "ENGL379D", "201208"));
        addToLuiMap("a3492b05-f0dd-4e5e-9380-a67850ec36a2", new LuiInfoHelper("b4c8f482-af4c-4939-b00f-6c90597a1aaa", "ENGL379W", "201208"));
        addToLuiMap("a59819c6-ef1c-43d3-8666-0d4a7093c689", new LuiInfoHelper("9bf403ac-e1ac-45d1-842e-442ae4984e71", "PHYS122", "201208"));
        addToLuiMap("a6576213-fc14-43b3-9d69-29fc1336de8f", new LuiInfoHelper("0605a1c6-9e7f-43fc-930d-160e23962dbb", "PHYS404", "201208"));
        addToLuiMap("a7736015-db5d-4b08-a831-2fac1cd24083", new LuiInfoHelper("6bcb0519-7b3b-44aa-8382-c2f062082c62", "BSCI447", "201208"));
        addToLuiMap("abc960c4-e91c-4e55-9449-efa04dc2eb07", new LuiInfoHelper("5b3c37a6-7572-4a88-96c3-dc1d44f53666", "PHYS375", "201208"));
        addToLuiMap("b17a9b20-fab6-41b7-bea9-88be78b98479", new LuiInfoHelper("db15e453-e064-4897-88f4-d05c381aa79c", "BSCI454", "201208"));
        addToLuiMap("b6430647-7353-44e3-9aa9-7a510e767451", new LuiInfoHelper("22a2c9db-f1dc-427d-95ce-49a5ee25c5e8", "BSCI361", "201208"));
        addToLuiMap("b7816033-91ef-42f0-b05b-9cd42bcde0c7", new LuiInfoHelper("2429d23b-4293-4c78-b2fe-6f837ab2f121", "HIST232", "201208"));
        addToLuiMap("be959064-e46d-48cf-9eb1-6201e0484a19", new LuiInfoHelper("49ba43d0-d5da-4d31-9ef0-c5ddf947bc52", "BSCI223", "201208"));
        addToLuiMap("befe1ac4-332b-48dd-97f1-86f4fea032ff", new LuiInfoHelper("b8df2d80-0a59-482c-b098-2830f1061c6f", "HIST492", "201208"));
        addToLuiMap("befe1ac4-332b-48dd-97f1-86f4fea032ff", new LuiInfoHelper("b8df2d80-0a59-482c-b098-2830f1061c6f", "WMST456", "201208"));
        addToLuiMap("bfd8f468-df65-4f53-9c28-52dc5efb4487", new LuiInfoHelper("c0f8bc43-886e-4f6d-8306-4809cc7f3a8c", "BSCI442", "201208"));
        addToLuiMap("c09fbe38-a870-45f3-b2ed-183ac16bb7e0", new LuiInfoHelper("6483a682-99cb-49f0-8218-c9d3bd8437af", "WMST709", "201208"));
        addToLuiMap("c24c0896-991d-453a-94e0-64cc9f77ddff", new LuiInfoHelper("34296855-c304-4073-a69f-06261b56c934", "HIST608N", "201208"));
        addToLuiMap("c24c0896-991d-453a-94e0-64cc9f77ddff", new LuiInfoHelper("6c7c7840-73aa-48b5-b641-302a5f6367e8", "HIST608T", "201208"));
        addToLuiMap("c24c0896-991d-453a-94e0-64cc9f77ddff", new LuiInfoHelper("81c4ed32-0a77-4a67-9572-36ef227d79b2", "HIST608A", "201208"));
        addToLuiMap("c24c0896-991d-453a-94e0-64cc9f77ddff", new LuiInfoHelper("d1e91560-489b-4153-a433-85af8cd7eacd", "HIST608C", "201208"));
        addToLuiMap("c56b0e32-764d-4be1-a61b-a6e08ee191cc", new LuiInfoHelper("eecdef60-1fcf-4e18-b7fe-d22e1bda5ef4", "PHYS401", "201208"));
        addToLuiMap("c8572d44-87fa-484f-836f-80e926c7ce76", new LuiInfoHelper("bd2178f9-597d-4eb6-a1c3-5c53dad69d72", "PHYS115", "201208"));
        addToLuiMap("c8ce9b3a-1c7b-4806-9f18-c10a9b2b456a", new LuiInfoHelper("88173470-7e01-4b30-8c67-aa9720e1ca46", "BSCI222", "201208"));
        addToLuiMap("c994c056-2784-4fd7-996c-e55890f40f23", new LuiInfoHelper("f2f1fa62-6f04-48f7-ab98-6a83e7ffcbb0", "BSCI370", "201208"));
        addToLuiMap("cd0ca272-e64a-4842-98db-9462b9c361de", new LuiInfoHelper("f1505c66-a5f4-4fe3-b9a4-4beb88002614", "ENGL470", "201208"));
        addToLuiMap("cf9f3597-8d88-49dd-b76d-28e8748a6199", new LuiInfoHelper("554e8683-bffa-4cf6-bed8-b6bdbf1b9359", "BSCI201", "201208"));
        addToLuiMap("d2e8c421-2d7f-44be-98f9-758890219331", new LuiInfoHelper("aa369f1b-c68d-48b5-b057-7f39b248f1f1", "BSCI471", "201208"));
        addToLuiMap("d82b9c5c-d6d5-4857-ba92-f2a8f2561001", new LuiInfoHelper("8446f32c-047e-4bd2-b9af-7451cdc14f89", "PHYS260H", "201208"));
        addToLuiMap("d82b9c5c-d6d5-4857-ba92-f2a8f2561001", new LuiInfoHelper("a36f55be-fa47-4eab-923f-4b0bd35ee697", "PHYS260", "201208"));
        addToLuiMap("db01c1e3-18a5-4104-9b01-4b16da17eb49", new LuiInfoHelper("2d1945d1-5923-494c-a8df-22490483aec1", "BSCI399", "201208"));
        addToLuiMap("db01c1e3-18a5-4104-9b01-4b16da17eb49", new LuiInfoHelper("fd21026f-086e-4cd4-be6b-05ddde120b69", "BSCI399H", "201208"));
        addToLuiMap("dcdffb2d-99c9-4c3a-b82a-075cfa722656", new LuiInfoHelper("50ac4dc3-30b3-4f17-bf9d-f3409a7dc8d7", "HIST819A", "201208"));
        addToLuiMap("dcdffb2d-99c9-4c3a-b82a-075cfa722656", new LuiInfoHelper("a555677c-4fdd-44e6-bbd3-49f0ed1a5252", "HIST819K", "201208"));
        addToLuiMap("dcdffb2d-99c9-4c3a-b82a-075cfa722656", new LuiInfoHelper("bf0d858d-fc47-44f4-9eb6-bd9d47d856a4", "HIST819B", "201208"));
        addToLuiMap("de7dee18-061d-472a-b226-363880ecd223", new LuiInfoHelper("5f683bcf-501e-4b7a-a40a-ed14e51a82b9", "ENGL472", "201208"));
        addToLuiMap("e0592268-98a3-4f38-8646-ae36515d37cd", new LuiInfoHelper("c823b30e-b075-41dd-bd19-05d5644b8ca6", "ENGL429", "201208"));
        addToLuiMap("e05a99f4-fc4a-4942-9783-9f8fa29994c6", new LuiInfoHelper("efacd4e3-7b01-4c40-8433-ddd93219e168", "HIST386", "201208"));
        addToLuiMap("e06a59fd-3ac7-4150-9158-39443fbc9bee", new LuiInfoHelper("050179ae-b0a7-4654-b60b-efe43eb6dc17", "BSCI202", "201208"));
        addToLuiMap("e0d6f4da-e737-45db-8cc9-d63a4b926066", new LuiInfoHelper("60a7623e-784a-4a68-a454-379ff5adf1cb", "PHYS721", "201208"));
        addToLuiMap("e3f6f561-487c-4e99-98d1-861ac8fe4657", new LuiInfoHelper("fe428ac6-68c4-4509-a7b4-9834a2c6a17e", "BSCI424", "201208"));
        addToLuiMap("e782575f-7976-448d-83c7-39d13cf6b5cb", new LuiInfoHelper("98e72ae9-2d60-4216-834c-90ce094c7101", "HIST476", "201208"));
        addToLuiMap("e9a4e168-0dfe-4e19-a88c-c9b9999e27d9", new LuiInfoHelper("2267c521-6398-4017-ac5c-30ee24c48854", "ENGL362", "201208"));
        addToLuiMap("e9ce2e9c-c645-4f30-81ae-4a114cef6a21", new LuiInfoHelper("427b91ca-dc9e-4188-9538-b0b793cdce54", "HIST708", "201208"));
        addToLuiMap("eaf8cd54-552c-42e9-802c-293dd0555672", new LuiInfoHelper("136cfb12-9b91-46ba-a176-af417449527c", "ENGL348A", "201208"));
        addToLuiMap("eaf8cd54-552c-42e9-802c-293dd0555672", new LuiInfoHelper("b42055d3-671c-4c7e-af4b-1da579277637", "ENGL348F", "201208"));
        addToLuiMap("ec06665e-f585-4c92-a69c-4d6c6e9490de", new LuiInfoHelper("9416aebd-ff32-4204-9ef4-b9eac9990102", "BSCI467", "201208"));
        addToLuiMap("ec507eaa-318a-4138-b8b5-d797ffa56c66", new LuiInfoHelper("088d856b-6e1e-4f74-8a5a-760449b25cc6", "ENGL368B", "201208"));
        addToLuiMap("ec507eaa-318a-4138-b8b5-d797ffa56c66", new LuiInfoHelper("e70d4d89-074b-44b5-9b9d-0c2251b55966", "ENGL368F", "201208"));
        addToLuiMap("efd06103-797e-428e-831a-3542e27beee7", new LuiInfoHelper("587bdefb-39f0-4627-95e0-f23ec74eedb9", "ENGL317", "201208"));
        addToLuiMap("f1303980-0d91-44c5-a71c-9f569d8de140", new LuiInfoHelper("aa2aab7b-b76e-4e68-bd22-3e8c7e93c835", "ENGL433", "201208"));
        addToLuiMap("f412687c-6cdc-4e2e-b0de-92b25dedaace", new LuiInfoHelper("067a9041-daae-4b75-9105-2a1712e4464a", "ENGL416", "201208"));
        addToLuiMap("f71f6332-23d4-49a8-9645-2a234de293fb", new LuiInfoHelper("ec209040-20a2-48e2-ad5a-1e3aa02d499f", "BSCI411", "201208"));
        addToLuiMap("fa7cd7bb-9d4f-4832-b31a-44280730bc01", new LuiInfoHelper("578f8c63-04c5-446e-81ab-f7e96d119135", "BSCI389", "201208"));
        addToLuiMap("fa7cd7bb-9d4f-4832-b31a-44280730bc01", new LuiInfoHelper("a45d1bcd-88e4-403e-934b-e3c845865066", "BSCI389H", "201208"));
        addToLuiMap("faa3af9b-432e-4ba8-a1ac-cf87173ca9a8", new LuiInfoHelper("215457bf-236c-4e68-b759-b9390a71e178", "PHYS411", "201208"));
        addToLuiMap("fbaef52c-442b-4761-85e7-5ab3b238c627", new LuiInfoHelper("643d3af4-8db8-4e5a-9704-bcea2d0f9829", "ENGL245", "201208"));
        addToLuiMap("fc69da44-98f2-4c83-8ac9-d9f2bca95f59", new LuiInfoHelper("5535ff93-0d40-4883-92ea-5f6e34655677", "BSCI415", "201208"));
        addToLuiMap("fd24c16d-a713-48e0-9b98-bc04d7ab5e7c", new LuiInfoHelper("3ec29254-cce5-4a11-b2d5-4d6a7b8f1136", "BSCI288", "201208"));
        addToLuiMap("fd4e7d91-94eb-407f-b465-13930e0aded9", new LuiInfoHelper("ded47cf3-9560-4ba5-91bf-acf74b0c31b9", "WMST314", "201208"));
        addToLuiMap("fd7e4894-be5e-4e88-a7a8-d9a4fa2045d6", new LuiInfoHelper("7cdd5c71-5cca-4469-b0ed-9083e94ffc5a", "BSCI441", "201208"));
    }


}
