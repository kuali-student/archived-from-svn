/**
 * Copyright 2012 The Kuali Foundation Licensed under the
 * Educational Community License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may
 * obtain a copy of the License at
 *
 * http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 *
 * Created by Daniel on 3/30/12
 */
package org.kuali.student.enrollment.class2.appointment.service.impl;

import org.kuali.rice.core.api.criteria.Predicate;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.rice.core.api.resourceloader.GlobalResourceLoader;
import org.kuali.rice.krad.lookup.LookupableImpl;
import org.kuali.rice.krad.web.form.LookupForm;
import org.kuali.student.enrollment.class2.appointment.dto.StudentGroupWrapper;
import org.kuali.student.r2.common.constants.CommonServiceConstants;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.core.population.dto.PopulationInfo;
import org.kuali.student.r2.core.population.service.PopulationService;

import javax.xml.namespace.QName;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.kuali.rice.core.api.criteria.PredicateFactory.and;
import static org.kuali.rice.core.api.criteria.PredicateFactory.like;

/**
 * This class //TODO ...
 *
 * @author Kuali Student Team
 */
public class StudentGroupWrapperLookupableImpl extends LookupableImpl {
    private transient PopulationService populationService;
    @Override
    protected List<?> getSearchResults(LookupForm lookupForm, Map<String, String> fieldValues, boolean unbounded) {
        List<StudentGroupWrapper> results = new ArrayList<StudentGroupWrapper>();
        ContextInfo context = new ContextInfo();
        QueryByCriteria.Builder qBuilder = QueryByCriteria.Builder.create();
        List<Predicate> pList = new ArrayList<Predicate>();
        Predicate p;

        qBuilder.setPredicates();
        for(String key : fieldValues.keySet()){
            if(key.equalsIgnoreCase("name")){
                Predicate grpName = like(key,fieldValues.get(key));
                pList.add(grpName);
            } else{
                Predicate words = like(key,fieldValues.get(key));
                pList.add(words);
            }
        }
        if (!pList.isEmpty()){
            Predicate[] preds = new Predicate[pList.size()];
            pList.toArray(preds);
            qBuilder.setPredicates(and(preds));
        }

        try {
            java.util.List<PopulationInfo> populationInfos = getPopulationService().searchForPopulations(qBuilder.build(), context);
            if(populationInfos.isEmpty()){
                int i = 1;
                for(PopulationInfo populationInfo:populationInfos){
                    StudentGroupWrapper studentGroupWrapper = new StudentGroupWrapper();
                    studentGroupWrapper.setId("id" + i); i++;
                    studentGroupWrapper.setName(populationInfo.getName());
                    studentGroupWrapper.setDescription(populationInfo.getDescr().getPlain());
                    results.add(studentGroupWrapper);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        return results;
    }

    protected PopulationService getPopulationService() {
        if(populationService == null) {
            populationService = (PopulationService) GlobalResourceLoader.getService(new QName(CommonServiceConstants.REF_OBJECT_URI_GLOBAL_PREFIX+"population", "PopulationService"));

        }
        return populationService;
    }

    public static void main(String[] args){
        StudentGroupWrapperLookupableImpl studentWrapper = new StudentGroupWrapperLookupableImpl();
        studentWrapper.getPopulationService();

    }
}
