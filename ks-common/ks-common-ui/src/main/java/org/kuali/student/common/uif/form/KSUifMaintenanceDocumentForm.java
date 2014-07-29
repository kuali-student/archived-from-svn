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
 * Created by David Yin on 2/3/13
 */
package org.kuali.student.common.uif.form;

import org.kuali.rice.krad.util.GlobalVariables;
import org.kuali.rice.krad.web.form.MaintenanceDocumentForm;
import org.kuali.student.common.uif.util.GrowlIcon;
import org.kuali.student.common.uif.util.KSGrowlMessenger;
import org.kuali.student.common.uif.util.KSUifUtils;
import org.kuali.student.common.uif.util.Messenger;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * This class provides base functionality for KS Maintenance Document forms
 *
 * @author Kuali Student Team
 */
public class KSUifMaintenanceDocumentForm extends MaintenanceDocumentForm {

    @Override
    public void postBind(HttpServletRequest request) {

        Messenger messenger = (Messenger) GlobalVariables.getUserSession().retrieveObject(KSGrowlMessenger.MESSENGER_KEY);
        if (messenger!=null){
            messenger.publishMessages();
        }

        super.postBind(request);
    }

}