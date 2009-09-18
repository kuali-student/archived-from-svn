package org.kuali.student.common.ui.server.applicationstate.entity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.kuali.student.common.util.UUIDHelper;

@Entity
@Table(name = "KS_APP_STATE_T", 
       uniqueConstraints={@UniqueConstraint(columnNames={"APPLICATION_ID", "REFERENCE_KEY", "REFERENCE_TYPE", "USERID"})})
@NamedQueries( {
        @NamedQuery(name = "ApplicationState.getApplicationState", query = "SELECT appState FROM ApplicationState appState WHERE appState.applicationId =:applicationId AND appState.referenceKey =:referenceKey AND appState.referenceType =:referenceType"),
        @NamedQuery(name = "ApplicationState.getApplicationStateByAppRefUserId", query = "SELECT appState FROM ApplicationState appState WHERE appState.applicationId =:applicationId AND appState.referenceKey =:referenceKey AND appState.referenceType =:referenceType AND appState.userId =:userId"),
        @NamedQuery(name = "ApplicationState.getApplicationStateByAppId", query = "SELECT appState FROM ApplicationState appState WHERE appState.applicationId =:applicationId"),
        @NamedQuery(name = "ApplicationState.getApplicationStateByAppUserId", query = "SELECT appState FROM ApplicationState appState WHERE appState.applicationId =:applicationId AND appState.userId =:userId")
} )
public class ApplicationState {

	@Id
    @Column(name = "ID")
	private String id;
	
	@Column(name = "APPLICATION_ID", nullable=false)
	private String applicationId;

	@Column(name = "REFERENCE_KEY", nullable=false)
	private String referenceKey;

	@Column(name = "REFERENCE_TYPE", nullable=false)
	private String referenceType;

	@Column(name = "USERID", nullable=false)
	private String userId;

	@OneToMany(cascade = CascadeType.ALL)
	private List<KeyValuePair> keyValueList;
	
	/**
	 * AutoGenerate the Id
	 */
	@PrePersist
	public void prePersist() {
		this.id = UUIDHelper.genStringUUID(this.id);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public String getApplicationId() {
		return applicationId;
	}

	public void setApplicationId(String applicationId) {
		this.applicationId = applicationId;
	}
	
	public String getReferenceKey() {
		return referenceKey;
	}
	
	public void setReferenceKey(String referenceKey) {
		this.referenceKey = referenceKey;
	}
	
	public String getReferenceType() {
		return referenceType;
	}
	
	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}

	public List<KeyValuePair> getKeyValueList() {
		return keyValueList;
	}

	public void setKeyValueList(List<KeyValuePair> keyValueList) {
		this.keyValueList = keyValueList;
	}

	private Map<String, String> getMap(List<KeyValuePair> list) {
		Map<String, String> map = new HashMap<String, String>();
		for(KeyValuePair pair : list) {
			map.put(pair.getKey(), pair.getValue());
		}
		return map;
	}

	public Map<String, String> getApplicationStateMap() {
		return getMap(getKeyValueList());
	}
}
