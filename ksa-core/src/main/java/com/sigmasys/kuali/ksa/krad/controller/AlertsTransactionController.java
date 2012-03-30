package com.sigmasys.kuali.ksa.krad.controller;

import com.sigmasys.kuali.ksa.model.Transaction;
import com.sigmasys.kuali.ksa.krad.form.AlertsTransactionForm;

import com.sigmasys.kuali.ksa.model.Charge;
import com.sigmasys.kuali.ksa.temp.AccountTrans;
import org.kuali.rice.krad.web.controller.UifControllerBase;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: dmulderink
 * Date: 3/27/12
 * Time: 10:32 AM
 * To change this template use File | Settings | File Templates.
 */
/**
 * Transaction details controller
 *
 * @author Michael Ivanov
 */
@Controller
@RequestMapping(value = "/alertsTransaction")
public class AlertsTransactionController extends UifControllerBase {

   /**
    * @see org.kuali.rice.krad.web.controller.UifControllerBase#createInitialForm(javax.servlet.http.HttpServletRequest)
    */
   @Override
   protected AlertsTransactionForm createInitialForm(HttpServletRequest request) {
      AlertsTransactionForm form = new AlertsTransactionForm();
      form.setTransaction(createTransaction(false));
      return form;
   }

   @RequestMapping(method = RequestMethod.POST, params = "methodToCall=save")
   public ModelAndView save(@ModelAttribute("KualiForm") AlertsTransactionForm form, BindingResult result,
                            HttpServletRequest request, HttpServletResponse response) {

      List<AccountTrans> accntTransLst = form.getAccntTransLst();

      BigDecimal totalAmnt = form.getTotalAmnt();

      for (int i = 0; i < 3; i++)
      {
         Transaction trns = createTransaction(false);
         accntTransLst.add(new AccountTrans(trns.getLedgerDate(), trns.getStatementText(),
               trns.getExternalId(), trns.getAmount()));

         totalAmnt = totalAmnt.add(trns.getAmount());
      }

      form.setTotalAmnt(totalAmnt);

      form.setAccntTransLst(accntTransLst);

      form.setTransaction(createTransaction(true));

      return getUIFModelAndView(form);
   }

   @RequestMapping(method = RequestMethod.GET, params = "methodToCall=get")
   public ModelAndView get(@ModelAttribute("KualiForm") AlertsTransactionForm form, BindingResult result,
                           HttpServletRequest request, HttpServletResponse response) {

      List<AccountTrans> accntTransLst = form.getAccntTransLst();

      BigDecimal totalAmnt = form.getTotalAmnt();

      for (int i = 0; i < 3; i++)
      {
         Transaction trns = createTransaction(false);
         accntTransLst.add(new AccountTrans(trns.getLedgerDate(), trns.getStatementText(),
               trns.getExternalId(), trns.getAmount()));

         totalAmnt = totalAmnt.add(trns.getAmount());
      }

      form.setTotalAmnt(totalAmnt);

      form.setAccntTransLst(accntTransLst);

      form.setTransaction(createTransaction(false));

      return getUIFModelAndView(form);
   }


   private Transaction createTransaction(boolean updated) {
      Transaction alertsTransaction = new Charge();
      alertsTransaction.setId(38000L);
      alertsTransaction.setExternalId("134500");
      alertsTransaction.setAmount(new BigDecimal(1050.34));
      alertsTransaction.setLedgerDate(new Date());
      alertsTransaction.setInternal(false);
      alertsTransaction.setEffectiveDate(new Date());
      alertsTransaction.setResponsibleEntity("Entity #2");
      alertsTransaction.setStatementText("Here goes statement text - " + (updated ? "Updated" : "Initial"));

      return alertsTransaction;
   }

}
