package org.kuali.spring.util;

import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValue;

public class PropertyValueVisitationEvent {
	MutablePropertyValues propertyValues;
	PropertyValue propertyValue;
	Object oldValue;
	Object newValue;

	public PropertyValueVisitationEvent() {
		this(null, null, null, null);
	}

	public PropertyValueVisitationEvent(MutablePropertyValues propertyValues, PropertyValue propertyValue) {
		this(propertyValues, propertyValue, null, null);
	}

	public PropertyValueVisitationEvent(MutablePropertyValues propertyValues, PropertyValue propertyValue,
			Object oldValue, Object newValue) {
		super();
		this.propertyValues = propertyValues;
		this.propertyValue = propertyValue;
		this.oldValue = oldValue;
		this.newValue = newValue;
	}

	public PropertyValue getPropertyValue() {
		return propertyValue;
	}

	public void setPropertyValue(PropertyValue propertyValue) {
		this.propertyValue = propertyValue;
	}

	public Object getOldValue() {
		return oldValue;
	}

	public void setOldValue(Object oldValue) {
		this.oldValue = oldValue;
	}

	public Object getNewValue() {
		return newValue;
	}

	public void setNewValue(Object newValue) {
		this.newValue = newValue;
	}

	public MutablePropertyValues getPropertyValues() {
		return propertyValues;
	}

	public void setPropertyValues(MutablePropertyValues propertyValues) {
		this.propertyValues = propertyValues;
	}

}
