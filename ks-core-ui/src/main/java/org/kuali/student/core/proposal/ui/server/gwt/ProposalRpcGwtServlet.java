/**
 * Copyright 2010 The Kuali Foundation Licensed under the
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
 */

package org.kuali.student.core.proposal.ui.server.gwt;

import org.kuali.student.common.ui.server.gwt.BaseRpcGwtServletAbstract;
import org.kuali.student.core.proposal.ui.client.service.ProposalRpcService;
import org.kuali.student.common.util.security.ContextUtils;
import org.kuali.student.r2.core.proposal.dto.ProposalInfo;
import org.kuali.student.r2.core.proposal.service.ProposalService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * For now this servlet just exposes the dictionary and search methods of the Proposal Service 
 * 
 * @author Kuali Student Team
 *
 */
public class ProposalRpcGwtServlet extends BaseRpcGwtServletAbstract<ProposalService> implements ProposalRpcService{

    private static final long serialVersionUID = 1L;

    private final static Logger LOGGER = LoggerFactory.getLogger(ProposalRpcGwtServlet.class);

    @Override
    public ProposalInfo getProposalByWorkflowId(String workflowId) throws Exception {
        try {
            return service.getProposalByWorkflowId(workflowId, ContextUtils.getContextInfo());
        } catch (Exception e) {
            LOGGER.error("Exception occurred", e);
            throw e;
        }
    }

}
