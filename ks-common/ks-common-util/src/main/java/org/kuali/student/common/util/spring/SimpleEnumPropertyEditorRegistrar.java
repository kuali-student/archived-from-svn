package org.kuali.student.common.util.spring;

import org.kuali.student.r1.common.dictionary.dto.DataType;
import org.springframework.beans.PropertyEditorRegistrar;
import org.springframework.beans.PropertyEditorRegistry;

/**
 * New class for custom editors needed by Spring 4
 */
public class SimpleEnumPropertyEditorRegistrar implements PropertyEditorRegistrar{

    @Override
    public void registerCustomEditors(PropertyEditorRegistry registry) {
        registry.registerCustomEditor(DataType.class, new SimpleEnumPropertyEditor(DataType.class));
    }
}
