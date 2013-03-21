/**
 * Copyright 2005-2012 The Kuali Foundation
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
package org.kuali.student.enrollment.class1.krms.tree.node;

import org.kuali.rice.krms.dto.PropositionEditor;
import org.kuali.rice.krms.tree.node.RuleEditorTreeNode;

/**
 * abstract data class for the rule tree {@link org.kuali.rice.core.api.util.tree.Node}s
 * 
 * @author Kuali Rice Team (rice.collab@kuali.org)
 *
 */
public class KSCompoundOpCodeNode extends RuleEditorTreeNode {

    private static final long serialVersionUID = -6069336457169968200L;

    // needed for inquiry view
    public KSCompoundOpCodeNode() {
    }

    public KSCompoundOpCodeNode(PropositionEditor proposition){
        super(proposition);
   }
}
