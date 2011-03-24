package org.kuali.spring.util;

import org.springframework.util.StringValueResolver;

public class DefaultStringValueResolver implements StringValueResolver {
	PlaceholderReplacer replacer;
	PropertyResolver resolver;
	String nullValue;

	public DefaultStringValueResolver() {
		this(null, null, null);
	}

	public DefaultStringValueResolver(PlaceholderReplacer replacer, PropertyResolver resolver, String nullValue) {
		super();
		this.replacer = replacer;
		this.resolver = resolver;
		this.nullValue = nullValue;
	}

	@Override
	public String resolveStringValue(String strVal) {
		String value = replacer.replacePlaceholders(strVal, resolver);
		return value.equals(nullValue) ? null : value;
	}

	public PlaceholderReplacer getReplacer() {
		return replacer;
	}

	public void setReplacer(PlaceholderReplacer replacer) {
		this.replacer = replacer;
	}

	public PropertyResolver getResolver() {
		return resolver;
	}

	public void setResolver(PropertyResolver resolver) {
		this.resolver = resolver;
	}

	public String getNullValue() {
		return nullValue;
	}

	public void setNullValue(String nullValue) {
		this.nullValue = nullValue;
	}

}
