package com.sigmasys.kuali.ksa.service;

import com.sigmasys.kuali.ksa.krad.controller.GeneralLedgerTypeControllerTest;
import com.sigmasys.kuali.ksa.krad.controller.SearchControllerTest;
import com.sigmasys.kuali.ksa.krad.controller.SettingsControllerTest;
import com.sigmasys.kuali.ksa.krad.controller.TemplateControllerTest;
import junit.framework.JUnit4TestAdapter;
import junit.framework.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;


/**
 * ServiceTestSuite is a test suite that runs all the declared service tests
 * <p/>
 *
 * @author Michael Ivanov
 */
@RunWith(Suite.class)
@Suite.SuiteClasses(value = {
        DatabaseUtilsTest.class,
        TransactionServiceTest.class,
        AuditableEntityServiceTest.class,
        AccountServiceTest.class,
        ActivityServiceTest.class,
        KimServiceTest.class,
        BrmServiceTest.class,
        InformationServiceTest.class,
        LanguageServiceTest.class,
        XliffParserTest.class,
        LocalizationServiceTest.class,
        LocalizationWebServiceTest.class,
        TransactionImportServiceTest.class,
        AccessControlServiceTest.class,
        ConfigServiceTest.class,
        UserPreferenceServiceTest.class,
        GeneralLedgerServiceTest.class,
        FeeManagementServiceTest.class,
        PaymentServiceTest.class,
        TransactionUtilsTest.class,
        TemplateControllerTest.class,
        GeneralLedgerTypeControllerTest.class,
        SettingsControllerTest.class,
        SearchControllerTest.class})
public class ServiceTestSuite extends AbstractServiceTest {

    public static final String TEST_KSA_CONTEXT = "/META-INF/test-context.xml";

    public static Test suite() {
        return new JUnit4TestAdapter(ServiceTestSuite.class);
    }

}