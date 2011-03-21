package org.kuali.spring.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.config.BeanDefinitionVisitor;
import org.springframework.util.StringValueResolver;

public class ConfigurableBeanDefinitionVisitor extends BeanDefinitionVisitor {
	final Logger logger = LoggerFactory.getLogger(ConfigurableBeanDefinitionVisitor.class);

	StringValueResolver stringValueResolver;
	PropertiesLoggerSupport loggerSupport;

	@Override
	protected String resolveStringValue(String strVal) {
		if (this.stringValueResolver == null) {
			throw new IllegalStateException("No StringValueResolver specified");
		}
		String resolvedValue = this.stringValueResolver.resolveStringValue(strVal);
		boolean equal = strVal.equals(resolvedValue);
		if (!equal) {
			logger.info("Resolved " + strVal + "->" + loggerSupport.getPropertyValue(strVal, resolvedValue));
		}
		// Return original String if not modified.
		return (equal ? strVal : resolvedValue);
	}

	public StringValueResolver getStringValueResolver() {
		return stringValueResolver;
	}

	public void setStringValueResolver(StringValueResolver stringValueResolver) {
		this.stringValueResolver = stringValueResolver;
	}

	public PropertiesLoggerSupport getLoggerSupport() {
		return loggerSupport;
	}

	public void setLoggerSupport(PropertiesLoggerSupport loggerSupport) {
		this.loggerSupport = loggerSupport;
	}

}
