package org.kuali.spring.util;

import java.util.Properties;

public class PropertiesMergeContext {
	Properties currentProperties;
	Properties newProperties;
	boolean override;
	boolean sort;
	String source;

	public PropertiesMergeContext() {
		this(null, null, true, null, true);
	}

	public PropertiesMergeContext(Properties oldProperties, Properties newProperties, boolean override, String source,
			boolean sort) {
		super();
		this.currentProperties = oldProperties;
		this.newProperties = newProperties;
		this.override = override;
		this.source = source;
		this.sort = sort;
	}

	public Properties getCurrentProperties() {
		return currentProperties;
	}

	public void setCurrentProperties(Properties oldProperties) {
		this.currentProperties = oldProperties;
	}

	public Properties getNewProperties() {
		return newProperties;
	}

	public void setNewProperties(Properties newProperties) {
		this.newProperties = newProperties;
	}

	public boolean isOverride() {
		return override;
	}

	public void setOverride(boolean override) {
		this.override = override;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public boolean isSort() {
		return sort;
	}

	public void setSort(boolean sort) {
		this.sort = sort;
	}
}
