package com.sigmasys.kuali.ksa.krad.controller;

import com.sigmasys.kuali.ksa.krad.form.CustomerServiceForm;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.service.AccountService;
import com.sigmasys.kuali.ksa.service.CurrencyService;
import com.sigmasys.kuali.ksa.service.InformationService;
import com.sigmasys.kuali.ksa.service.TransactionService;
import org.kuali.rice.krad.web.controller.UifControllerBase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * User: dmulderink
 * Date: 4/22/12
 * Time: 6:26 PM
 */
@Controller
@RequestMapping(value = "/customerService")
public class CustomerServiceController extends UifControllerBase {

   @Autowired
   private AccountService accountService;

   @Autowired
   private CurrencyService currencyService;

   @Autowired
   private InformationService informationService;

   @Autowired
   private TransactionService transactionService;

   /**
    * @see org.kuali.rice.krad.web.controller.UifControllerBase#createInitialForm(javax.servlet.http.HttpServletRequest)
    */
   @Override
   protected CustomerServiceForm createInitialForm(HttpServletRequest request) {
      CustomerServiceForm form = new CustomerServiceForm();
      form.setInfoType("MEMO");
      form.setChargeTransTypeValue("6");
      form.setPaymentTransTypeValue("5");
      return form;
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=submit")
   public ModelAndView submit(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                              HttpServletRequest request, HttpServletResponse response) {
      // do submit stuff...

      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=save")
   public ModelAndView save(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                            HttpServletRequest request, HttpServletResponse response) {
      // do save stuff...
      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=cancel")
   public ModelAndView cancel(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                              HttpServletRequest request, HttpServletResponse response) {
      // do cancel stuff...
      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=refresh")
   public ModelAndView refresh(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                               HttpServletRequest request, HttpServletResponse response) {
      // do refresh stuff...
      String accountId = form.getSelectedId();
      PopulateForm(accountId, form);

      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=addCharge")
   public ModelAndView addCharge(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                                 HttpServletRequest request, HttpServletResponse response) {
      // do add charge stuff...
      String accountId = form.getSelectedId();
      if (accountId != null && !accountId.trim().isEmpty()) {

         Account account = accountService.getFullAccount(accountId);

         Charge charge = form.getCharge();
         String chargeTransactionType = form.getChargeTransTypeValue();

         Currency currency = currencyService.getCurrency(charge.getCurrency().getIso());
         charge.setAccount(account);
         charge.setCurrency(currency);


         //TransactionTypeValue transactionTypeValue = Enum.valueOf(TransactionTypeValue.class, chargeTransactionType);
         // TransactionType transactionType = transactionService.getTransactionType(transactionTypeValue);
         //charge.setTransactionType(transactionType);

         //transactionService.persistTransaction(charge);
         PopulateForm(accountId, form);
      }

      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=makePayment")
   public ModelAndView makePayment(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                                   HttpServletRequest request, HttpServletResponse response) {
      // do make payment stuff...
      String accountId = form.getSelectedId();
      if (accountId != null && !accountId.trim().isEmpty()) {

         Payment payment = form.getPayment();
         Account account = payment.getAccount();
         Currency currency  = payment.getCurrency();
         TransactionType transactionType = payment.getTransactionType();

         //transactionService.persistTransaction(form.getPayment());
         PopulateForm(accountId, form);
      }

      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=submitPaymentAge")
   public ModelAndView submitPayAge(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                                    HttpServletRequest request, HttpServletResponse response) {

      // do make payment and age stuff...

      String accountId = form.getSelectedId();

      if (accountId != null && !accountId.trim().isEmpty()) {

         Payment payment = form.getPayment();
         Account account = payment.getAccount();
         Currency currency  = payment.getCurrency();
         TransactionType transactionType = payment.getTransactionType();

         //transactionService.persistTransaction(form.getPayment());

         // age the indexed Account Transactions
         ChargeableAccount chargeableAccount = accountService.ageDebt(accountId, form.getIgnoreDeferment());
         // populate the form using the id
         PopulateForm(accountId, form);
      }

      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.GET, params = "methodToCall=get")
   public ModelAndView get(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                           HttpServletRequest request, HttpServletResponse response) {

      // just for the transactions by person page
      String pageId = request.getParameter("pageId");

      // for the bio, aging tx alerts flags and memo
      if (pageId != null && pageId.compareTo("CustomerServicePersonOvrVwPage") == 0) {
         String id = request.getParameter("id");
         if (id == null || id.isEmpty()) {
            throw new IllegalArgumentException("'id' request parameter must be specified");
         }

         PopulateForm(id, form);
      }

      if (pageId != null && pageId.compareTo("CustomerServiceDeleteMemoPage") == 0) {
         String id = request.getParameter("id");
         if (id == null || id.isEmpty()) {
            throw new IllegalArgumentException("'id' request parameter must be specified");
         }

         Memo memo = informationService.getMemo(Long.valueOf(id));

         form.setInfoType("Memo");
         form.setInfoEffectiveDate(memo.getEffectiveDate());
         form.setInfoText(memo.getText());
         String creatorId = memo.getCreatorId();
         String editorId = memo.getEditorId();
         String xx = memo.getResponsibleEntity();
         Integer accesslvl = memo.getAccessLevel();
      }

      return getUIFModelAndView(form);
   }

   /**
    * User searches on a (last) name. The result set is iterated over to create the composite PersonName
    * and composite address using default records, eventfully creating a browse list that can be displayed
    * and selected from for further processing as desired.
    *
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=searchByName")
   public ModelAndView searchByName(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                                    HttpServletRequest request, HttpServletResponse response) {

      // we do not have a query by name or partial name via last name or contains yet
      // if no result set from getting full accounts than the List is empty
      // otherwise the lit contains records and a compsite person name and postal address

      String studentLookupByName = form.getStudentLookupByName();

      // query for all accounts

      List<Account> accountSearchList = accountService.getFullAccounts();

      // create a a list of Account objects for display requirements

      List<Account> accountList = new ArrayList<Account>();

      // if we have a result set of Accounts from the query

      for (Account account : accountSearchList) {

         PersonName personName = account.getDefaultPersonName();

         if (personName != null && personName.getLastName().contains(studentLookupByName)) {

            // an account should have a default PersonName and default PostalAddress

            PostalAddress postalAddress = account.getDefaultPostalAddress();

            Account accountCopy = account.getCopy();

            StringBuilder personNameBuilder = new StringBuilder();
            StringBuilder postalAddressBuilder = new StringBuilder();

            // create the composite default person name

            personNameBuilder.append(personName.getLastName());
            personNameBuilder.append(", ");
            personNameBuilder.append(personName.getFirstName());

            accountCopy.setCompositeDefaultPersonName(personNameBuilder.toString());

            // create the composite default postal address
            if (postalAddress != null) {
               postalAddressBuilder.append(postalAddress.getStreetAddress1());
               postalAddressBuilder.append(" ");
               postalAddressBuilder.append(postalAddress.getCity());
               postalAddressBuilder.append(", ");
               postalAddressBuilder.append(postalAddress.getState());
               postalAddressBuilder.append(" ");
               postalAddressBuilder.append(postalAddress.getPostalCode());
               postalAddressBuilder.append(" ");
               postalAddressBuilder.append(postalAddress.getCountry());

               accountCopy.setCompositeDefaultPostalAddress(postalAddressBuilder.toString());
            }

            // add each account copy to a list

            accountList.add(accountCopy);
         }
      }

      // set the account list derived from the full search list

      form.setAccountBrowseList(accountList);

      // do a search by name returning account info
      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=ageDebt")
   public ModelAndView ageDebt(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                               HttpServletRequest request, HttpServletResponse response) {

      // do aging of transactions stuff...
      String accountId = form.getSelectedId();

      if (accountId != null && !accountId.trim().isEmpty()) {
         // age the indexed Account Transactions
         ChargeableAccount chargeableAccount = accountService.ageDebt(accountId, form.getIgnoreDeferment());
         // populate the form using the id
         PopulateForm(accountId, form);
      }

      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=addMemo")
   public ModelAndView addMemo(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                               HttpServletRequest request, HttpServletResponse response) {
      // do addMemo stuff...

      String accountId = form.getSelectedId();
      String infoType = InformationTypeValue.MEMO.name();
      form.setInfoType(infoType);

      if (accountId != null && !accountId.trim().isEmpty()) {

         //String memoType = form.getMemoType();

         Account account = accountService.getFullAccount(accountId);

         //form.setSelectedId(accountId);

         InformationTypeValue informationType = Enum.valueOf(InformationTypeValue.class, infoType);

         Information info;
         switch (informationType) {
            case ALERT:
               Alert alert = new Alert();
               alert.setText(form.getInfoText());
               info = alert;
               break;
            case FLAG:
               Flag flag = new Flag();
               flag.setSeverity(0);
               info = flag;
               break;
            case MEMO:
               Memo memo = new Memo();
               memo.setText(form.getInfoText());
               info = memo;
               break;
            default:
               throw new IllegalStateException("Unknown Information Type '" + informationType);
         }

         info.setAccount(account);
         info.setCreationDate(new Date());
         info.setEffectiveDate(form.getInfoEffectiveDate());
         info.setLastUpdate(new Date());
         //info.setCreatorId();
         //info.setResponsibleEntity();
         informationService.persistInformation(info);

         // populate the form using the id
         PopulateForm(accountId, form);
      }

      return getUIFModelAndView(form);
   }

   /**
    * @param form
    * @param result
    * @param request
    * @param response
    * @return
    */
   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=deleteMemo")
   public ModelAndView deleteMemo(@ModelAttribute("KualiForm") CustomerServiceForm form, BindingResult result,
                               HttpServletRequest request, HttpServletResponse response) {
      // do deleteMemo stuff...

      String id = request.getParameter("id");
      String accountId = form.getSelectedId();
      // just for the transactions by person page
      String pageId = request.getParameter("pageId");

      informationService.deleteInformation(Long.valueOf(id));

      // populate the form using the id
      PopulateForm(accountId, form);

      return getUIFModelAndView(form);
   }

   /**
    * Create a composite person name from PersonName record fields
    *
    * @param personName
    * @return
    */
   private String CreatePersonName(PersonName personName) {

      StringBuilder personNameBuilder = new StringBuilder();

      if (personName != null) {

         // create the composite default person name

         personNameBuilder.append(personName.getLastName());
         personNameBuilder.append(", ");
         personNameBuilder.append(personName.getFirstName());
      }

      return personNameBuilder.toString();
   }

   /**
    * Create a composite postal address from PostalAddress record fields
    *
    * @param postalAddress
    * @return
    */
   private String CreateCompositePostalAddress(PostalAddress postalAddress) {

      StringBuilder postalAddressBuilder = new StringBuilder();

      // create the composite default postal address

      if (postalAddress != null) {
         postalAddressBuilder.append(postalAddress.getStreetAddress1());
         postalAddressBuilder.append(" ");
         postalAddressBuilder.append(postalAddress.getCity());
         postalAddressBuilder.append(", ");
         postalAddressBuilder.append(postalAddress.getState());
         postalAddressBuilder.append(" ");
         postalAddressBuilder.append(postalAddress.getPostalCode());
         postalAddressBuilder.append(" ");
         postalAddressBuilder.append(postalAddress.getCountry());
      }

      return postalAddressBuilder.toString();
   }

   private void PopulateForm(String id, CustomerServiceForm form) {

      // store the selected account ID
      form.setSelectedId(id);

      boolean ignoreDeferments = form.getIgnoreDeferment();

      Account accountById = accountService.getFullAccount(id);
      ChargeableAccount chargeableAccount = null;
      if (accountById != null) {
         chargeableAccount = (ChargeableAccount) accountById;
      }

      PersonName personName = accountById.getDefaultPersonName();
      PostalAddress postalAddress = accountById.getDefaultPostalAddress();

      accountById.setCompositeDefaultPersonName(CreatePersonName(personName));
      accountById.setCompositeDefaultPostalAddress(CreateCompositePostalAddress(postalAddress));
      List<Account> accountList = new ArrayList<Account>();
      accountList.add(accountById);

      // no session scope
      form.setStudentLookupByName(accountById.getDefaultPersonName().getLastName());
      // a list of one
      form.setAccountBrowseList(accountList);
      form.setCompositePersonName(accountById.getCompositeDefaultPersonName());
      form.setCompositePostalAddress(accountById.getCompositeDefaultPostalAddress());

      // Account Status summation totals
      // charges by ID
      List<Charge> charges = transactionService.getCharges(id);

      // payments by ID
      List<Payment> payments = transactionService.getPayments(id);

      // deferments by ID
      List<Deferment> deferments = transactionService.getDeferments(id);

      // set the form data

      form.setChargeList(charges);
      form.setPaymentList(payments);
      form.setDefermentList(deferments);

      // stubbed in data
      BigDecimal pastDue = BigDecimal.ZERO;
      BigDecimal balance = BigDecimal.ZERO;
      BigDecimal future = BigDecimal.ZERO;
      BigDecimal deferment = BigDecimal.ZERO;

      if (chargeableAccount != null) {
         pastDue = accountService.getOutstandingBalance(id, ignoreDeferments) != null ? accountService.getOutstandingBalance(id, ignoreDeferments) : BigDecimal.ZERO;
         balance = accountService.getDueBalance(id, ignoreDeferments) != null ? accountService.getDueBalance(id, ignoreDeferments) : BigDecimal.ZERO;
         future = accountService.getUnallocatedBalance(id) != null ? accountService.getUnallocatedBalance(id) : BigDecimal.ZERO;
         deferment = accountService.getDeferredAmount(id) != null ? accountService.getDeferredAmount(id) : BigDecimal.ZERO;

         // Aging

         Date lastAgeDate = chargeableAccount.getLateLastUpdate();
         form.setLastAgeDate(lastAgeDate);

         form.setAged30(chargeableAccount.getAmountLate1());
         form.setAged60(chargeableAccount.getAmountLate2());
         form.setAged90(chargeableAccount.getAmountLate3());

         BigDecimal agedTotal = BigDecimal.ZERO;

         if (chargeableAccount.getAmountLate1() != null &&
               chargeableAccount.getAmountLate2() != null &&
               chargeableAccount.getAmountLate3() != null) {
            agedTotal = agedTotal.add(chargeableAccount.getAmountLate1());
            agedTotal = agedTotal.add(chargeableAccount.getAmountLate2());
            agedTotal = agedTotal.add(chargeableAccount.getAmountLate3());
         }

         form.setAgedTotal(agedTotal);
      }

      form.setPastDue(pastDue);
      form.setBalance(balance);
      form.setFuture(future);
      form.setDefermentTotal(deferment);

      // Alerts and Flags
      List<Alert> informationList = new ArrayList<Alert>();
      Alert information1 = new Alert();
      information1.setId(1L);
      information1.setAccount(accountById);
      information1.setText("04/12/2012 - Please contact the university Customer Service Representative Hal Kanni-Helfew at (555) 867-5309.");

      Alert information2 = new Alert();
      information2.setId(2L);
      information2.setAccount(accountById);
      information2.setText("03/26/2012 - Check #199 bounced due to insufficient funds.");

      Alert information3 = new Alert();
      information3.setId(3L);
      information3.setAccount(accountById);
      information3.setText("03/11/2012 - Permanent address does not appear to be valid.");

      Alert information4 = new Alert();
      information4.setId(4L);
      information4.setAccount(accountById);
      information4.setText("03/11/2012 - Please contact Supervising Cashier Bill Peymaster.");

      informationList.add(information1);
      informationList.add(information2);
      informationList.add(information3);
      informationList.add(information4);

      form.setAlertList(informationList);

      form.setFlagList(informationService.getFlags(id));

      form.setMemoList(informationService.getMemos(id));
   }
}
