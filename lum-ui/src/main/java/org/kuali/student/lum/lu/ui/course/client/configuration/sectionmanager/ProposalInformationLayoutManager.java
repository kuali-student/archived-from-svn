/*
 * Copyright 2007 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 1.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl1.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.lum.lu.ui.course.client.configuration.sectionmanager;

import java.util.Map;

import org.kuali.student.common.ui.client.configurable.ConfigurableField;
import org.kuali.student.common.ui.client.configurable.PropertyBinding;
import org.kuali.student.common.ui.client.dto.HelpInfo;
import org.kuali.student.common.ui.client.widgets.KSCheckBox;
import org.kuali.student.common.ui.client.widgets.KSDropDown;
import org.kuali.student.common.ui.client.widgets.forms.KSFormField;
import org.kuali.student.common.ui.client.widgets.list.KSCheckBoxList;
import org.kuali.student.common.ui.client.widgets.list.ListItems;
import org.kuali.student.common.validator.Validator;
import org.kuali.student.core.dictionary.dto.FieldDescriptor;
import org.kuali.student.lum.lu.ui.course.client.configuration.DefaultCreateUpdateLayout;
import org.kuali.student.lum.lu.ui.course.client.configuration.LUConstants;
import org.kuali.student.lum.lu.ui.course.client.configuration.SimpleConfigurableSection;
import org.kuali.student.lum.lu.ui.course.client.configuration.typemanager.CreditCourseDataManager;
import org.kuali.student.lum.lu.ui.course.client.service.CluProposal;

import com.google.gwt.user.client.ui.Widget;

/**
 * This is a description of what this class does - hjohnson don't forget to fill this in. 
 * 
 * @author Kuali Student Team (kuali-student@googlegroups.com)
 *
 */
public class ProposalInformationLayoutManager {

    private DefaultCreateUpdateLayout<CluProposal> layout;
    private Map<String, FieldDescriptor> fields;
    private Validator validator;

    //Author and Collaborator lists
    private ListItems originatorList ;
    private ListItems delegatorList ;

    //Governance lists
    private ListItems curriculumOversightList ;
    private ListItems campusLocationList ;
    private ListItems organizationList ;

    //Course Format lists
    private ListItems atpList ;
    private ListItems durationList ;
    
    public ProposalInformationLayoutManager() {
        super();
        loadData();
    }

    public ProposalInformationLayoutManager(DefaultCreateUpdateLayout<CluProposal> layout,
            Map<String, FieldDescriptor> fields, Validator validator) {
        super();
        loadData();
        this.layout = layout;
        this.fields = fields;
        this.validator = validator;
    }

    public DefaultCreateUpdateLayout<CluProposal> addSection(String type, String state) {

        addAuthorAndCollaboratorsSection();
        addGovernanceSection();
        addCourseFormatSection();       

        return layout;
    }

    private void addAuthorAndCollaboratorsSection() {

        KSDropDown originatorDropDown = new KSDropDown();
        originatorDropDown.setListItems(originatorList);

        KSDropDown delegatorDropDown = new KSDropDown();
        delegatorDropDown.setListItems(delegatorList);

        layout.addSection(new String[] {LUConstants.SECTION_PROPOSAL_INFORMATION, 
                LUConstants.SECTION_AUTHORS_AND_COLLABORATORS}, 
                new SimpleConfigurableSection<CluProposal>()
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                return object.getProposalInfo().getProposerPersonId();
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                object.getProposalInfo().setProposerPersonId(value.toString());
                            }
                        })
                        .setFormField(new KSFormField("originatingFacultyMember", "Originating Faculty Member")
                        .setWidget(originatorDropDown)
                        .setHelpInfo(new HelpInfo("helpid")  
                        
                        )
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("originatingFacultyMember")))
                        )                        
                )
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                // TODO figure out how to get the administrative delegate
                                return "Jim";
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                // TODO figure out which field is the administrative delegate
                            }
                        })
                        .setFormField(new KSFormField("administrativeDelegate", "Administrative Delegate")
                        .setWidget(delegatorDropDown)
                        .setHelpInfo(new HelpInfo("helpid")
                        
                        )
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("administrativeDelegate")))
                        )
                )
                .setSectionTitle(LUConstants.SECTION_AUTHORS_AND_COLLABORATORS)
                .setInstructions("Instructions go here...")
                .setParentLayout(layout)
        );
    }

    private void addGovernanceSection() {

        Widget curriculumWidget = buildCurriculumWidget();
        Widget campusLocationWidget = buildCampusLocationWidget();
        Widget organizationWidget = buildOrganizationWidget();

        layout.addSection(new String[] {LUConstants.SECTION_PROPOSAL_INFORMATION, 
                LUConstants.SECTION_GOVERNANCE}, 
                new SimpleConfigurableSection<CluProposal>()
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                // TODO figure out how to get the curriculum oversight
                                return "graduate";
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                // TODO figure out which field is the curriculum oversight
                            }
                        })
                        .setFormField(new KSFormField("curriculumOversight", "Curriculum Oversight")
                        .setWidget(curriculumWidget)
                        .setHelpInfo(new HelpInfo("helpid")
                        )
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("curriculumOversight")))
                        )
                )
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                // TODO figure out how to get values
                                return "South campus";
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                // TODO figure out how to set value
                            }
                        })
                        .setFormField(new KSFormField("campusLocation", "Campus Location")
                        // Wireframe shows this as a group of checkboxes
                        .setWidget(campusLocationWidget)
                        .setHelpInfo(new HelpInfo("helpid")
                        )
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("curriculumOversight")))
                        )
                )                
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                return object.getProposalInfo().getProposerOrgId();
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                object.getProposalInfo().setProposerOrgId(value.toString());
                            }
                        })
                        .setFormField(new KSFormField("adminOrg", "Administering Organization")
                        .setWidget(organizationWidget)
                        .setHelpInfo(new HelpInfo("helpid")
                        )
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("adminOrg")))
                        )
                )
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                // TODO figure out how to get values
                                return new Boolean(false);
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                // TODO figure out how to set values
                            }
                        })
                        .setFormField(new KSFormField("crossListed", "Cross Listed")
                        .setWidget(new KSCheckBox())
                        .setHelpInfo(new HelpInfo("helpid")
                        )
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("adminOrg")))
                        )
                )                
                .setSectionTitle(LUConstants.SECTION_GOVERNANCE)
                .setInstructions("Instructions go here...")
                .setParentLayout(layout)      
        );
    }

    private void addCourseFormatSection() {

        KSDropDown atpDropDown = new KSDropDown();
        atpDropDown.setListItems(atpList);

        KSDropDown durationDropDown = new KSDropDown();
        durationDropDown.setListItems(durationList);



        layout.addSection(new String[] {LUConstants.SECTION_PROPOSAL_INFORMATION, 
                LUConstants.SECTION_COURSE_FORMAT}, 
                new SimpleConfigurableSection<CluProposal>()
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                // TODO figure out how to get values
                                return "Summer";
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                // TODO figure out how to set values
                            }
                        })
                        .setFormField(new KSFormField("term", "Term")
                        .setWidget(atpDropDown)
                        .setHelpInfo(new HelpInfo("helpid"))
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("adminOrg")))
                        )
                )
                .addField(new ConfigurableField<CluProposal>()
                        .setBinding(new PropertyBinding<CluProposal>() {
                            @Override
                            public Object getValue(CluProposal object) {
                                // TODO figure out how to get values
                                return "13 week";
                            }
                            @Override
                            public void setValue(CluProposal object, Object value) {
                                // TODO figure out how to set values
//                              object.setStdDuration();

                            }
                        })
                        .setFormField(new KSFormField("duration", "Duration")
                        .setWidget(durationDropDown)
                        .setHelpInfo(new HelpInfo("helpid")
                        )
//                      .addConstraint(new DictionaryConstraint(validator, fields.get("adminOrg")))
                        )
                )

                .setSectionTitle(LUConstants.SECTION_COURSE_FORMAT)
                .setInstructions("Instructions go here...")
                .setParentLayout(layout)  
        );
    }

    private void loadData() {
        originatorList  = CreditCourseDataManager.getOriginators();
        delegatorList = CreditCourseDataManager.getDelegators();
        curriculumOversightList = CreditCourseDataManager.getCurriculumOversights();
        
        campusLocationList = CreditCourseDataManager.getCampusLocations();
        organizationList = CreditCourseDataManager.getOrganizations();
        atpList = CreditCourseDataManager.getAtps();
        durationList = CreditCourseDataManager.getDurations();
    }
    

    private Widget buildOrganizationWidget() {
        //TODO This will probably need to be a search or selectable tree
        //TODO This should probably be a ConfigurableGroup
        KSDropDown organizationDropDown = new KSDropDown();
        organizationDropDown.setListItems(organizationList);
              
//        OrgLocateTree orgTree = new OrgLocateTree();

        return organizationDropDown;
    }

    private Widget buildCampusLocationWidget() {
        KSDropDown locationDropDown = new KSDropDown();
        locationDropDown.setListItems(campusLocationList);
        return locationDropDown;
    }

    private Widget buildCurriculumWidget() {
        KSCheckBoxList curriculumCheckBox = new KSCheckBoxList();
        curriculumCheckBox.setMultipleSelect(false);
        curriculumCheckBox.setListItems(curriculumOversightList);
        return curriculumCheckBox;
    }
}
