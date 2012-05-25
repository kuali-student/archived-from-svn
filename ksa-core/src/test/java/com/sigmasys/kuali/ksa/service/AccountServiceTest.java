package com.sigmasys.kuali.ksa.service;


import com.sigmasys.kuali.ksa.annotation.UseWebContext;
import com.sigmasys.kuali.ksa.model.*;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.kuali.rice.kim.api.identity.Person;
import org.kuali.rice.kim.api.identity.PersonService;
import org.kuali.rice.kim.api.services.KimApiServiceLocator;
import org.kuali.rice.ksb.api.KsbApiServiceLocator;
import org.kuali.rice.ksb.api.bus.Endpoint;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

import javax.xml.namespace.QName;
import java.math.BigDecimal;
import java.net.URL;
import java.util.List;

@UseWebContext
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {ServiceTestSuite.TEST_KSA_CONTEXT})
public class AccountServiceTest extends AbstractServiceTest {


    @Autowired
    private AccountService accountService;

    @Before
    public void setUpWithinTransaction() {
        // set up test data within the transaction
        String userId = "admin";
        accountService.getOrCreateAccount(userId);
    }

    @Test
    public void getAccount() throws Exception {

        Account account = accountService.getOrCreateAccount("admin1");

        Assert.notNull(account);
        Assert.notNull(account.getEntityId());

        PersonService personService = KimApiServiceLocator.getPersonService();

        Assert.notNull(personService);

        Person person = personService.getPersonByPrincipalName("admin1");

        Assert.notNull(person);
        Assert.notNull(person.getEntityId());

        Assert.isTrue(account.getEntityId().equals(person.getEntityId()));

        // Add more assertions when we have some test data
    }

    @Test
    public void getFullAccount() throws Exception {

        Account account = accountService.getOrCreateAccount("admin1");

        Assert.notNull(account);
        Assert.notNull(account.getEntityId());

        account = accountService.getFullAccount(account.getId());

        Assert.notNull(account);

        Assert.notNull(account.getPersonNames());
        Assert.notNull(account.getPostalAddresses());
        Assert.notNull(account.getElectronicContacts());

        Assert.notEmpty(account.getPersonNames());
        Assert.notEmpty(account.getPostalAddresses());
        Assert.notEmpty(account.getElectronicContacts());

        Assert.notNull(account.getDefaultPersonName());
        Assert.notNull(account.getDefaultPostalAddress());
        Assert.notNull(account.getDefaultElectronicContact());

        // Add more assertions when we have some test data
    }

    @Test
    public void getFullAccounts() throws Exception {

        List<Account> accounts = accountService.getFullAccounts();

        Assert.notNull(accounts);
        Assert.notEmpty(accounts);

        for (Account account : accounts) {

            Assert.notNull(account);

            Assert.notNull(account.getPersonNames());
            Assert.notNull(account.getPostalAddresses());
            Assert.notNull(account.getElectronicContacts());

            Assert.notEmpty(account.getPersonNames());
            Assert.notEmpty(account.getPostalAddresses());
            Assert.notEmpty(account.getElectronicContacts());

            Assert.notNull(account.getDefaultPersonName());
            Assert.notNull(account.getDefaultPostalAddress());
            Assert.notNull(account.getDefaultElectronicContact());

        }

        // Add more assertions when we have some test data
    }

    @Test
    public void getDueBalance() {

        String userId = "admin";

        BigDecimal balanceDue = accountService.getDueBalance(userId, false);

        Assert.notNull(balanceDue);
        Assert.isTrue(balanceDue.compareTo(BigDecimal.ZERO) >= 0);

        logger.info("Due balance = " + balanceDue);

    }

    @Test
    public void rebalance() {

        String userId = "admin";

        List<Pair<Debit, BigDecimal>> amounts = accountService.rebalance(userId, false);

        Assert.notNull(amounts);

        for (Pair<Debit, BigDecimal> pair : amounts) {
            Assert.notNull(pair.getA());
            Assert.notNull(pair.getB());
            logger.info("Debit date = " + pair.getA().getEffectiveDate() + ", amount = " + pair.getB());
        }

    }

    @Test
    public void ageDebt() {

        String userId = "admin";

        ChargeableAccount account = (ChargeableAccount) accountService.getFullAccount(userId);

        Assert.notNull(account);

        logger.info("Amount Late1 Before = " + account.getAmountLate1());
        logger.info("Amount Late2 Before = " + account.getAmountLate2());
        logger.info("Amount Late3 Before = " + account.getAmountLate3());

        account = accountService.ageDebt(userId, false);

        Assert.notNull(account);
        Assert.notNull(account.getAmountLate1());
        Assert.notNull(account.getAmountLate2());
        Assert.notNull(account.getAmountLate3());

        logger.info("Amount Late1 After = " + account.getAmountLate1());
        logger.info("Amount Late2 After = " + account.getAmountLate2());
        logger.info("Amount Late3 After = " + account.getAmountLate3());

    }

    @Test
    public void getAccountKsb() {

        String userId = "admin";

        QName serviceName = new QName("http://sigmasys.com/ksa", "accountService");

        Endpoint endpoint = KsbApiServiceLocator.getServiceBus().getEndpoint(serviceName);

        Assert.notNull(endpoint);
        Assert.notNull(endpoint.getServiceConfiguration());
        URL endpointUrl = endpoint.getServiceConfiguration().getEndpointUrl();
        Assert.notNull(endpointUrl);

        logger.info("Endpoint URL = " + endpointUrl);

        AccountService service = (AccountService) KsbApiServiceLocator.getServiceBus().getService(serviceName);


        Assert.notNull(service);

        Account account = service.getFullAccount(userId);

        Assert.notNull(account);

    }

    @Test
    public void addPersonName() {

        String userId = "admin";

        PersonName personName = new PersonName();
        personName.setTitle("Mr.");
        personName.setFirstName("AdminFirst");
        personName.setMiddleName("AdminMiddle");
        personName.setLastName("AdminLast");
        personName.setDefault(true);

        personName = accountService.addPersonName(userId, personName);

        Assert.notNull(personName);
        Assert.notNull(personName.getId());
        Assert.isTrue("AdminFirst".equals(personName.getFirstName()));
        Assert.isTrue("AdminMiddle".equals(personName.getMiddleName()));
        Assert.isTrue("AdminLast".equals(personName.getLastName()));
        Assert.notNull(personName.isDefault());
        Assert.isTrue(personName.isDefault());

    }


}
