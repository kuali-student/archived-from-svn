package org.kuali.student.loader.util;

import java.util.Date;

import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.LocaleInfo;

public class ContextInfoHelper {

	public ContextInfo getDefaultContextInfo() {
		  //Locale bLocale = new Locale.Builder().setLanguage("en").setRegion("US").build();
		  LocaleInfo localeInfo = new LocaleInfo();
		  localeInfo.setLocaleLanguage("en");
		  localeInfo.setLocaleRegion("US");
		  ContextInfo contextInfo = new ContextInfo();
		  contextInfo.setPrincipalId("admin");
		  contextInfo.setLocale(localeInfo);
		  contextInfo.setCurrentDate(new Date());
		  return contextInfo;
	}
	
	public ContextInfo getContextInfoByPrincipalId(String principalId){
		LocaleInfo localeInfo = new LocaleInfo();
		  localeInfo.setLocaleLanguage("en");
		  localeInfo.setLocaleRegion("US");
		  ContextInfo contextInfo = new ContextInfo();
		  contextInfo.setPrincipalId(principalId);
		  contextInfo.setLocale(localeInfo);
		  contextInfo.setCurrentDate(new Date());
		  return contextInfo;
	}
}
