package org.kuali.student.sonar.database.utility;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.kuali.student.sonar.database.exception.FKConstraintException;
import org.kuali.student.sonar.database.exception.FieldMappingException;
import org.kuali.student.sonar.database.exception.InvalidConstraintException;
import org.kuali.student.sonar.database.plugin.ForeignKeyConstraint;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FKConstraintValidator {
    private static final Logger LOG = LoggerFactory.getLogger(FKConstraintValidator.class);

    protected static final String OWNER_KEY = "owner";

    protected static final String CONSTRAINT_NAME_KEY = "constraint_name";

    protected ForeignKeyValidationContext context;

    public ForeignKeyValidationContext getContext() {
        return context;
    }

    public void setContext(ForeignKeyValidationContext context) {
        this.context = context;
    }

    public FKConstraintReport runFKSQL() throws SQLException, IOException {

    	StringBuilder sqlBuilder = new StringBuilder();
    	
    	sqlBuilder.append(context.getQueryFilePath());
    	sqlBuilder.append(context.getQueryFileName());
    	
    	String resource = sqlBuilder.toString();

    	String sql = IOUtils.toString(new FileInputStream(resource));
    	
        Statement stmt = null;
        ResultSet result = null;
        // unconstrained foreign key relationships
        ArrayList<ForeignKeyConstraint> newConstraintList = new ArrayList<ForeignKeyConstraint>();
        FKConstraintReport report = new FKConstraintReport();


        try {
            //creating PreparedStatement object to execute query
            stmt = context.getConnection().createStatement();
            result = stmt.executeQuery(sql);

            while (result.next()) {
                ForeignKeyConstraint constraint = new ForeignKeyConstraint(result);
                constraint.constraintName = FKGenerationUtil.getNextConstraintName();
                if (result.getString(OWNER_KEY) == null) {
                    report.addException(new FieldMappingException(constraint));
                } else if (result.getString(CONSTRAINT_NAME_KEY) == null) {
                    newConstraintList.add(constraint);
                }
            }

            LOG.debug("****    Done Compiling Field Mappings    ****");
        } catch (SQLException e) {
            throw new SQLException("error running missing FK sql. ", e);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (result != null) {
                result.close();
            }
        }

        LOG.debug("Adding constraints and detecting issues");
        for (ForeignKeyConstraint constraint : newConstraintList) {
            try {
                constraint.addFKConstraint(context.getConnection());
            } catch (FKConstraintException fkce) {
                report.addException(fkce);
            }
        }

        return report;
    }

    public void revert() throws InvalidConstraintException, SQLException {
        List<ForeignKeyConstraint> constraintList = null;
        try {
            constraintList = FKGenerationUtil.getGeneratedFKConstraints(context.getConnection());
        } catch (SQLException e) {
            LOG.error("error retrieving generated constraints: " + e.getErrorCode() + " " + e.getMessage(), e);
        }

        if(constraintList != null) {

            LOG.debug("\nDeleting " + constraintList.size() + " FK Constraints");

            for (ForeignKeyConstraint constraint : constraintList)  {
                constraint.deleteFKConstraint(context.getConnection());
            }
        }
    }

    public void closeConn() throws SQLException {
        if (context.getConnection() != null) {
            context.getConnection().close();
        }
    }

}
