package org.kuali.student.sqlOrganizer;

import com.akiban.sql.*;
import com.akiban.sql.parser.*;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.kuali.common.jdbc.reader.DefaultSqlReader;
import org.kuali.common.jdbc.reader.SqlReader;
import org.kuali.common.jdbc.reader.model.Comments;
import org.kuali.common.jdbc.reader.model.Delimiter;
import org.kuali.common.jdbc.reader.model.LineSeparator;
import org.kuali.common.util.LocationUtils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created with IntelliJ IDEA.
 * User: lsymms
 * Date: 12/30/13
 * Time: 2:42 PM
 * To change this template use File | Settings | File Templates.
 */
public class SqlOrganizer {

    public String subProject;
    public String module;
    // file, list of unparsable statements
    public Map<String,List<String>> unparsableStmts;
    private String projectPath;
    private String outputDirPath;
    private Map<DatabaseDataType, Set<String>> dataTypeTableSets;

    private static final Pattern CREATE_SEQ_PATTERN = Pattern.compile("\\s*(create|CREATE)\\s*(sequence|SEQUENCE)\\s*(\\w*)");
    private static final Pattern DROP_SEQ_PATTERN = Pattern.compile("\\s*(drop|DROP)\\s*(sequence|SEQUENCE)\\s*(\\w*)");
    private static final Pattern NDX_RENAME_PATTERN = Pattern.compile("\\s*(alter|ALTER)\\s*(index|INDEX)\\s*(\\w*)\\s*(rename|RENAME)\\s*(to|TO)\\s*(\\w*)");
    private static final Pattern CNSTRT_RENAME_PATTERN = Pattern.compile("\\s*(alter|ALTER)\\s*(table|TABLE)\\s*(\\w*)\\s*(rename|RENAME)\\s*(constraint|CONSTRAINT)\\s*(\\w*)\\s*(to|TO)\\s*(\\w*)");
    private static final Pattern ALTER_TABLE_PATTERN = Pattern.compile("\\s*(alter|ALTER)\\s*(table|TABLE)\\s*(\\w*)\\s*(modify|MODIFY|add|ADD)\\s*\\(");
    private static final Pattern CREATE_TABLE_PATTERN = Pattern.compile("\\s*(create|CREATE)\\s*(table|TABLE)\\s*(\\w*)");
    private static final Pattern COMPLEX_DROP_TABLE_PATTERN = Pattern.compile("IF\\s*TEMP\\s*>\\s*0\\s*THEN\\s*EXECUTE\\s*IMMEDIATE\\s*'DROP\\s*TABLE\\s*(\\w*)\\s*CASCADE\\s*CONSTRAINTS\\s*PURGE'");
    private static final Pattern TRUNCATE_TABLE_PATTERN = Pattern.compile("^\\s*(delete|DELETE)\\s*\\s(?!from|FROM)\\s*(\\w*)\\s*$");

     public String[] splitStatements (String sqlStatements) {
        return sqlStatements.split("\n\\s*" + "/" + "\\s*" + "(\n|\\Z)");
    }

    // TODO: convert to config
    public void init(Map<DatabaseDataType, Set<String>> dataTypeTableSets, String project_path, String output_dir_path) {
        this.unparsableStmts = new HashMap<String,List<String>>();
        this.setDataTypeTableSets(dataTypeTableSets);
        this.setOutputDirPath(output_dir_path);
        this.setProjectPath(project_path);

    }

    public void printSummary() {
        int count = 0;
        if (this.unparsableStmts.size() > 0) {
            System.out.println("\n\nUnparsable Statements");
            StringBuilder sbStmts = new StringBuilder();
            for (String file: this.unparsableStmts.keySet()) {
                sbStmts.append("---------- filename: " + file + " -------------\n");
                List<String> stmts = this.unparsableStmts.get(file);
                count += stmts.size();
                for (String stmt : stmts) {
                    sbStmts.append(stmt + "\n/\n");
                }
            }
            System.out.println(sbStmts);
            System.out.println("\nNumber of Files with parse errors: " + this.unparsableStmts.size());
            System.out.println("\nNumber of parse errors: " + count);
        }

    }

    // TODO: genericize these, move to configuration
    public void organizeAggregateFiles() throws IOException {
        File root = new File(outputDirPath);
        DirManipulationUtils.cascadeDelDir(root);
        DirManipulationUtils.mkDirCascaded(root);
        organizeRiceProcessFiles();
        organizeCoreProcessFiles();
        organizeLumProcessFiles();
        organizeAPProcessFiles();
        organizeEnrollProcessFiles();
    }

    public void organizeEnrollProcessFiles() throws IOException {
        subProject = "ks-enroll";
        module = subProject + "-sql";
        organizeProcessFiles(projectPath);
    }

    public void organizeLumProcessFiles() throws IOException {
        subProject = "ks-lum";
        module = subProject + "-sql";
        organizeProcessFiles(projectPath);
    }

    public void organizeAPProcessFiles() throws IOException {
        subProject = "ks-ap";
        module = subProject + "-sql";
        organizeProcessFiles(projectPath);
    }

    public void organizeCoreProcessFiles() throws IOException {
        subProject = "ks-core";
        module = subProject + "-sql";
        organizeProcessFiles(projectPath);
    }

    public void organizeRiceProcessFiles() throws IOException {
        subProject = "ks-core";
        module = "ks-rice-sql";
        organizeProcessFiles(projectPath);
    }

    private void organizeProcessFiles(String projectPath) throws IOException {
        String modulePath = projectPath + "\\" + subProject + "\\" + module;
        // TODO: move to configuration
        String resourceListingFile =  modulePath + "\\target\\classes\\META-INF\\org\\kuali\\student\\" + module + "\\oracle\\other.resources";

        System.out.println("reading file list from " + resourceListingFile);
        BufferedReader br = new BufferedReader(new FileReader(resourceListingFile));
        String sqlFile;
        while ((sqlFile = br.readLine()) != null) {
            // use contents of resource file to get list of file names
            sqlFile = sqlFile.replace("classpath:", modulePath + "\\src\\main\\resources\\");
            processSqlFile(sqlFile);
        }
        br.close();
    }

    public void processSqlFile(String sqlFile) {
        try {
            processSqlStatements(sqlFile);
        } catch (IOException e) {
            System.out.println ("**************************************\n" +
                    "*         ERROR READING FILE         *\n" +
                    "**************************************\n" +
                    "\n");
            e.printStackTrace();

        }
    }

    public static String extractMilestone(String filePathName) {
        int lastSlashPos = filePathName.lastIndexOf('\\');
        boolean windowsPath = true;

        if (lastSlashPos == -1) {
            windowsPath = false;
            lastSlashPos = filePathName.lastIndexOf('/');
        }

        if (lastSlashPos != -1) {
            String trimmedFilePath = filePathName.substring(0,lastSlashPos);
            int prevSlashPos = 0;
            if (windowsPath) {
                prevSlashPos = trimmedFilePath.lastIndexOf('\\');
            } else {
                prevSlashPos = trimmedFilePath.lastIndexOf('/');
            }

            if (lastSlashPos <= 0 || prevSlashPos <= 0) {
                return "NO_MILESTONE_IN_PATH";
            } else {
                return filePathName.substring(prevSlashPos+1,lastSlashPos);
            }
        } else {
            return "Unknown_Milestone";
        }
    }

    public SqlReader getSqlReader(){
        return new DefaultSqlReader(Delimiter.DEFAULT_DELIMITER, LineSeparator.DEFAULT_VALUE, DefaultSqlReader.DEFAULT_TRIM, new Comments(false));
    }


    // excepts fully qualified paths only at this time
    private void processSqlStatements(String sqlFile) throws IOException {
        String filename = DirManipulationUtils.extractFileName(sqlFile);
        String milestone = extractMilestone(sqlFile);
        Map<DatabaseModule, List<String>> locationMap = new HashMap<DatabaseModule, List<String>>();
        SqlReader sqlReader = getSqlReader();
        BufferedReader reader = LocationUtils.getBufferedReader(sqlFile);
        // based on project i.e. ks-enroll-sql
        DatabaseModule defaultModule = getDatabaseModule();
        StringBuilder fileReport = new StringBuilder();
        boolean printedHeader = false;

        Map<DatabaseDataType, Map<DatabaseModule,StringBuilder>> statementBuckets = initBuckets();

        fileReport.append("\n" +
                "parsing file: " + filename + "\n" +
                "encoded: {" + InsecureStringEncoder.encode(filename) + "}\n");

        String statement = sqlReader.getSql(reader);
        String firstStatement = statement;

        if (ControlMappingUtils.skipSqlOrganization(firstStatement)) {
            System.out.print(fileReport.toString());

            TypeMapping typeMapping = new TypeMapping();
            ControlMappingValidationStatus status = ControlMappingUtils.setControlDataType(firstStatement, filename, typeMapping);
            if (status == ControlMappingValidationStatus.VALID) {
                System.out.println("file control comment found.  Moving file to " + typeMapping.getType().toString());
                copyFile(sqlFile, milestone, typeMapping.getType(), getDatabaseModule(), filename);
            } else {
                System.out.println("error processing control comment: " + status.toString());
                File newFile = copyFile(sqlFile, milestone, DatabaseDataType.EXCEPTION, getDatabaseModule(), filename);
                FileWriter f = new FileWriter(newFile, true);
                f.write(status.toString());
                f.close();
            }
        } else {
            int i;
            for (i=0; statement != null; statement = sqlReader.getSql(reader)) {
                i++;
                boolean wrongModule = false;
                String cleanStmt = cleanStmt(statement);

                StatementInfo statementInfo = getStatementInfoForStatement(filename, cleanStmt);

                DatabaseDataType dataType = getDataType(statementInfo);
                DatabaseModule module = getModule(statementInfo.getTableNames(), defaultModule);
                statementBuckets.get(dataType).get(module).append(statement + "\n/\n");

            }
            fileReport.append("num of statements in file: " + i + "\n");

            //write the additional files
            List<String> descriptors = splitFile(statementBuckets, milestone, filename);

            fileReport.append("Type:Module mappings: ");
            for (String descriptor : descriptors) {
                fileReport.append(descriptor.toString() + " ");
            }
            fileReport.append("\n");
            System.out.print(fileReport.toString());
            printedHeader = true;
        }
        if (printedHeader) {
            System.out.println("");
        }

    }

    private File copyFile(String origFile, String milestone, DatabaseDataType type, DatabaseModule module, String filename) throws IOException {
        File newFile = new File(outputDirPath + milestone + "//" + type.toString() + "//" + module.getEndsWith() + "//" + filename);
        File parent = newFile.getParentFile();
        DirManipulationUtils.mkDirCascaded(parent);
        FileUtils.copyFile(new File(origFile), newFile);
        return newFile;

    }


    // returns list of strings that describes which files were created
    private List<String> splitFile(Map<DatabaseDataType, Map<DatabaseModule, StringBuilder>> statementBuckets, String milestone,String filename) {
        List<String> fileDescriptors = new ArrayList<String>();
        Set<Map.Entry<DatabaseDataType,Map<DatabaseModule,StringBuilder>>> typeEntries = statementBuckets.entrySet();
        for (Map.Entry<DatabaseDataType, Map<DatabaseModule, StringBuilder>> typeEntry : typeEntries) {
            Set<Map.Entry<DatabaseModule,StringBuilder>> moduleEntries = typeEntry.getValue().entrySet();
            for (Map.Entry<DatabaseModule, StringBuilder> moduleEntry : moduleEntries) {
                if (moduleEntry.getValue().length() > 0) {
                    writeToFile(milestone, typeEntry.getKey(), moduleEntry.getKey(), filename, moduleEntry.getValue().toString());
                    fileDescriptors.add(typeEntry.getKey().toString() + ":" + moduleEntry.getKey().toString());
                }
            }
        }
        return fileDescriptors;
    }




    public DatabaseModule getModule(List<String> tableNames, DatabaseModule defaultModule) {
        DatabaseModule ret = null;
        Map<DatabaseModule, List> tableMap = new HashMap<DatabaseModule, List>();
        for (String table : tableNames) {
            addTableToModuleMap(tableMap, table);
        }

        Set<Map.Entry<DatabaseModule,List>> entries = tableMap.entrySet();
        if (entries.size() == 1) {
            Map.Entry<DatabaseModule,List> entry = entries.iterator().next();
            if (entry.getKey() != defaultModule) {
                if (entry.getKey() == DatabaseModule.EXCEPTION) {
                    List<String> tables = entry.getValue();
                    ret = DatabaseModule.EXCEPTION;
                } else {
                    //System.out.println("Stmt moving to: " + entry.getKey().getEndsWith());
                    ret = entry.getKey();
                }
            }
        } else if (entries.size() == 0) {
            //System.out.println("No module references found");
        } else {
            System.out.println("Stmt contains more than one module reference: " + tableNames.toString());
            ret = DatabaseModule.EXCEPTION;
        }

        if (ret == null) {
            ret = defaultModule;
        }
        return ret;
    }

    private Map<DatabaseDataType, Map<DatabaseModule, StringBuilder>> initBuckets() {
        Map statementBuckets = new HashMap<DatabaseDataType, Map<DatabaseModule,StringBuilder>>();

        for (DatabaseDataType dataTypeIter : DatabaseDataType.values()) {
            Map moduleBuckets = new HashMap<DatabaseModule, StringBuilder>();
            for (DatabaseModule moduleIter : DatabaseModule.values()) {
                moduleBuckets.put(moduleIter, new StringBuilder());
            }
            statementBuckets.put(dataTypeIter, moduleBuckets);
        }
        return statementBuckets;
    }


    private DatabaseModule getDatabaseModule() {
        for (DatabaseModule moduleIter : DatabaseModule.values()) {
            if (module.endsWith(moduleIter.getEndsWith())) {
                return moduleIter;
            }
        }
        return null;
    }

    private void writeToFile(String milestone, DatabaseDataType type, DatabaseModule module, String filename, String content) {

        try {
            File file = new File(outputDirPath + milestone + "\\" + type.toString() + "\\" + module.getEndsWith() + "\\" + filename);
            File parent = file.getParentFile();

            if (!parent.exists()) {
                DirManipulationUtils.mkDirCascaded(parent);
            }

            // if file doesnt exists, then create it
            if (!file.exists()) {
                file.createNewFile();
            }

            FileWriter fw = new FileWriter(file.getAbsoluteFile());
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write(content);
            bw.close();

            //System.out.println("Done writing to file ..\\" + type.toString() + "\\" + module.getEndsWith() + "\\" + filename);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }



    private String cleanStmt(String statement) {
        String cleanStmt;
        BufferedReader reader = new BufferedReader(new StringReader(statement));
        String stmtLine;
        StringBuilder sb = new StringBuilder();

        try {
            while ((stmtLine = reader.readLine()) != null) {
                if (!stmtLine.startsWith("--")) {
                    sb.append(stmtLine + "\n");
                }
            }
        } catch (IOException e) {
            // should never happen
        }

        cleanStmt = sb.toString();

        cleanStmt = StringUtils.replaceEach(statement, new String[] {"VARCHAR2","varchar2", "Varchar2"}, new String[] {"VARCHAR", "varchar", "Varchar"});
        cleanStmt = StringUtils.replace(cleanStmt,"(+)", "");
        cleanStmt = cleanStmt.replaceAll("\\)\\s*(GROUP\\s*BY|group\\s*by)", ") alias GROUP_BY");
        return cleanStmt;
    }


    private boolean isCMTable(String table) {
        return (table.startsWith("KSLU") || table.startsWith("KSLO"));
    }

    private boolean isAPTable(String table) {
        return (table.startsWith("KSPL"));
    }

    private boolean isEnrTable(String table) {
        return table.startsWith("KSEN");
    }

    private boolean isRiceTable(String table) {
        return table.startsWith("KR");
    }

    private boolean isKSTable(String table) {
        return table.startsWith("KS");
    }


    private String getTableReport(Map<DatabaseModule, List> tableMap) {
        Set<Map.Entry<DatabaseModule,List>> entries = tableMap.entrySet();
        StringBuilder report = new StringBuilder();
        if (entries.size() == 1) {
            Map.Entry<DatabaseModule,List> entry = entries.iterator().next();
            if (entry.getKey() == getDatabaseModule()) {
                List<String> tables = entry.getValue();
                report.append ("statement contains tables that belong in another module. " + tables.toString() + "\n");
            }
        } else if (entries.size() == 0 ) {
            report.append ("No table found in statement");
        } else {
            report.append("ERROR statement contains multiple table modules." + "\n");
            for (Map.Entry<DatabaseModule,List> entry : entries) {
                List<String> tables = tableMap.get(entry.getKey());
                report.append(entry.getKey().getLabel() + " " + tables.toString() + "\n");
            }

        }

        return report.toString();
    }

    private void addTableToModuleMap(Map<DatabaseModule, List> tableReport, String table) {
        DatabaseModule category = getTableModule(table);


        List contents = tableReport.get(category);
        if (contents == null) {
            contents = new ArrayList<String>();
        }
        contents.add(table);
        tableReport.put(category,contents);
    }

    private DatabaseModule getTableModule(String table) {
        if (isRiceTable(table)) {
            return DatabaseModule.RICE;
        } else if (isCMTable(table)) {
            return DatabaseModule.KSCM;
        } else if (isEnrTable(table)) {
            return DatabaseModule.KSENR;
        } else if (isAPTable(table)) {
            return DatabaseModule.KSAP;
        } else if (isEnrTable(table)) {
            return DatabaseModule.KSENR;
        } else if (isKSTable(table)) {
            return DatabaseModule.KSCORE;
        } else {
            System.out.println("Unable to get module for table: " + table);
            return DatabaseModule.EXCEPTION;
        }


    }

    private DatabaseDataType getDataType(StatementInfo statementInfo) {
        if (statementInfo.getStatementType() == StatementType.DDL) {
            return DatabaseDataType.STRUCTURE;
        } else {
            List<String> tableNames = statementInfo.getTableNames();
            Map<DatabaseDataType, Boolean> tableMap = new HashMap<DatabaseDataType, Boolean>();
            for (String table : tableNames) {
                addTableToTypeMap(tableMap, table);
            }
            if (tableMap.get(DatabaseDataType.MANUAL) != null) {
                return DatabaseDataType.MANUAL;
            } else if (tableMap.get(DatabaseDataType.REFERENCE) != null) {
                return DatabaseDataType.REFERENCE;
            } else if (tableMap.get(DatabaseDataType.BOOTSTRAP) != null) {
                return DatabaseDataType.BOOTSTRAP;
            }
            return DatabaseDataType.EXCEPTION;
        }
    }

    private void addTableToTypeMap(Map<DatabaseDataType, Boolean> tableMap, String table) {
        DatabaseDataType category = getTableDataType(table);
        tableMap.put(category,true);
    }

    private DatabaseDataType getTableDataType(String table) {
        Set<Map.Entry<DatabaseDataType,Set<String>>> entries = dataTypeTableSets.entrySet();
        for (Map.Entry<DatabaseDataType,Set<String>> entry : entries) {
            if (entry.getValue().contains(table)) {
                return entry.getKey();
            }
        }
        return DatabaseDataType.EXCEPTION;
    }


    public StatementInfo getStatementInfoForStatement(String filename, String statement){
        StatementType statementType = null;
        List<String> tableNames = null;
        SQLParser parser = new SQLParser();
        SqlParserNodeVisitor nodeVisitor = new SqlParserNodeVisitor();
        try {
            StatementNode stmt = parser.parseStatement(statement);
            nodeVisitor.traverse(stmt);
            tableNames = nodeVisitor.getTableNames();
            statementType = nodeVisitor.getStatementType();
            // sql parser had an issue so run attempt to handle some common scenarios.  the groups are based on the regex
        } catch (StandardException e) {
            tableNames = new ArrayList<String>();
            Matcher matcher = CNSTRT_RENAME_PATTERN.matcher(statement);
            if (matcher.find()) {
                statementType = StatementType.DDL;
                tableNames.add(matcher.group(3));
                tableNames.add(matcher.group(6));
                tableNames.add(matcher.group(8));
            } else {
                matcher = NDX_RENAME_PATTERN.matcher(statement);
                if (matcher.find()){
                    statementType = StatementType.DDL;
                    tableNames.add(matcher.group(3));
                    tableNames.add(matcher.group(6));
                } else {
                    matcher = CREATE_SEQ_PATTERN.matcher(statement);
                    if (matcher.find()) {
                        statementType = StatementType.DDL;
                        tableNames.add(matcher.group(3));
                    } else {
                        matcher = DROP_SEQ_PATTERN.matcher(statement);
                        if (matcher.find()) {
                            statementType = StatementType.DDL;
                            tableNames.add(matcher.group(3));
                        } else {
                            matcher = CREATE_TABLE_PATTERN.matcher(statement);
                            if (matcher.find()) {
                                statementType = StatementType.DDL;
                                tableNames.add(matcher.group(3));
                            } else {
                                matcher = COMPLEX_DROP_TABLE_PATTERN.matcher(statement);
                                if (matcher.find()) {
                                    statementType = StatementType.DDL;
                                    tableNames.add(matcher.group(1));
                                } else {
                                    matcher = ALTER_TABLE_PATTERN.matcher(statement);
                                    if (matcher.find()) {
                                        statementType = StatementType.DDL;
                                        tableNames.add(matcher.group(3));
                                    }  else {
                                        matcher = TRUNCATE_TABLE_PATTERN.matcher(statement);
                                        if (matcher.find()) {
                                            statementType = StatementType.DDL;
                                            tableNames.add(matcher.group(2));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (tableNames.size() > 0) {
                //addUnparsableStmt(filename, "-- " + tableNames.toString() + "\n" + statement);
                //System.out.println("found non-ansi statement: " + statement + "\nusing objects:" + tableNames );
            } else {
                System.out.println("Error parsing statement: " + statement);
                addUnparsableStmt(filename, statement);
                tableNames.add("EXCEPTION");
                //System.out.println(e);  //To change body of catch statement use File | Settings | File Templates.
            }
        }

        StatementInfo statementInfo = new StatementInfo(tableNames, statementType);
        return statementInfo;
    }

    private void addUnparsableStmt(String filename, String statement) {
        List<String> stmts;
        if(!this.unparsableStmts.containsKey(filename)) {
            stmts = new ArrayList<String>();
        } else {
            stmts = this.unparsableStmts.get(filename);
        }
        stmts.add(statement);
        this.unparsableStmts.put(filename,stmts);
    }


    public void removeEmptyOutputDirs() {
        File root = new File(outputDirPath);
        DirManipulationUtils.delEmptyDirs(root);
    }


    public String getProjectPath() {
        return projectPath;
    }

    public void setProjectPath(String projectPath) {
        this.projectPath = projectPath;
    }

    public String getOutputDirPath() {
        return outputDirPath;
    }

    public void setOutputDirPath(String outputDirPath) {
        this.outputDirPath = outputDirPath;
    }

    public Map<DatabaseDataType, Set<String>> getDataTypeTableSets() {
        return dataTypeTableSets;
    }

    public void setDataTypeTableSets(Map<DatabaseDataType, Set<String>> dataTypeTableSets) {
        this.dataTypeTableSets = dataTypeTableSets;
    }




}
