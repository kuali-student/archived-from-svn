/**
 * Copyright 2005-2013 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl2.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.rice.krms.util;

import java.util.ArrayList;
import java.util.List;

import org.kuali.rice.krad.uif.UifConstants;
import org.kuali.rice.krad.uif.component.BindingInfo;
import org.kuali.rice.krad.uif.component.Component;
import org.kuali.rice.krad.uif.container.Group;
import org.kuali.rice.krad.uif.container.GroupBase;
import org.kuali.rice.krad.uif.lifecycle.ViewLifecycle;
import org.kuali.rice.krad.uif.lifecycle.ViewLifecycleRestriction;
import org.kuali.rice.krad.uif.util.ObjectPropertyUtils;
import org.kuali.rice.krms.dto.AgendaEditor;
import org.kuali.rice.krms.service.RuleViewHelperService;

/**
 * @author Kuali Student Team
 */
public class AgendaSection extends GroupBase {

    private String propertyName;
    private BindingInfo bindingInfo;

    private Group agendaPrototype;
    private Group rulePrototype;

    private AgendaBuilder agendaBuilder;

    public AgendaSection(){
        super();
    }

    @Override
    public void performInitialization(Object model) {
        setFieldBindingObjectPath(getBindingInfo().getBindingObjectPath());

        super.performInitialization(model);

        if (bindingInfo != null) {
            bindingInfo.setDefaults(ViewLifecycle.getView(), getPropertyName());
        }

    }

    @Override
    public void performApplyModel(Object model, Component parent) {
        // get the collection for this group from the model
        List<Object> modelCollection = ObjectPropertyUtils.getPropertyValue(model,
                this.getBindingInfo().getBindingPath());

        //Set the ruleviewhelperservice on the agendabuilder.
        this.getAgendaBuilder().setViewHelperService((RuleViewHelperService) ViewLifecycle.getHelper());

        // create agenda sections for each agenda
        List<Component> items = new ArrayList<Component>();
        for (int index = 0; index < modelCollection.size(); index++) {
            AgendaEditor agenda = (AgendaEditor) modelCollection.get(index);
            items.add(this.getAgendaBuilder().buildAgenda(agenda, index, this));
        }
        this.setItems(items);

        super.performApplyModel(model, parent);
    }

    /**
     * @see org.kuali.rice.krad.uif.component.ComponentBase#copy()
     */
    @Override
    protected <T> void copyProperties(T component) {
        super.copyProperties(component);

        AgendaSection agendaSectionCopy = (AgendaSection) component;
        agendaSectionCopy.setPropertyName(this.propertyName);
        if (this.agendaPrototype != null){
            agendaSectionCopy.setAgendaPrototype((Group) this.agendaPrototype.copy());
        }
        if (this.rulePrototype != null){
            agendaSectionCopy.setRulePrototype((Group) this.rulePrototype.copy());
        }
        if (this.bindingInfo != null) {
            agendaSectionCopy.setBindingInfo((BindingInfo) this.bindingInfo.copy());
        }
    }

    public AgendaBuilder getAgendaBuilder() {
        if (this.agendaBuilder == null) {
            this.agendaBuilder = new AgendaBuilder();
        }
        return this.agendaBuilder;
    }

    public String getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    public BindingInfo getBindingInfo() {
        return bindingInfo;
    }

    public void setBindingInfo(BindingInfo bindingInfo) {
        this.bindingInfo = bindingInfo;
    }

    @ViewLifecycleRestriction(UifConstants.ViewPhases.INITIALIZE)
    public Group getAgendaPrototype() {
        return agendaPrototype;
    }

    public void setAgendaPrototype(Group agendaPrototype) {
        this.agendaPrototype = agendaPrototype;
    }

    @ViewLifecycleRestriction(UifConstants.ViewPhases.INITIALIZE)
    public Group getRulePrototype() {
        return rulePrototype;
    }

    public void setRulePrototype(Group rulePrototype) {
        this.rulePrototype = rulePrototype;
    }
}
