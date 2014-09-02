package org.kuali.student.sqlOrganizer;

import org.junit.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: lsymms
 * Date: 1/9/14
 * Time: 1:43 PM
 * To change this template use File | Settings | File Templates.
 */
public class TestFullUpgradeScriptProcess {

    @Test
    public void testUpgradeProcess() throws IOException {
        SqlOrganizer sqlOrganizer = TestSqlOrganizer.getTestSqlOrganizer();
        sqlOrganizer.organizeAggregateFiles();

        List<String> milestones = new ArrayList<String>();
        milestones.add("06-FR2-M1");
        List<DatabaseDataType> dataTypes = new ArrayList<DatabaseDataType>();
        dataTypes.add(DatabaseDataType.STRUCTURE);
        dataTypes.add(DatabaseDataType.BOOTSTRAP);
        dataTypes.add(DatabaseDataType.MIGRATION);
        List<DatabaseModule> modules = new ArrayList<DatabaseModule>();
        modules.add(DatabaseModule.RICE);
        modules.add(DatabaseModule.KSCORE);
        modules.add(DatabaseModule.KSCM);
        modules.add(DatabaseModule.KSAP);
        modules.add(DatabaseModule.KSENR);
        String ouptupFileName = "FR1.to.FR2-M1.upgrade.script.sql";
        String organizedSqlPath = sqlOrganizer.getOutputDirPath();

        UpgradeCreationConfig config = new UpgradeCreationConfig(milestones, dataTypes, modules, ouptupFileName, organizedSqlPath);
        SqlUpgradeFileCreator.createSqlUpgradeFile(config);

    }
}
