/**
 * Copyright 2014 The Kuali Foundation Licensed under the Educational Community License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 *
 */
package org.kuali.student.enrollment.courseoffering.service;

import javax.jms.Queue;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Kuali Student Team
 */
public class DequeuerCallbackListener {
    private Queue queue;
    private Set<CourseOfferingCallbackService> callbacks = new HashSet<CourseOfferingCallbackService>();

/*    public void init () {
        queue.registerAsListenerForEventType ("CO_UPDATE_ENVENT_TYPE");
    }
*/
}
