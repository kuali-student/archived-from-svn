package org.kuali.spring.util;

import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PropertiesLoggerSupport {
	public static final String DEFAULT_MASK_EXPRESSION = ".*((?i)password).*";
	public static final String DEFAULT_MASKED_VALUE = "******";
	public static final boolean IS_DEFAULT_MASK_PROPERTY_VALUES = true;

	final Logger logger = LoggerFactory.getLogger(PropertiesLoggerSupport.class);
	// If true, strip \n and \r when logging values
	boolean flattenPropertyValues;
	// If true, mask values for keys that match the maskExpression
	boolean maskPropertyValues = IS_DEFAULT_MASK_PROPERTY_VALUES;
	// Matches any string containing "password" (case insensitive)
	String maskExpression = DEFAULT_MASK_EXPRESSION;
	String maskValue = DEFAULT_MASKED_VALUE;
	Pattern pattern;

	/**
	 * This setter has custom behavior
	 */
	public void setMaskExpression(String maskExpression) {
		this.maskExpression = maskExpression;
		this.pattern = Pattern.compile(maskExpression);
	}

	public String getLogEntry(String key, String value) {
		return key + "=" + getPropertyValue(key, value);
	}

	public String getLogEntry(Properties properties) {
		return getLogEntry(properties, null);
	}

	public String getLogEntry(Properties properties, String comment) {
		StringBuilder sb = new StringBuilder();
		if (!StringUtils.isEmpty(comment)) {
			sb.append(comment + "\n");
		}
		if (properties == null || properties.size() == 0) {
			sb.append("No properties to log\n");
			return sb.toString();
		}
		if (maskPropertyValues) {
			pattern = Pattern.compile(maskExpression);
		}
		Map<String, String> sortedProperties = new TreeMap<String, String>();
		for (String key : properties.stringPropertyNames()) {
			String value = properties.getProperty(key);
			sortedProperties.put(key, value);
		}
		for (Map.Entry<String, String> entry : sortedProperties.entrySet()) {
			sb.append(getLogEntry(entry.getKey(), entry.getValue()) + "\n");
		}
		return sb.toString();
	}

	public String getPropertyValue(String key, String value) {
		if (flattenPropertyValues) {
			value = value.replace("\n", " ");
			value = value.replace("\r", " ");
			value = value.trim();
		}
		if (!maskPropertyValues) {
			return value;
		}
		if (pattern == null) {
			pattern = Pattern.compile(maskExpression);
		}
		Matcher matcher = pattern.matcher(key);
		boolean match = matcher.matches();
		if (match) {
			return maskValue;
		} else {
			return value;
		}
	}

	public boolean isFlattenPropertyValues() {
		return flattenPropertyValues;
	}

	public void setFlattenPropertyValues(boolean flattenPropertyValues) {
		this.flattenPropertyValues = flattenPropertyValues;
	}

	public boolean isMaskPropertyValues() {
		return maskPropertyValues;
	}

	public void setMaskPropertyValues(boolean maskPropertyValues) {
		this.maskPropertyValues = maskPropertyValues;
	}

	public String getMaskExpression() {
		return maskExpression;
	}

	public String getMaskValue() {
		return maskValue;
	}

	public void setMaskValue(String maskValue) {
		this.maskValue = maskValue;
	}

	public Pattern getPattern() {
		return pattern;
	}

}
