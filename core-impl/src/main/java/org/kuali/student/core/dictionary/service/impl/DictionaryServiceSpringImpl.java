package org.kuali.student.core.dictionary.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jws.WebService;

import org.kuali.student.core.dictionary.dto.ObjectStructure;
import org.kuali.student.core.dictionary.service.DictionaryService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

@WebService(endpointInterface = "org.kuali.student.core.dictionary.service.DictionaryService", serviceName = "DictionaryService", portName = "DictionaryService", targetNamespace = "http://org.kuali.student/core/dictonary")
public class DictionaryServiceSpringImpl implements DictionaryService {

	private String dictionaryContext;
	private Map<String, ObjectStructure> objectStructures;

	public DictionaryServiceSpringImpl() {
		super();
	}

	public DictionaryServiceSpringImpl(String dictionaryContext) {
		super();
		this.dictionaryContext = dictionaryContext;
		init();
	}


	@SuppressWarnings("unchecked")
	public void init() {
		ApplicationContext ac = new ClassPathXmlApplicationContext(dictionaryContext);

		Map<String, ObjectStructure> beansOfType = (Map<String, ObjectStructure>) ac.getBeansOfType(ObjectStructure.class);
		objectStructures = new HashMap<String, ObjectStructure>();
		for (ObjectStructure objStr : beansOfType.values())
			objectStructures.put(objStr.getObjectTypeKey(), objStr);
	}

	@Override
	public ObjectStructure getObjectStructure(String objectTypeKey) {
		return objectStructures.get(objectTypeKey);
	}

	@Override
	public List<String> getObjectTypes() {
		return new ArrayList<String>(objectStructures.keySet());
	}

	@Override
	public boolean validateObject(String objectTypeKey, String stateKey,
			String info) {
		// TODO ddean - THIS METHOD NEEDS JAVADOCS
		return false;
	}

	@Override
	public boolean validateStructureData(String objectTypeKey, String stateKey,
			String info) {
		// TODO ddean - THIS METHOD NEEDS JAVADOCS
		return false;
	}

	public String getDictionaryContext() {
		return dictionaryContext;
	}

	public void setDictionaryContext(String dictionaryContext) {
		this.dictionaryContext = dictionaryContext;
	}

}
