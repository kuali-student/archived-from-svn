package org.kuali.student.lum.program.client.permissions;

import org.kuali.student.r1.common.ui.client.mvc.DataModel;

/**
 * @author Igor
 */
public interface IModelPermission {
    boolean check(DataModel dataModel);
}
