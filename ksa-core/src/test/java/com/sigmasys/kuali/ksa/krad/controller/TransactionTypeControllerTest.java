package com.sigmasys.kuali.ksa.krad.controller;


import com.sigmasys.kuali.ksa.krad.form.SettingsForm;
import com.sigmasys.kuali.ksa.krad.form.TransactionTypeForm;
import com.sigmasys.kuali.ksa.model.Currency;
import com.sigmasys.kuali.ksa.model.Rollup;
import com.sigmasys.kuali.ksa.model.TransactionType;
import com.sigmasys.kuali.ksa.service.AbstractServiceTest;
import com.sigmasys.kuali.ksa.service.AccountService;
import com.sigmasys.kuali.ksa.service.PersistenceService;
import com.sigmasys.kuali.ksa.service.ServiceTestSuite;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {ServiceTestSuite.TEST_KSA_CONTEXT})
@Transactional
public class TransactionTypeControllerTest extends AbstractServiceTest {


    @Autowired
    private TransactionTypeController transactionTypeController;

    @Autowired
    private AccountService accountService;

    @Autowired
    private PersistenceService persistenceService;

    private TransactionTypeForm form;

    private String userId = "admin";


    @Before
    public void setUpWithinTransaction() {

        // set up test data within the transaction
        accountService.getOrCreateAccount(userId);

        // Initializing request parameters
        MockHttpServletRequest request = getRequest();

        request.setParameter("userId", userId);

        // Initializing the form
        form = transactionTypeController.createInitialForm(request);
    }

    @Test
    public void getList() throws Exception {

        // Passing request parameters needed to perform get() method
        MockHttpServletRequest request = getRequest();

        request.setParameter("userId", userId);
        request.setParameter("pageId", "TransactionTypePage");

        List<TransactionType> types = persistenceService.getEntities(TransactionType.class);

        ModelAndView modelAndView = transactionTypeController.get(form, request);

        // Checking assertions
        Assert.notNull(modelAndView);
        Assert.notNull(form);

        Assert.notNull(form.getTransactionTypes());
        Assert.isTrue(form.getTransactionTypes().size() == types.size());
        Assert.isTrue(form.getTransactionTypes().size() > 0);
    }

/*
    @Test
    public void getCurrencyDetail() throws Exception {

        // Passing request parameters needed to perform get() method
        MockHttpServletRequest request = getRequest();

        request.setParameter("userId", userId);
        request.setParameter("pageId", "CurrencyDetailsPage");
        request.setParameter("entityId", "1");

        ModelAndView modelAndView = settingsController.get(form, request);

        // Checking assertions
        Assert.notNull(modelAndView);
        Assert.notNull(form);

        Assert.notNull(form.getAuditableEntity());
        Assert.isTrue("USD".equals(form.getAuditableEntity().getCode()), form.getAuditableEntity().getCode() + " isn't USD");
    }

    @Test
    public void insertCurrency() throws Exception {

        Currency newCurr = new Currency();
        newCurr.setCode("TEST");
        newCurr.setDescription("Unit Test value");

        form.setAuditableEntity(newCurr);
        ModelAndView modelAndView = settingsController.insertAuditableEntity(form);

        Assert.notNull(modelAndView);
        Assert.notNull(form);
        Assert.notNull(form.getStatusMessage());
        Assert.isTrue(form.getStatusMessage().startsWith("Success:"));

    }

    @Test
    public void getRollupList() throws Exception {

        // Passing request parameters needed to perform get() method
        MockHttpServletRequest request = getRequest();

        request.setParameter("userId", userId);
        request.setParameter("pageId", "RollupPage");

        List<Rollup> rollups = persistenceService.getEntities(Rollup.class);

        ModelAndView modelAndView = settingsController.get(form, request);

        // Checking assertions
        Assert.notNull(modelAndView);
        Assert.notNull(form);

        Assert.notNull(form.getAuditableEntities());
        Assert.isTrue(form.getAuditableEntities().size() == rollups.size());
        Assert.notEmpty(form.getAuditableEntities());
    }

    @Test
    public void getRollupDetail() throws Exception {

        // Passing request parameters needed to perform get() method
        MockHttpServletRequest request = getRequest();

        request.setParameter("userId", userId);
        request.setParameter("pageId", "RollupDetailsPage");
        request.setParameter("entityId", "1");

        ModelAndView modelAndView = settingsController.get(form, request);

        // Checking assertions
        Assert.notNull(modelAndView);
        Assert.notNull(form);

        Assert.notNull(form.getAuditableEntity());
        Assert.isTrue("Bookstore Charges".equals(form.getAuditableEntity().getName()), "'" + form.getAuditableEntity().getName() + "' isn't what is expected");
    }

    @Test
    public void insertRollup() throws Exception {

        Rollup rollup = new Rollup();
        rollup.setCode("TEST");
        rollup.setDescription("Unit Test value");

        form.setAuditableEntity(rollup);
        ModelAndView modelAndView = settingsController.insertAuditableEntity(form);

        Assert.notNull(modelAndView);
        Assert.notNull(form);
        Assert.notNull(form.getStatusMessage());
        Assert.isTrue(form.getStatusMessage().startsWith("Success:"));
    }

*/
}
