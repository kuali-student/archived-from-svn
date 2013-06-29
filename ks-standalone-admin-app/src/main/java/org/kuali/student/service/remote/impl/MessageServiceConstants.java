/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import org.kuali.student.r2.common.constants.CommonServiceConstants;

/**
 *
 * @author nwright
 */
public class MessageServiceConstants extends org.kuali.student.r2.common.util.constants.MessageServiceConstants {
    // add an s to match the namespace on the impl
    public static final String NAMESPACE = CommonServiceConstants.REF_OBJECT_URI_GLOBAL_PREFIX + "messages";
    public static final String SERVICE_NAME_LOCAL_PART = "MessageService";
    
}
