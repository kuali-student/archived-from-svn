package org.kuali.student.dbdiff;

import java.util.Arrays;
import java.util.List;

/**
 * Provides the String.format() format for a given SQL type.
 */
public enum SqlValueEncloser {
    SINGLE_QUOTE("'%s'",
            Arrays.asList(new String[]{"VARCHAR2", "VARCHAR", "CHAR"})),
    TIMESTAMP("TIMESTAMP '%s'",
            Arrays.asList(new String[]{"TIMESTAMP", "TIMESTAMP(6)"})),
    DATE("TO_DATE('%s', 'yyyy/mm/dd hh24:mi:ss')",
            Arrays.asList(new String[]{"DATE"})),
    NO_QUOTES("%s",
            Arrays.asList(new String[]{"NUMBER"}));

    private List<String> types;
    private String format;

    private SqlValueEncloser(String format, List<String> types) {
        this.format = format;
        this.types = types;
    }

    public static String findFormat(String sqlType) {
        for (SqlValueEncloser encloser: SqlValueEncloser.values()) {
            if (encloser.types.contains(sqlType)) {
                return encloser.format;
            }
        }
        return null;
    }
}
