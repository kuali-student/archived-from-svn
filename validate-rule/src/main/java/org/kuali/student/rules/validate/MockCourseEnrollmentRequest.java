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
package org.kuali.student.rules.validate;

import java.util.List;

/**
 * This is a description of what this class does - Kamal don't forget to fill this in. 
 * 
 * @author Kuali Student Team (kamal.kuali@gmail.com)
 *
 */
public class MockCourseEnrollmentRequest {

    private List<String> luiIds;

    private List<Number> learningResults;
    
    /**
     * @return the learningResults
     */
    public List<Number> getLearningResults() {
        return learningResults;
    }

    /**
     * @param learningResults the learningResults to set
     */
    public void setLearningResults(List<Number> learningResults) {
        this.learningResults = learningResults;
    }

    /**
     * @return the luiIds
     */
    public List<String> getLuiIds() {
        return luiIds;
    }

    /**
     * @param luiIds the luiIds to set
     */
    public void setLuiIds(List<String> luiIds) {
        this.luiIds = luiIds;
    }
    
    
}
