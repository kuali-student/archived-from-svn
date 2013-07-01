/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.ui.admin.type;

import java.util.Map;
import javax.xml.namespace.QName;
import org.apache.log4j.Logger;
import org.kuali.rice.core.api.resourceloader.GlobalResourceLoader;
import org.kuali.rice.krad.maintenance.MaintainableImpl;
import org.kuali.rice.krad.maintenance.MaintenanceDocument;
import org.kuali.rice.krad.util.KRADConstants;
import org.kuali.student.common.util.ContextBuilder;
import org.kuali.student.enrollment.class2.courseoffering.dto.CourseOfferingEditWrapper;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;
import org.kuali.student.r2.core.class1.type.service.TypeService;
import org.kuali.student.r2.core.constants.TypeServiceConstants;

/**
 *
 * @author nwright
 */
public class TypeInfoMaintainableImpl extends MaintainableImpl {

    private static final Logger LOG = Logger.getLogger(TypeInfoAdminInquirableImpl.class);
    private transient TypeService typeService;
    private final static String PRIMARY_KEY = "key";

    @Override
    public TypeInfo retrieveObjectForEditOrCopy(MaintenanceDocument document, Map<String, String> dataObjectKeys) {
        String key = dataObjectKeys.get(PRIMARY_KEY);
        try {
            TypeInfo info = this.getTypeService().getType(key, getContextInfo());
            return info;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    @Override
    public boolean isLockable() {
        return false;
    }

    @Override
    public void saveDataObject() {
        TypeInfo info = (TypeInfo) this.getDataObject();
        if (getMaintenanceAction().equals(KRADConstants.MAINTENANCE_NEW_ACTION)) {
            // update
            try {
                TypeInfo created = this.getTypeService().createType(info.getKey(), info, getContextInfo());
                this.setDataObject(created);
                return;
            } catch (Exception ex) {
                throw new RuntimeException(ex);
            }
        }
        if (getMaintenanceAction().equals(KRADConstants.MAINTENANCE_EDIT_ACTION)) {
            // update
            try {
                TypeInfo updated = this.getTypeService().updateType(info.getKey(), info, getContextInfo());
                this.setDataObject(updated);
                return;
            } catch (Exception ex) {
                throw new RuntimeException(ex);
            }
        }
        throw new RuntimeException ("unsupported action " + getMaintenanceAction ());
    }

    @Override
    public void deleteDataObject() {
        TypeInfo info = (TypeInfo) this.getDataObject();
        try {
            StatusInfo status = this.getTypeService().deleteType(info.getKey(), getContextInfo());
            return;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public void setTypeService(TypeService typeService) {
        this.typeService = typeService;
    }

    public TypeService getTypeService() {
        if (typeService == null) {
            QName qname = new QName(TypeServiceConstants.NAMESPACE, TypeServiceConstants.SERVICE_NAME_LOCAL_PART);
            typeService = (TypeService) GlobalResourceLoader.getService(qname);
        }
        return this.typeService;
    }

    private ContextInfo getContextInfo() {
        return ContextBuilder.loadContextInfo();
    }
}
