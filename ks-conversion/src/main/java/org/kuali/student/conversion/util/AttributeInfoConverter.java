package org.kuali.student.conversion.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dozer.DozerConverter;
import org.dozer.Mapper;
import org.dozer.MapperAware;
import org.kuali.student.r2.common.dto.AttributeInfo;

public class AttributeInfoConverter extends DozerConverter<Map, List> {

    public AttributeInfoConverter() {
        super(Map.class, List.class);
    }
    
    @Override
    public List convertTo(Map source, List destination) {
        List<AttributeInfo> convertedList = new ArrayList<AttributeInfo>();
        for (Object key : source.keySet()) {
            String srcKey = (String)key;
            AttributeInfo attrInfo = new AttributeInfo();
            attrInfo.setKey(srcKey);
            attrInfo.setValue((String)source.get(srcKey));
            convertedList.add(attrInfo);
        }
        return convertedList;
    }

    @Override
    public Map convertFrom(List source, Map destination) {
        Map<String, String> convertedMap = new HashMap<String, String>();
        for (Object object : source) {
            AttributeInfo attrInfo = (AttributeInfo)object;
            convertedMap.put(attrInfo.getKey(), attrInfo.getValue());
        }
        return convertedMap;
    }
    
}