package com.sigmasys.kuali.ksa.service.impl;

import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.service.CurrencyService;
import com.sigmasys.kuali.ksa.service.TransactionService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.Query;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Transaction service JPA implementation.
 * <p/>
 *
 * @author Michael Ivanov
 */
@Service("transactionService")
@Transactional(readOnly = true)
@SuppressWarnings("unchecked")
public class TransactionServiceImpl extends GenericPersistenceService implements TransactionService {

    private static final Log logger = LogFactory.getLog(TransactionServiceImpl.class);

    @Autowired
    private CurrencyService currencyService;

    private <T extends Transaction> List<T> getTransactions(Class<T> entityType, String... userIds) {
        Query query = em.createQuery("select t from " + entityType.getName() + " t " +
                " left outer join fetch t.transactionType tt " +
                " left outer join fetch t.account a " +
                " left outer join fetch t.currency c " +
                " left outer join fetch t.rollup r " +
                " left outer join fetch t.document d " +
                ((userIds != null && userIds.length > 0) ? " where t.account.id in (:userIds) " : "") +
                " order by t.id desc");
        if (userIds != null && userIds.length > 0) {
            query.setParameter("userIds", Arrays.asList(userIds));
        }
        return (List<T>) query.getResultList();
    }

    private <T extends Transaction> T getTransaction(Long id, Class<T> entityType) {
        Query query = em.createQuery("select t from " + entityType.getName() + " t " +
                " left outer join fetch t.transactionType tt " +
                " left outer join fetch t.account a " +
                " left outer join fetch t.currency c " +
                " left outer join fetch t.rollup r " +
                " left outer join fetch t.document d " +
                " where t.id = :id ");
        query.setParameter("id", id);
        List<T> transactions = query.getResultList();
        return (transactions != null && !transactions.isEmpty()) ? transactions.get(0) : null;
    }

    /**
     * Creates a new transaction based on the given parameters
     *
     * @param id            Transaction type ID
     * @param userId        Account ID
     * @param effectiveDate Transaction effective Date
     * @param amount        Transaction amount
     * @return new Transaction instance
     */
    @Override
    @Transactional(readOnly = false)
    public Transaction createTransaction(TransactionTypeId id, String userId, Date effectiveDate, BigDecimal amount) {
        return createTransaction(id, null, userId, effectiveDate, amount);
    }

    /**
     * Creates a new transaction based on the given parameters
     *
     * @param id            Transaction type ID
     * @param userId        Account ID
     * @param effectiveDate Transaction effective Date
     * @param amount        Transaction amount
     * @return new Transaction instance
     */
    @Override
    @Transactional(readOnly = false)
    public Transaction createTransaction(TransactionTypeId id, String externalId, String userId, Date effectiveDate,
                                         BigDecimal amount) {

        TransactionType transactionType = em.find(TransactionType.class, id);
        if (transactionType == null) {
            String errMsg = "Transaction type does not exist for the given ID = " + id;
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        Account account = em.find(Account.class, userId);
        if (account == null) {
            String errMsg = "Account does not exist for the given ID = " + userId;
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        String currencyCode = java.util.Currency.getInstance(Locale.getDefault()).getCurrencyCode();
        Currency currency = currencyService.getCurrency(currencyCode);
        if (currency == null) {
            String errMsg = "Currency does not exist for the given ISO code = " + currencyCode;
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        Transaction transaction = (transactionType instanceof CreditType) ? new Payment() : new Charge();

        transaction.setTransactionType(transactionType);
        transaction.setAccount(account);
        transaction.setCurrency(currency);

        transaction.setExternalId(externalId);
        transaction.setEffectiveDate(effectiveDate);
        transaction.setNativeAmount(amount);

        persistTransaction(transaction);

        return transaction;
    }


    /**
     * Returns Transaction by ID
     *
     * @param id Transaction ID
     * @return Transaction instance
     */
    @Override
    public Transaction getTransaction(Long id) {
        return getTransaction(id, Transaction.class);
    }

    /**
     * Returns Charge by ID
     *
     * @param id Charge ID
     * @return Charge instance
     */
    @Override
    public Charge getCharge(Long id) {
        return getTransaction(id, Charge.class);
    }

    /**
     * Returns Payment by ID
     *
     * @param id Payment ID
     * @return Payment instance
     */
    @Override
    public Payment getPayment(Long id) {
        return getTransaction(id, Payment.class);
    }

    /**
     * Returns Deferment by ID
     *
     * @param id Deferment ID
     * @return Deferment instance
     */
    @Override
    public Deferment getDeferment(Long id) {
        return getTransaction(id, Deferment.class);
    }


    /**
     * Returns all transactions sorted by ID
     *
     * @return List of transactions
     */
    @Override
    public List<Transaction> getTransactions() {
        return getTransactions(Transaction.class);
    }

    /**
     * Returns all charges sorted by ID
     *
     * @return List of all charges
     */
    @Override
    public List<Charge> getCharges() {
        return getTransactions(Charge.class);
    }

    /**
     * Returns all charges by account ID
     *
     * @param userId Account ID
     * @return List of all charges by account ID
     */
    @Override
    public List<Charge> getCharges(String userId) {
        return getTransactions(Charge.class, userId);
    }

    /**
     * Returns all payments sorted by ID
     *
     * @return List of all payments
     */
    @Override
    public List<Payment> getPayments() {
        return getTransactions(Payment.class);
    }

    /**
     * Returns all payments by account ID
     *
     * @param userId Account ID
     * @return List of all payments by account ID
     */
    @Override
    public List<Payment> getPayments(String userId) {
        return getTransactions(Payment.class, userId);
    }


    /**
     * Returns all deferments sorted by ID
     *
     * @return List of all deferments
     */
    @Override
    public List<Deferment> getDeferments() {
        return getTransactions(Deferment.class);
    }

    /**
     * Returns all deferments by account ID
     *
     * @param userId Account ID
     * @return List of all deferments by account ID
     */
    @Override
    public List<Deferment> getDeferments(String userId) {
        return getTransactions(Deferment.class, userId);
    }

    /**
     * Returns all transactions sorted by ID
     *
     * @param userId Account ID
     * @return List of transactions
     */
    @Override
    public List<Transaction> getTransactions(String userId) {
        return getTransactions(Transaction.class, userId);
    }

    /**
     * Persists the transaction in the database.
     * Creates a new entity when ID is null and updates the existing one otherwise.
     *
     * @param transaction Transaction instance
     * @return Transaction ID
     */
    @Override
    @Transactional(readOnly = false)
    public Long persistTransaction(Transaction transaction) {
        return persistEntity(transaction);
    }

    /**
     * Removes the transaction from the database.
     *
     * @param id Transaction ID
     * @return true if the Transaction entity has been deleted
     */
    @Override
    @Transactional(readOnly = false)
    public boolean deleteTransaction(Long id) {
        return deleteEntity(id, Transaction.class);
    }

    @Override
    @Transactional(readOnly = false)
    public void createAllocation(Long transactionId1, Long transactionId2, BigDecimal amount) {
        // TODO
    }

    @Override
    @Transactional(readOnly = false)
    public void createLockedAllocation(Long transactionId1, Long transactionId2, BigDecimal amount) {
        // TODO
    }

    @Override
    @Transactional(readOnly = false)
    public void generateTransactionMemo(Long transactionId, String memoText) {
        // TODO
    }

    /**
     * If the reverse method is called, the system will generate a negative
     * transaction for the type of the original transaction. A memo transaction
     * will be generated, and the transactions will be locked together. Subject
     * to user customization, the transactions may be marked as hidden. (likely
     * that credits will not be hidden, debits will.) A charge to an account may
     * be reversed when a mistake is made, or a refund is issued. A payment may
     * be reversed when a payment bounces, or for some other reason is entered
     * on to the account and is not payable.
     */
    @Override
    @Transactional(readOnly = false)
    public void reverseTransaction(Long transactionId) {
        // TODO
    }

    /**
     * A deferment may be expired automatically (when the date of the deferment
     * passes) or be expired manually but the system, either through user
     * intervention, or by a payment being received on the account that removes
     * the need for the deferment. If, for example, an account is paid in full,
     * the deferment would have to be expired, otherwise a credit balance would
     * technically occur on the account.
     */
    @Override
    @Transactional(readOnly = false)
    public void expireDeferment(Long defermentId) {
        // TODO
    }

    /**
     * A deferment may be reduced or set to zero after expiration. Often, the
     * value of a deferment may not exceed the debit balance on the account to
     * prevent a credit balance being available for refund on the strength of a
     * deferment. A deferment may not be increased. Should such a situation
     * arise, the deferment would need to be expired, and a new deferment
     * issued.
     */
    @Override
    public void reduceDeferment(Long defermentId, BigDecimal newAmount) {
        // TODO
    }

    /**
     * Automatically generates a deferment transaction,
     * allocates and locks the two transactions together.
     */
    @Override
    @Transactional(readOnly = false)
    public Deferment deferTransaction(Long transactionId) {
        // TODO
        return null;
    }


    /**
     * using the transactionType, return a list of the general ledger accounts that this debit will feed. This will require the
     * effectiveDate of the transaction, as some GL codes will change after certain periods of time.
     */
    public void getGlAccounts() {
        // TODO
    }

    /**
     * As getGlAccounts(), but also returns the breakout of the amounts to the general ledger accounts. For example, if this transaction is
     * for $1000, and sends 30% to account 111 and 70% to 222 then the system will return the breakout amounts as well as the gl accounts.
     */
    public void getGlAccountsWithBreakdown() {
        // TODO
    }


}