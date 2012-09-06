package com.sigmasys.kuali.ksa.krad.form;

import com.sigmasys.kuali.ksa.model.*;
import org.kuali.rice.core.api.util.type.KualiDecimal;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * User: dmulderink
 * Date: 4/22/12
 * Time: 6:27 PM
 */
public class CustomerServiceForm extends AbstractViewModel {

   private static final long serialVersionUID = -7525378097732916420L;

   // use this object as a query argument for matching transactions by student name
   private String studentLookupByName;

   // result set of matching persons and address postal information
   private List<Account> accountBrowseList;

   // result set of charges
   private List<Charge> chargeList;

   // result set of payments
   private List<Payment> paymentList;

   private List<Deferment> defermentList;

   // Account Status values
   private BigDecimal pastDue;

   // the account balance
   private BigDecimal balance;

   // unallocated balance
   private BigDecimal future;

   // deferment sum
   private BigDecimal defermentTotal;

   // ID and Bio information
   private String selectedId;

   // PersonName fields concatenated
   private String compositePersonName;

   // PostalAddress fields concatenated
   private String compositePostalAddress;

   // Alerts
   private List<Alert> alertList;

   // Flags
   private List<Flag> flagList;

   // the last aging date
   private Date lastAgeDate;

   // sum of aged values
   private BigDecimal agedTotal;

   // amountLate1
   private BigDecimal aged30;

   // amountLate2
   private BigDecimal aged60;

   // amountLate3
   private BigDecimal aged90;

   // Aged debit flag
   private boolean ignoreDeferment;

   // a list of Memos
   private List<Memo> memoList;

   private Memo memo;

   // the Information Text field
   private String infoText;

   // the type of information
   private String infoType;

   private Date infoCreationDate;

   private Date infoEffectiveDate;

   private String infoDeleteStatus;

   private String infoAddStatus;

   // use for adding a charge
   private Charge charge;

   // use for adding a payment
   private Payment payment;

   private String chargeTransTypeValue;

   private String paymentTransTypeValue;

   // multipurpose status field
   private String transactionStatus;

   /**
    * Get the student name
    * Possible uses is a query match for transactions
    * The value can be a partial matching name
    * @return
    */
   public String getStudentLookupByName() {
      return studentLookupByName;
   }

   /**
    * Set the student lookup name
    * Possible uses is a query match for transactions
    * The value can be a partial matching name
    * @param studentLookupByName
    */
   public void setStudentLookupByName(String studentLookupByName) {
      this.studentLookupByName = studentLookupByName;
   }

   /**
    * Get the accountBrowseList
    * Encapsulates Person and Address model
    * @return
    */
   public List<Account> getAccountBrowseList() {
      return accountBrowseList;
   }

   /**
    * Set the accountBrowseList
    * Encapsulates Person and Address model
    * @param accountBrowseList
    */
   public void setAccountBrowseList(List<Account> accountBrowseList) {
      this.accountBrowseList = accountBrowseList;
   }

   /**
    * Get the list of Charges found via a selected Account
    * @return
    */
   public List<Charge> getChargeList() {
      return chargeList;
   }

   /**
    * Set the list of Charges found via a selected Account
    * @param chargeList
    */
   public void setChargeList(List<Charge> chargeList) {
      this.chargeList = chargeList;
   }

   /**
    * Get the list of Payments found via a selected Account
    * @return
    */
   public List<Payment> getPaymentList() {
      return paymentList;
   }

   /**
    * Set the list of Payments found via a selected Account
    * @param paymentList
    */
   public void setPaymentList(List<Payment> paymentList) {
      this.paymentList = paymentList;
   }

   /**
    * Get the deferment list
    * @return
    */
   public List<Deferment> getDefermentList() {
      return defermentList;
   }

   /**
    * Set the deferment list
    * @param defermentList
    */
   public void setDefermentList(List<Deferment> defermentList) {
      this.defermentList = defermentList;
   }

   /**
    * Get the past due value
    * @return
    */
   public KualiDecimal getPastDue() {
      return new KualiDecimal(pastDue);
   }

   /**
    * Set the past due value
    * @param pastDue
    */
   public void setPastDue(BigDecimal pastDue) {
      this.pastDue = pastDue;
   }

   /**
    * Get the due balance
    * @return
    */
   public KualiDecimal getBalance() {
      return new KualiDecimal(balance);
   }

   /**
    * Set the due balance
    * @param balance
    */
   public void setBalance(BigDecimal balance) {
      this.balance = balance;
   }

   /**
    * Get the future value
    * @return
    */
   public KualiDecimal getFuture() {
      return new KualiDecimal(future);
   }

   /**
    * Set the future value
    * @param future
    */
   public void setFuture(BigDecimal future) {
      this.future = future;
   }

   /**
    * Get the deferment total
    * @return
    */
   public KualiDecimal getDefermentTotal() {
      return new KualiDecimal(defermentTotal);
   }

   /**
    * Set the deferment total
    * @param defermentTotal
    */
   public void setDefermentTotal(BigDecimal defermentTotal) {
      this.defermentTotal = defermentTotal;
   }

   /**
    * Get the selected table line item id
    * @return
    */
   public String getSelectedId() {
      return selectedId;
   }

   /**
    * Set the selected table line item id
    * @param selectedId
    */
   public void setSelectedId(String selectedId) {
      this.selectedId = selectedId;
   }

   /**
    * Get the composite person name
    * @return
    */
   public String getCompositePersonName() {
      return compositePersonName;
   }

   /**
    * Set the composite person name
    * @param compositePersonName
    */
   public void setCompositePersonName(String compositePersonName) {
      this.compositePersonName = compositePersonName;
   }

   /**
    * Get the composite postal address
    * @return
    */
   public String getCompositePostalAddress() {
      return compositePostalAddress;
   }

   /**
    * Set the composite postal address
    * @param compositePostalAddress
    */
   public void setCompositePostalAddress(String compositePostalAddress) {
      this.compositePostalAddress = compositePostalAddress;
   }

   /**
    * Get the alert list
    * @return
    */
   public List<Alert> getAlertList() {
      return alertList;
   }

   /**
    * Set the alert list
    * @param alertList
    */
   public void setAlertList(List<Alert> alertList) {
      this.alertList = alertList;
   }

   /**
    * Get the flag list
    * @return
    */
   public List<Flag> getFlagList() {
      return flagList;
   }

   /**
    * Set the flag list
    * @param flagList
    */
   public void setFlagList(List<Flag> flagList) {
      this.flagList = flagList;
   }

   /**
    * Get the last aging date
    * @return
    */
   public Date getLastAgeDate() {
      return lastAgeDate;
   }

   /**
    * Set the last aging date
    * @param lastAgeDate
    */
   public void setLastAgeDate(Date lastAgeDate) {
      this.lastAgeDate = lastAgeDate;
   }

   /**
    * Get the age total sum
    * @return
    */
   public KualiDecimal getAgedTotal() {
      return new KualiDecimal(getFormattedAmount(agedTotal));
   }

   /**
    * Set the age total sum
    * @param agedTotal
    */
   public void setAgedTotal(BigDecimal agedTotal) {
      this.agedTotal = agedTotal;
   }

   /**
    * Get the 30 day age value
    * @return
    */
   public KualiDecimal getAged30() {
      return new KualiDecimal(getFormattedAmount(aged30));
   }

   /**
    * Set the 30 day age value
    * @param aged30
    */
   public void setAged30(BigDecimal aged30) {
      this.aged30 = aged30;
   }

   /**
    * Get the 60 day age value
    * @return
    */
   public KualiDecimal getAged60() {
      return new KualiDecimal(getFormattedAmount(aged60));
   }

   /**
    * Set the 60 day age value
    * @param aged60
    */
   public void setAged60(BigDecimal aged60) {
      this.aged60 = aged60;
   }

   /**
    * Get the 90 day age value
    * @return
    */
   public KualiDecimal getAged90() {
      return new KualiDecimal(getFormattedAmount(aged90));
   }

   /**
    * Set the 90 day age value
    * @param aged90
    */
   public void setAged90(BigDecimal aged90) {
      this.aged90 = aged90;
   }

   /**
    * Get ignoreDeferment flag
    * @return
    */
   public boolean getIgnoreDeferment() {
      return ignoreDeferment;
   }

   /**
    * Set ignoreDeferment flag
    * @param ignoreDeferment
    */
   public void setIgnoreDeferment(boolean ignoreDeferment) {
      this.ignoreDeferment = ignoreDeferment;
   }

   /**
    * Get the memo list
    * @return
    */
   public List<Memo> getMemoList() {
      return memoList;
   }

   /**
    * Set the memo list
    * @param memoList
    */
   public void setMemoList(List<Memo> memoList) {
      this.memoList = memoList;
   }

   /**
    * Get the memo selected from the table
    * @return
    */
   public Memo getMemo() {
      return memo;
   }

   /**
    * Set the memo selected from the table
    * @param memo
    */
   public void setMemo(Memo memo) {
      this.memo = memo;
   }

   /**
    * Get the formatted BigDecimal value
    * @param value
    * @return
    */
   public BigDecimal getFormattedAmount(BigDecimal value) {
      if (value != null) {
         return value.setScale(5, BigDecimal.ROUND_CEILING);
      }
      return BigDecimal.ZERO;
   }

   /**
    * Get the information text
    * @return
    */
   public String getInfoText() {
      return infoText;
   }

   /**
    * Set the information text
    * @param infoText
    */
   public void setInfoText(String infoText) {
      this.infoText = infoText;
   }

   /**
    *
    * @return
    */
   public String getInfoType() {
      return infoType;
   }

   /**
    * Set the memo type
    * @param infoType
    */
   public void setInfoType(String infoType) {
      this.infoType = infoType;
   }

   /**
    * Get the info creation date
    * @return
    */
   public Date getInfoCreationDate() {
      return infoCreationDate;
   }

   /**
    * Set the info creation date
    * @param infoCreationDate
    */
   public void setInfoCreationDate(Date infoCreationDate) {
      this.infoCreationDate = infoCreationDate;
   }

   /**
    * Get the info effective date
    * @return
    */
   public Date getInfoEffectiveDate() {
      return infoEffectiveDate;
   }

   /**
    * Set the info effective date
    * @param infoEffectiveDate
    */
   public void setInfoEffectiveDate(Date infoEffectiveDate) {
      this.infoEffectiveDate = infoEffectiveDate;
   }

   /**
    * Get the delete status when removing an Info object
    * @return
    */
   public String getInfoDeleteStatus() {
      return infoDeleteStatus;
   }

   /**
    * Set the delete status when removing an Info object
    * @param infoDeleteStatus
    */
   public void setInfoDeleteStatus(String infoDeleteStatus) {
      this.infoDeleteStatus = infoDeleteStatus;
   }

   /**
    * Get the add status from persisting an info object
    * @return
    */
   public String getInfoAddStatus() {
      return infoAddStatus;
   }

   /**
    * Set the add status from persisting an info object
    * @param infoAddStatus
    */
   public void setInfoAddStatus(String infoAddStatus) {
      this.infoAddStatus = infoAddStatus;
   }

   /**
    * Get the Charge
    * @return
    */
   public Charge getCharge() {
      return charge;
   }

   /**
    * Set the Charge
    * @param charge
    */
   public void setCharge(Charge charge) {
      this.charge = charge;
   }

   /**
    * Get a Payment
    * @return
    */
   public Payment getPayment() {
      return payment;
   }

   /**
    * Set a Payment
    * @param payment
    */
   public void setPayment(Payment payment) {
      this.payment = payment;
   }

   /**
    * Get pseudo charge transaction type value
    * @return
    */
   public String getChargeTransTypeValue() {
      return chargeTransTypeValue;
   }

   /**
    * Set pseudo charge transaction type value
    * @param chargeTransTypeValue
    */
   public void setChargeTransTypeValue(String chargeTransTypeValue) {
      this.chargeTransTypeValue = chargeTransTypeValue;
   }

   /**
    * Get pseudo payment transaction type value
    * @return
    */
   public String getPaymentTransTypeValue() {
      return paymentTransTypeValue;
   }

   /**
    * Set pseudo payment transaction type value
    * @param paymentTransTypeValue
    */
   public void setPaymentTransTypeValue(String paymentTransTypeValue) {
      this.paymentTransTypeValue = paymentTransTypeValue;
   }

   public String getTransactionStatus() {
      return transactionStatus;
   }

   public void setTransactionStatus(String transactionStatus) {
      this.transactionStatus = transactionStatus;
   }
}
