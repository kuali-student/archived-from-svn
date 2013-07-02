package org.kuali.student.sonar.database;

import org.junit.Before;
import org.junit.After;
import org.junit.Test;
import org.kuali.student.sonar.database.exception.MissingFieldException;
import org.kuali.student.sonar.database.plugin.DatabseIntegrityRulesRepository;
import org.kuali.student.sonar.database.plugin.ForeignKeyConstraint;
import org.kuali.student.sonar.database.utility.FKConstraintReport;
import org.kuali.student.sonar.database.utility.FKConstraintValidator;
import org.kuali.student.sonar.database.utility.FKGenerationUtil;
import org.sonar.api.resources.Resource;
import org.sonar.api.rules.Rule;
import org.sonar.api.rules.Violation;
import org.kuali.student.sonar.database.utility.ForeignKeyValidationContext;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import static org.junit.Assert.fail;

/**
 * Created with IntelliJ IDEA.
 * User: lsymms
 * Date: 5/17/13
 * Time: 12:08 AM
 *
 * Runs Database integrity checks by searching for unconstrained FK Relationships.
 * Finds Problems with the Mappings that are returned by the search.  It then attempts
 * to create the FK Constraint.  The addConstraint method will throw excetpions if
 * there are any issues which get handled here by adding to lists of Constraint
 * Issues.  At the end of the test the report is sent to System.out
 */
public class TestDatabaseIntegrityScript {

    private FKConstraintValidator validator;

    @Before
    public void init() throws SQLException {
        validator = new FKConstraintValidator();

        ForeignKeyValidationContext context = new ForeignKeyValidationContext();
        validator.setContext(context);
        context.setSkip(false);
        context.setQueryFileName("missing_FK_query.sql");
        context.setQueryFilePath("sql/");

        // attempt to load the driver class to ensure it is in the classpath
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Unable to find DB Driver Class", e);
        }

        // populate properties for creating connection to the database
        Properties props = new Properties();
        props.setProperty("user", "JDBCTEST");
        props.setProperty("password", "JDBCTEST");


        // create a connection to the database using JDBC and set it in the context
        context.setConnection(DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", props));
    }

    @Test
    public void testFKSQL() throws SQLException {

        FKConstraintReport report = validator.runFKSQL(Thread.currentThread().getContextClassLoader());

        System.out.println("\n****    Done Adding constraints and Detecting Orphaned Data    *****\n");

        System.out.println("\nReporting Issues\n");
        for (ForeignKeyConstraint constraint : report.getFieldMappingIssues()) {
            System.out.println("FIELD MAPPING ISSUE: Field does not exists (" +
                    constraint.foreignTable + "." +
                    constraint.foreignColumn + ")");
        }

        for (ForeignKeyConstraint constraint : report.getTableMappingIssues()) {
            System.out.println("TABLE MAPPING ISSUE: table " +
                    constraint.foreignTable +
                    " not found in constraint: " + constraint.toString());
        }

        for (ForeignKeyConstraint constraint : report.getColumnTypeIncompatabilityIssues()) {
            System.out.println("COLUMN TYPE INCOMPATIBILITY ISSUE: " +
                    constraint.toString());
        }

        for (ForeignKeyConstraint constraint : report.getOrphanedDataIssues()) {
            System.out.println("ORPHANED DATA FOR RELATIONSHIP: " +
                    constraint.toString());
        }

        for (ForeignKeyConstraint constraint : report.getOtherIssues()) {
            System.out.println("UNHANDLED CONSTRAINT MAPPING ISSUE: " +
                    constraint.toString() + " (see log for more details)");
        }

        System.out.println("\nSUMMARY");
        if (report.getFieldMappingIssues().size()>0) {
            System.out.println(report.getFieldMappingIssues().size() + " Field Mapping Issues");
        }
        if (report.getTableMappingIssues().size()>0) {
            System.out.println(report.getTableMappingIssues().size() + " Table Mapping Issues");
        }
        if (report.getColumnTypeIncompatabilityIssues().size()>0) {
            System.out.println(report.getColumnTypeIncompatabilityIssues().size() + " Column Type Issues");
        }
        if (report.getOrphanedDataIssues().size()>0) {
            System.out.println(report.getOrphanedDataIssues().size() + " Orphaned Data Issues");
        }
        if (report.getOtherIssues().size()>0) {
            System.out.println(report.getOtherIssues().size() + " Other Issues");
        }
    }

    @Test
    public void testCreateViolations() {
        ForeignKeyConstraint constraint = new ForeignKeyConstraint("localTable", "localColumn", "foreignTable", "foreignColumn", "Test Constraint");
        Violation violation = Violation.create(Rule.create(
                        DatabseIntegrityRulesRepository.REPOSITORY_KEY,
                        DatabseIntegrityRulesRepository.PARENT_KEY_MISSING_RULE_KEY,
                        "RuleTest"),
                (Resource)constraint);
        constraint = new ForeignKeyConstraint("localTable2", "localColumn2", "foreignTable2", "foreignColumn2", "Test Constraint2");
        Violation violation2 = Violation.create(Rule.create(
                DatabseIntegrityRulesRepository.REPOSITORY_KEY,
                DatabseIntegrityRulesRepository.FIELD_MAPPING_RULE_KEY,
                "RuleTest"),
                (Resource)constraint);
    }

    @After
    public void cleanup() throws MissingFieldException, SQLException {
        validator.revert();
    }

}