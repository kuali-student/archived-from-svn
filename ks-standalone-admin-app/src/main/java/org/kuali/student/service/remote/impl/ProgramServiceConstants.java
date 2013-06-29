/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import org.kuali.student.r2.common.constants.CommonServiceConstants;
import org.kuali.student.r2.lum.program.dto.MajorDisciplineInfo;

/**
 *
 * @author nwright
 */
public class ProgramServiceConstants {

    public static final String NAMESPACE = CommonServiceConstants.REF_OBJECT_URI_GLOBAL_PREFIX + "program";
    public static final String SERVICE_NAME_LOCAL_PART = "ProgramService";
    public static final String REF_OBJECT_URI_MAJOR_DISCIPLINE_URI = NAMESPACE + "/" + MajorDisciplineInfo.class.getSimpleName();
}
