/*
 * Copyright 2011 The Kuali Foundation
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
package org.kuali.student.ui.admin.state;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.xml.namespace.QName;
import org.apache.log4j.Logger;
import org.kuali.rice.core.api.criteria.Predicate;
import org.kuali.rice.core.api.criteria.PredicateFactory;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.rice.core.api.resourceloader.GlobalResourceLoader;
import org.kuali.rice.krad.lookup.LookupableImpl;
import org.kuali.rice.krad.web.form.LookupForm;
import org.kuali.student.enrollment.common.util.ContextBuilder;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.core.class1.state.dto.LifecycleInfo;
import org.kuali.student.r2.core.class1.state.service.StateService;
import org.kuali.student.r2.core.constants.StateServiceConstants;

public class LifecycleInfoAdminLookupableImpl extends LookupableImpl {

    private static final Logger LOG = Logger.getLogger(LifecycleInfoAdminLookupableImpl.class);
    private transient StateService stateService;

    @Override
    protected List<LifecycleInfo> getSearchResults(LookupForm lookupForm, Map<String, String> fieldValues, boolean unbounded) {
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        for (String fieldName : fieldValues.keySet()) {
            String value = fieldValues.get(fieldName);
            if (value != null && !value.isEmpty()) {
                pList.add(PredicateFactory.equal(fieldName, value));
            }
        }
        // TODO: modify the search impl so that an empty list of predicates is the same as a null, right now an empty list causes an error 
        if (!pList.isEmpty()) {
            qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        }
        qBuilder.setPredicates(PredicateFactory.and(pList.toArray(new Predicate[pList.size()])));
        try {
            List<LifecycleInfo> list = this.getStateService().searchForLifecycles(qBuilder.build(), getContextInfo());
            // TODO: fix the impl so it doesn't return null
            if (list == null) {
                return new ArrayList<LifecycleInfo> ();
            }
            return list;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public void setStateService(StateService stateService) {
        this.stateService = stateService;
    }

    public StateService getStateService() {
        if (stateService == null) {
            QName qname = new QName(StateServiceConstants.NAMESPACE, StateServiceConstants.SERVICE_NAME_LOCAL_PART);
            stateService = (StateService) GlobalResourceLoader.getService(qname);
        }
        return this.stateService;
    }

    private ContextInfo getContextInfo() {
        return ContextBuilder.loadContextInfo();
    }
}
