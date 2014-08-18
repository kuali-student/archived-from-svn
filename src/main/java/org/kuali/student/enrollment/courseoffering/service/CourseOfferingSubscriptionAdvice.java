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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.aspectj.lang.ProceedingJoinPoint;

/**
 * @author Kuali Student Team
 */
public class CourseOfferingSubscriptionAdvice {

    private static Logger logger = LoggerFactory.getLogger(CourseOfferingSubscriptionAdvice.class);

    EnqueuerCallbackListener enqueuerCallbackListener;

    public Object fireCallbacks(ProceedingJoinPoint joinPoint) {
        try {
            Object result = joinPoint.proceed(); // go ahead and do your business

            Object[] args = joinPoint.getArgs();
            Object id = args[0];
            enqueuerCallbackListener.updateCallback(id.toString());
            return result;
        } catch (Throwable e) {
            throw new RuntimeException(e);
        }
    }

    public EnqueuerCallbackListener getEnqueuerCallbackListener() {
        return enqueuerCallbackListener;
    }

    public void setEnqueuerCallbackListener(EnqueuerCallbackListener enqueuerCallbackListener) {
        this.enqueuerCallbackListener = enqueuerCallbackListener;
    }
}
