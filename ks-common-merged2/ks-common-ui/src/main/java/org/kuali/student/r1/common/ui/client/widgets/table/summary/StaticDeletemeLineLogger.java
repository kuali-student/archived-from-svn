package org.kuali.student.r1.common.ui.client.widgets.table.summary;

import com.google.gwt.user.client.Window;

@Deprecated
public class StaticDeletemeLineLogger {
	private static String lastLog;
	public static void log(String line){
		lastLog = line;
	}
	public static void AlertLastLine(){
		Window.alert("Last Line was:"+lastLog);
	}
}
