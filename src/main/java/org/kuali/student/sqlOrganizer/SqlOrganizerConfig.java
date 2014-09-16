package org.kuali.student.sqlOrganizer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Created with IntelliJ IDEA.
 * User: lsymms
 * Date: 9/16/14
 * Time: 10:05 AM
 * To change this template use File | Settings | File Templates.
 */
public class SqlOrganizerConfig {
    public Map<DatabaseDataType, Set<String>> dataTypeTableSets;
    public Map<DatabaseDataType,Pattern> dataTypeTablePatterns;
    public String projectPath;
    public String outputDirPath;

    public SqlOrganizerConfig(Map<DatabaseDataType, Set<String>> dataTypeTableSets, Map<DatabaseDataType, Pattern> dataTypeTablePatterns, String projectPath, String outputDirPath) {
        this.dataTypeTableSets = dataTypeTableSets;
        this.dataTypeTablePatterns = dataTypeTablePatterns;
        this.projectPath = projectPath;
        this.outputDirPath = outputDirPath;
    }
}
