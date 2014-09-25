/**
 * Copyright 2014 The Kuali Foundation Licensed under the
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
 * Created by pauldanielrichardson on 9/24/14
 */
package org.kuali.student.enrollment.class2.courseoffering.krms.termresolver.util;

import org.joda.time.DateTime;
import org.kuali.student.enrollment.registration.engine.util.PerformanceUtil;

import java.util.List;
import java.util.Map;

/**
 * This class records the performance of individual term resolvers
 *
 * @author Kuali Student Team
 */
public class TermResolverPerformanceUtil {
    private TermResolverPerformanceUtil() {}

    private static final PerformanceUtil performanceUtil = new PerformanceUtil();

    public static void putStatistics(String termResolver, DateTime start, DateTime end) {
        performanceUtil.putStatistics(termResolver, start, end);
    }

    public static Map<String, List<String>> getStatistics() {
        return performanceUtil.getStatistics();
    }

    public static void clearStatistics() {
        performanceUtil.clearStatistics();
    }

}
