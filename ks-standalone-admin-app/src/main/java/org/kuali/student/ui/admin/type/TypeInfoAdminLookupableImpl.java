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
package org.kuali.student.ui.admin.type;

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
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;
import org.kuali.student.r2.core.class1.type.service.TypeService;
import org.kuali.student.r2.core.constants.TypeServiceConstants;

public class TypeInfoAdminLookupableImpl extends LookupableImpl {

    private static final Logger LOG = Logger.getLogger(TypeInfoAdminLookupableImpl.class);
    private transient TypeService typeService;

    @Override
    protected List<TypeInfo> getSearchResults(LookupForm lookupForm, Map<String, String> fieldValues, boolean unbounded) {   QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
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
            List<TypeInfo> list = this.getTypeService().searchForTypes(qBuilder.build(), getContextInfo());
            // TODO: fix the impl so it doesn't return null
            if (list == null) {
                return new ArrayList<TypeInfo> ();
            }
            return list;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public void setTypeService(TypeService typeService) {
        this.typeService = typeService;
    }

    public TypeService getTypeService() {
        if (typeService == null) {
            QName qname = new QName(TypeServiceConstants.NAMESPACE, TypeServiceConstants.SERVICE_NAME_LOCAL_PART);
            typeService = (TypeService) GlobalResourceLoader.getService(qname);
        }
        return this.typeService;
    }

    private ContextInfo getContextInfo() {
        return ContextBuilder.loadContextInfo();
    }
}
