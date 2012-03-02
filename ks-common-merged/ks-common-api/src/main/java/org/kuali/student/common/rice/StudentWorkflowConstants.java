package org.kuali.student.common.rice;

//TODO: This class needs to be combined with org.kuali.student.StudentWorkflowConstants class found in ks-lum-rice
/**
 * 
 * @author NWUuser
 * Was moved back from ks-common-api after the merge of enroll>common-api
 */
public class StudentWorkflowConstants {
	
	//FIXME: The workflow doc type needs to be removed from ProposalWorkflowFilter
	public static final String WORKFLOW_DOCUMENT_TYPE = "ProposalWorkflowFilter.DocumentType";

	public static final String DEFAULT_WORKFLOW_DOCUMENT_START_NODE_NAME = "PreRoute";

	public static final String ROLE_NAME_ADHOC_EDIT_PERMISSIONS_ROLE_NAMESPACE = "KS-SYS";
	public static final String ROLE_NAME_ADHOC_EDIT_PERMISSIONS_ROLE_NAME = "Adhoc Permissions: Edit Document";
	public static final String ROLE_NAME_ADHOC_ADD_COMMENT_PERMISSIONS_ROLE_NAMESPACE = "KS-SYS";
	public static final String ROLE_NAME_ADHOC_ADD_COMMENT_PERMISSIONS_ROLE_NAME = "Adhoc Permissions: Comment on Document";
	
	public enum ActionRequestEnum {
		COMPLETE("C", "Complete"),
		APPROVE("A", "Approve"), 
		ACKNOWLEDGE("K", "Acknowledge"), 
		FYI("F", "FYI");

		private String actionRequestCode;
		private String actionRequestLabel;

		private ActionRequestEnum(String actionRequestCode, String actionRequestLabel) {
			this.actionRequestCode = actionRequestCode;
			this.actionRequestLabel = actionRequestLabel;
		}

		public String getActionRequestCode() {
        	return actionRequestCode;
        }

		public void setActionRequestCode(String actionRequestCode) {
        	this.actionRequestCode = actionRequestCode;
        }

		public String getActionRequestLabel() {
        	return actionRequestLabel;
        }

		public void setActionRequestLabel(String actionRequestLabel) {
        	this.actionRequestLabel = actionRequestLabel;
        }

		public static ActionRequestEnum getByCode(String actionRequestCode) {
			for (ActionRequestEnum type : ActionRequestEnum.values()) {
				if (type.getActionRequestCode().equals(actionRequestCode)) {
					return type;
				}
			}
			return null;
		}
	}
	
}
