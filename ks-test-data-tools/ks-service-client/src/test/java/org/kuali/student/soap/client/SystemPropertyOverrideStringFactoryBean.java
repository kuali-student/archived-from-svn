/*
 * Copyright 2012 The Kuali Foundation
 *
 * Licensed under the the Educational Community License, Version 1.0
 * (the "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl1.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.soap.client;

import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.FactoryBean;

/**
 * A special string {@link FactoryBean} that accepts a default value but also defines a system-property key which can be used to override the link at runtime.
 * 
 * The typical usecase for this is that the application can be wired up for local development and then used for 
 * 
 * @author Kuali Student Team
 */
public class SystemPropertyOverrideStringFactoryBean implements FactoryBean<String>, BeanNameAware {

	private String defaultValue;
	
	private String systemPropertyKey;

	private String beanName;

	
	@Override
    public void setBeanName(String name) {
		this.beanName = name;
		
    }

	@Override
    public String getObject() throws Exception {
		
		if (systemPropertyKey == null)
			systemPropertyKey = beanName; // default to the bean name
		
		if (systemPropertyKey != null) {
			// 	return the property if it exists or the default value
			return System.getProperty(systemPropertyKey, defaultValue);
		}
		else
			return defaultValue;
    }

	@Override
    public Class<?> getObjectType() {
	    return String.class;
    }

	@Override
    public boolean isSingleton() {
	    return true;
    }

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public void setSystemPropertyKey(String systemPropertyKey) {
		this.systemPropertyKey = systemPropertyKey;
	}
	
	
	

}
