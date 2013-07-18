/**
 * Copyright 2013 The Kuali Foundation Licensed under the
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
 * Created by christoff on 2013/01/11
 */
package org.kuali.student.loader.rules;

/**
 * @author Christoff
 * Date: 2013/06/28
 */
public class TermTermParamInfo {

    private String termId;
    private String termParamId;

    public TermTermParamInfo(String termId, String termParamId) {
        this.termId = termId;
        this.termParamId = termParamId;
    }

    public String getTermId() {
        return termId;
    }


    public String getTermParamId() {
        return termParamId;
    }

}
