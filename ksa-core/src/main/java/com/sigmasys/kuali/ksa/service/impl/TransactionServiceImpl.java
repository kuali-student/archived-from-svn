package com.sigmasys.kuali.ksa.service.impl;

import com.sigmasys.kuali.ksa.config.ConfigService;
import com.sigmasys.kuali.ksa.exception.InvalidTransactionTypeException;
import com.sigmasys.kuali.ksa.exception.TransactionNotFoundException;
import com.sigmasys.kuali.ksa.exception.UserNotFoundException;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.service.*;
import com.sigmasys.kuali.ksa.util.ContextUtils;
import com.sigmasys.kuali.ksa.util.RequestUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.persistence.Query;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

/**
 * Transaction service JPA implementation.
 * <p/>
 *
 * @author Michael Ivanov
 */
@Service("transactionService")
@Transactional(readOnly = true)
@WebService(serviceName = TransactionService.SERVICE_NAME, portName = TransactionService.PORT_NAME,
        targetNamespace = Constants.WS_NAMESPACE)
@SuppressWarnings("unchecked")
public class TransactionServiceImpl extends GenericPersistenceService implements TransactionService {

    private static final Log logger = LogFactory.getLog(TransactionServiceImpl.class);


    @Autowired
    private ConfigService configService;

    @Autowired
    private AccountService accountService;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private CalendarService calendarService;

    @Autowired
    private InformationService informationService;

    @Autowired
    private UserSessionManager userSessionManager;


    private AccessControlService getAccessControlService() {
       return ContextUtils.getBean(AccessControlService.class);
    }


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
     * @param transactionTypeId The first part of TransactionTypeId PK, the second part (sub-code) will be calculated
     *                          based on the effective date
     * @param userId            Account ID
     * @param effectiveDate     Transaction effective Date
     * @param amount            Transaction amount
     * @return new Transaction instance
     */
    @Override
    @WebMethod(exclude = true)
    @Transactional(readOnly = false)
    public Transaction createTransaction(String transactionTypeId, String userId, Date effectiveDate, BigDecimal amount) {
        return createTransaction(transactionTypeId, null, userId, effectiveDate, amount);
    }

    /**
     * Creates a new transaction based on the given parameters
     *
     * @param transactionTypeId The first part of TransactionTypeId PK, the second part (sub-code) will be calculated
     *                          based on the effective date
     * @param externalId        Transaction External ID
     * @param userId            Account ID
     * @param effectiveDate     Transaction effective Date
     * @param amount            Transaction amount
     * @return new Transaction instance
     */
    @Override
    @Transactional(readOnly = false)
    public Transaction createTransaction(String transactionTypeId, String externalId, String userId, Date effectiveDate,
                                         BigDecimal amount) {
        TransactionTypeId id = getTransactionType(transactionTypeId, effectiveDate).getId();
        return createTransaction(id, externalId, userId, effectiveDate, amount);
    }

    /**
     * Returns the transaction type instance for the given transaction type ID and effective date
     *
     * @param transactionTypeId The first part of TransactionTypeId PK, the second part (sub-code) will be calculated
     *                          based on the effective date
     * @param effectiveDate     Transaction effective Date
     * @return TransactionType instance
     */
    @Override
    public TransactionType getTransactionType(String transactionTypeId, Date effectiveDate) {
        Query query = em.createQuery("select t from TransactionType t " +
                " where t.id.id = :transactionTypeId and :effectiveDate >= t.startDate and " +
                " (t.endDate is null or t.endDate > :effectiveDate)");
        query.setParameter("transactionTypeId", transactionTypeId);
        query.setParameter("effectiveDate", effectiveDate);
        List<TransactionType> transactionTypes = query.getResultList();
        if (transactionTypes != null && !transactionTypes.isEmpty()) {
            return transactionTypes.get(0);
        }
        String errMsg = "Cannot find TransactionType for ID = " + transactionTypeId + " and date = " + effectiveDate;
        logger.error(errMsg);
        throw new InvalidTransactionTypeException(errMsg);
    }

    /**
     * Returns the general ledger type instance for the given code.
     *
     * @param glTypeCode General Ledger type code
     * @return GeneralLedgerType instance
     */
    @Override
    public GeneralLedgerType getGeneralLedgerType(String glTypeCode) {
        Query query = em.createQuery("select t from GeneralLedgerType t where t.code = :code");
        query.setParameter("code", glTypeCode);
        List<GeneralLedgerType> glTypes = query.getResultList();
        if (glTypes != null && !glTypes.isEmpty()) {
            return glTypes.get(0);
        }
        String errMsg = "Cannot find GeneralLedgerType for the code = " + glTypeCode;
        logger.error(errMsg);
        throw new IllegalStateException(errMsg);
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
    @Transactional(readOnly = false)
    protected Transaction createTransaction(TransactionTypeId id, String externalId, String userId, Date effectiveDate,
                                            BigDecimal amount) {

        TransactionType transactionType = em.find(TransactionType.class, id);
        if (transactionType == null) {
            String errMsg = "Transaction type does not exist for the given ID = " + id;
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        Account account = em.find(Account.class, userId);
        if (account == null) {
            String errMsg = "Account does not exist for the given ID = " + userId;
            logger.error(errMsg);
            throw new UserNotFoundException(errMsg);
        }

        String currencyCode = java.util.Currency.getInstance(Locale.getDefault()).getCurrencyCode();
        Currency currency = currencyService.getCurrency(currencyCode);
        if (currency == null) {
            String errMsg = "Currency does not exist for the given ISO code = " + currencyCode;
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        Transaction transaction = (transactionType instanceof CreditType) ? new Payment() : new Charge();

        transaction.setTransactionType(transactionType);
        transaction.setAccount(account);
        transaction.setCurrency(currency);

        transaction.setExternalId(externalId);
        transaction.setEffectiveDate(effectiveDate);
        transaction.setRecognitionDate(effectiveDate);
        transaction.setNativeAmount(amount);
        transaction.setAmount(amount);
        transaction.setAllocatedAmount(BigDecimal.ZERO);
        transaction.setLockedAllocatedAmount(BigDecimal.ZERO);

        transaction.setRollup(transactionType.getRollup());
        transaction.setStatementText(transactionType.getDescription());
        transaction.setGlEntryGenerated(false);
        transaction.setInternal(false);

        transaction.setResponsibleEntity(userSessionManager.getUserId(RequestUtils.getThreadRequest()));

        if (transaction instanceof Payment) {
            CreditType creditType = (CreditType) transactionType;
            Payment payment = (Payment) transaction;
            int clearPeriod = (creditType.getClearPeriod() != null) ? creditType.getClearPeriod() : 0;
            payment.setClearDate(calendarService.addCalendarDays(effectiveDate, clearPeriod));
            payment.setRefundRule(creditType.getRefundRule());
            payment.setRefundable(creditType.getRefundRule() != null);
        } else {
            Charge charge = (Charge) transaction;
            charge.setDeferred(false);
            charge.setGlOverridden(false);
        }

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
    @WebMethod(exclude = true)
    public List<Transaction> getTransactions() {
        return getTransactions(Transaction.class);
    }

    /**
     * Returns all charges sorted by ID
     *
     * @return List of all charges
     */
    @Override
    @WebMethod(exclude = true)
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
    @WebMethod(exclude = true)
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
    @WebMethod(exclude = true)
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

    /**
     * This will allocate the value of amount on the transaction. A check will
     * be made to ensure that the allocated amount is equal to or less than the
     * localAmount, less any lockedAllocationAmount. The expectation is that
     * this method will only be called by the payment application module.
     * <p/>
     *
     * @param transactionId1 transaction1 ID
     * @param transactionId2 transaction2 ID
     * @param amount         amount of money to be allocated
     * @return a new allocation
     */
    @Override
    @Transactional(readOnly = false)
    public Allocation createAllocation(Long transactionId1, Long transactionId2, BigDecimal amount) {
        return createAllocation(transactionId1, transactionId2, amount, false);
    }

    protected Allocation createAllocation(Long transactionId1, Long transactionId2, BigDecimal newAmount, boolean locked) {

        if (newAmount == null || newAmount.compareTo(BigDecimal.ZERO) <= 0) {
            String errMsg = "The allocation amount should be a positive number";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        Transaction transaction1 = getTransaction(transactionId1);
        if (transaction1 == null) {
            String errMsg = "Transaction with ID = " + transactionId1 + " does not exist";
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        Transaction transaction2 = getTransaction(transactionId2);
        if (transaction2 == null) {
            String errMsg = "Transaction with ID = " + transactionId2 + " does not exist";
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        if (transaction1.getAccount() == null || transaction2.getAccount() == null) {
            String errMsg = "Transaction must be associated with Account";
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }

        Account account = transaction1.getAccount();
        String userId = account.getId();
        if (!userId.equals(transaction2.getAccount().getId())) {
            String errMsg = "Both transactions must be associated with the same account";
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }

        Query query = em.createQuery("select a from Allocation a " +
                " join fetch a.firstTransaction t1 " +
                " join fetch a.secondTransaction t2 " +
                " where a.account.id = :userId");
        query.setParameter("userId", userId);

        List<Allocation> allocations = query.getResultList();
        for (Allocation allocation : allocations) {
            Long id1 = allocation.getFirstTransaction().getId();
            Long id2 = allocation.getSecondTransaction().getId();
            if ((id1.equals(transactionId1) && id2.equals(transactionId2)) ||
                    (id1.equals(transactionId2) && id2.equals(transactionId1))) {
                BigDecimal allocatedAmount1 = transaction1.getAllocatedAmount() != null ?
                        transaction1.getAllocatedAmount() : BigDecimal.ZERO;
                BigDecimal allocatedAmount2 = transaction2.getAllocatedAmount() != null ?
                        transaction2.getAllocatedAmount() : BigDecimal.ZERO;
                BigDecimal newAllocatedAmount1 = (allocatedAmount1.compareTo(BigDecimal.ZERO) >= 0) ?
                        allocatedAmount1.subtract(allocation.getAmount()) :
                        allocatedAmount1.add(allocation.getAmount());
                BigDecimal newAllocatedAmount2 = (allocatedAmount2.compareTo(BigDecimal.ZERO) >= 0) ?
                        allocatedAmount2.subtract(allocation.getAmount()) :
                        allocatedAmount2.add(allocation.getAmount());
                transaction1.setAllocatedAmount(newAllocatedAmount1);
                transaction2.setAllocatedAmount(newAllocatedAmount2);
                deleteEntity(allocation.getId(), Allocation.class);
            }
        }

        BigDecimal unallocatedAmount1 = getUnallocatedAmount(transaction1);
        BigDecimal unallocatedAmount2 = getUnallocatedAmount(transaction2);

        if (unallocatedAmount1.abs().compareTo(newAmount) < 0 || unallocatedAmount2.abs().compareTo(newAmount) < 0) {
            String errMsg = "Not enough balance to cover the allocation amount " + newAmount;
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }

        TransactionType transactionType1 = transaction1.getTransactionType();
        TransactionType transactionType2 = transaction2.getTransactionType();

        boolean canAllocate = false;
        if ((transactionType1 instanceof DebitType && transactionType2 instanceof CreditType) ||
                (transactionType1 instanceof CreditType && transactionType2 instanceof DebitType)) {
            canAllocate = (unallocatedAmount1.compareTo(BigDecimal.ZERO) > 0 &&
                    unallocatedAmount2.compareTo(BigDecimal.ZERO) > 0);
        } else if ((transactionType1 instanceof DebitType && transactionType2 instanceof DebitType) ||
                (transactionType1 instanceof CreditType && transactionType2 instanceof CreditType)) {
            canAllocate = (unallocatedAmount1.compareTo(BigDecimal.ZERO) > 0 &&
                    unallocatedAmount2.compareTo(BigDecimal.ZERO) < 0) ||
                    (unallocatedAmount1.compareTo(BigDecimal.ZERO) < 0 &&
                            unallocatedAmount2.compareTo(BigDecimal.ZERO) > 0);
        }

        if (canAllocate) {

            Allocation allocation = new Allocation();
            allocation.setAccount(account);
            allocation.setFirstTransaction(transaction1);
            allocation.setSecondTransaction(transaction2);
            allocation.setAmount(newAmount);
            allocation.setLocked(locked);

            persistEntity(allocation);

            if (locked) {
                transaction1.setLockedAllocatedAmount(newAmount);
                transaction2.setLockedAllocatedAmount(newAmount);
            } else {
                transaction1.setAllocatedAmount(newAmount);
                transaction2.setAllocatedAmount(newAmount);
            }

            return allocation;

        } else {
            String errMsg = "Illegal allocation. Transaction IDs: " + transactionId1 + ", " + transactionId2 +
                    " Amount: " + newAmount;
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }
    }

    protected BigDecimal getUnallocatedAmount(Transaction transaction) {

        BigDecimal amount = transaction.getAmount() != null ?
                transaction.getAmount() : BigDecimal.ZERO;

        BigDecimal allocatedAmount = transaction.getAllocatedAmount() != null ?
                transaction.getAllocatedAmount() : BigDecimal.ZERO;

        BigDecimal lockedAllocatedAmount = transaction.getLockedAllocatedAmount() != null ?
                transaction.getLockedAllocatedAmount() : BigDecimal.ZERO;

        return amount.subtract(allocatedAmount.add(lockedAllocatedAmount));
    }

    /**
     * This will allocate a locked amount on the transaction. A check will be
     * made to ensure that the lockedAmount and the allocateAmount don't exceed
     * the ledgerAmount of the transaction. Setting an amount as locked prevents
     * the payment application system from reallocating the balance elsewhere.
     *
     * @param transactionId1 transaction1 ID
     * @param transactionId2 transaction2 ID
     * @param amount         amount of money to be allocated
     * @return a new allocation
     */
    @Override
    @Transactional(readOnly = false)
    public Allocation createLockedAllocation(Long transactionId1, Long transactionId2, BigDecimal amount) {
        return createAllocation(transactionId1, transactionId2, amount, true);
    }

    /**
     * Removes all allocations associated with the given transactions
     * <p/>
     *
     * @param transactionId Transaction ID
     */
    @Override
    @Transactional(readOnly = false)
    public void removeAllocations(Long transactionId) {

        Transaction transaction = getTransaction(transactionId);
        if (transaction == null) {
            String errMsg = "Transaction with ID = " + transactionId + " does not exist";
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        Query query = em.createQuery("select a from Allocation a " +
                " left outer join fetch a.firstTransaction t1 " +
                " left outer join fetch a.secondTransaction t2 " +
                " where t1.id = :id or t2.id = :id");
        query.setParameter("id", transactionId);

        List<Allocation> allocations = query.getResultList();

        for (Allocation allocation : allocations) {
            Long transactionId1 = allocation.getFirstTransaction().getId();
            Long transactionId2 = allocation.getSecondTransaction().getId();
            removeAllocation(transactionId1, transactionId2, allocation.isLocked());
        }

    }

    /**
     * Removes allocation between two given transactions
     * <p/>
     *
     * @param transactionId1 transaction1 ID
     * @param transactionId2 transaction2 ID
     */
    @Override
    @Transactional(readOnly = false)
    public void removeAllocation(Long transactionId1, Long transactionId2) {
        removeAllocation(transactionId1, transactionId2, false);
    }

    /**
     * Removes locked allocation between two given transactions
     * <p/>
     *
     * @param transactionId1 transaction1 ID
     * @param transactionId2 transaction2 ID
     */
    @Override
    @Transactional(readOnly = false)
    public void removeLockedAllocation(Long transactionId1, Long transactionId2) {
        removeAllocation(transactionId1, transactionId2, true);
    }

    protected void removeAllocation(Long transactionId1, Long transactionId2, boolean locked) {

        Transaction transaction1 = getTransaction(transactionId1);
        if (transaction1 == null) {
            String errMsg = "Transaction with ID = " + transactionId1 + " does not exist";
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        Transaction transaction2 = getTransaction(transactionId2);
        if (transaction2 == null) {
            String errMsg = "Transaction with ID = " + transactionId2 + " does not exist";
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        Query query = em.createQuery("select a from Allocation a " +
                " where a.firstTransaction.id = :id1 and a.secondTransaction.id = :id2");
        query.setParameter("id1", transactionId1);
        query.setParameter("id2", transactionId2);

        List<Allocation> allocations = query.getResultList();
        if (allocations == null || allocations.isEmpty()) {
            String errMsg = "Allocation does not exist for transactions: '" + transactionId1 +
                    "' and '" + transactionId2 + "'";
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }

        for (Allocation allocation : allocations) {

            BigDecimal allocatedAmount = (allocation.getAmount() != null) ?
                    allocation.getAmount() : BigDecimal.ZERO;

            BigDecimal allocatedAmount1 = locked ? transaction1.getLockedAllocatedAmount() :
                    transaction1.getAllocatedAmount();

            BigDecimal allocatedAmount2 = locked ? transaction2.getLockedAllocatedAmount() :
                    transaction2.getAllocatedAmount();

            if (allocatedAmount1 == null) {
                allocatedAmount1 = BigDecimal.ZERO;
            }

            if (allocatedAmount2 == null) {
                allocatedAmount2 = BigDecimal.ZERO;
            }

            transaction1.setAllocatedAmount(allocatedAmount1.subtract(allocatedAmount));
            transaction2.setAllocatedAmount(allocatedAmount2.subtract(allocatedAmount));

            deleteEntity(allocation.getId(), Allocation.class);
        }

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
     * Returns the transaction type for the given transaction type ID
     *
     * @param transactionTypeId The first part of TransactionTypeId PK
     * @return a subclass of TransactionType
     */
    @Override
    @WebMethod(exclude = true)
    public <T extends TransactionType> Class<T> getTransactionTypeClass(String transactionTypeId) {
        Query query = em.createQuery("select t from TransactionType t " +
                " where t.id.id = :transactionTypeId");
        query.setParameter("transactionTypeId", transactionTypeId);
        List<T> transactionTypes = query.getResultList();
        if (transactionTypes != null && !transactionTypes.isEmpty()) {
            T transactionType = transactionTypes.get(0);
            return (transactionType != null) ? (Class<T>) transactionType.getClass() : null;
        }
        return null;
    }

    /**
     * Automatically generates a deferment transaction for the given transaction,
     * allocates and locks the two transactions together.
     *
     * @param transactionId   Charge ID
     * @param partialAmount   the amount to be used for the deferment
     * @param expirationDate  the deferment expiration date
     * @param memoText        the text of the new memo created for the deferment
     * @param defermentTypeId the deferment type ID
     * @return new Deferment instance
     */
    @Override
    @Transactional(readOnly = false)
    public Deferment deferTransaction(Long transactionId, BigDecimal partialAmount,
                                      Date expirationDate, String memoText, String defermentTypeId) {

        Charge transaction = getCharge(transactionId);
        if (transaction == null) {
            String errMsg = "Transaction with ID = " + transactionId + " does not exist";
            logger.error(errMsg);
            throw new TransactionNotFoundException(errMsg);
        }

        if (transaction.isDeferred()) {
            logger.info("Transaction with ID = " + transactionId + " has already been deferred");
            Query query = em.createQuery("select d from Deferment d where d.deferredTransactionId = :id");
            query.setParameter("id", transactionId);
            List<Deferment> deferments = query.getResultList();
            if (deferments != null && !deferments.isEmpty()) {
                return deferments.get(0);
            }
            String errMsg = "Deferment cannot be found for the deferred transaction with ID = " + transactionId;
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }

        BigDecimal originalAmount = (transaction.getAmount() != null) ? transaction.getAmount() : BigDecimal.ZERO;

        if (partialAmount == null) {
            partialAmount = originalAmount;
        }

        if (partialAmount.compareTo(originalAmount) > 0) {
            String errMsg = "Deferment cannot be greater than the original amount = " + originalAmount;
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        // If the deferment type ID is null -> use the default one defined in ksa.properties
        if (defermentTypeId == null) {
            defermentTypeId = configService.getInitialParameter(Constants.DEFAULT_DEFERMENT_TYPE_PARAM_NAME);
        }

        TransactionType transactionType = getTransactionType(defermentTypeId, transaction.getEffectiveDate());

        Date curDate = new Date();

        Deferment deferment = new Deferment();
        deferment.setTransactionType(transactionType);
        deferment.setDeferredTransactionId(transactionId);
        deferment.setEffectiveDate(curDate);
        deferment.setExpirationDate(expirationDate);
        deferment.setAccount(transaction.getAccount());
        deferment.setNativeAmount(transaction.getNativeAmount());
        deferment.setAmount(transaction.getAmount());
        deferment.setCurrency(transaction.getCurrency());

        DateFormat dateFormat = DateFormat.getDateInstance();
        String dateValue = (expirationDate != null) ? dateFormat.format(expirationDate) : "N/A";
        deferment.setStatementText("Deferment of \"" + transaction.getStatementText() + "\". Expires on " + dateValue);

        deferment.setResponsibleEntity(userSessionManager.getUserId(RequestUtils.getThreadRequest()));

        // Storing a new deferment with the generated Deferment ID
        Long defermentId = persistTransaction(deferment);

        transaction.setDeferred(true);

        // Creating a new memo
        informationService.createMemo(defermentId, memoText, 0, curDate, expirationDate, null);

        createLockedAllocation(defermentId, transactionId, partialAmount);

        return deferment;
    }

    /**
     * Checks if the first transaction can pay the second transaction.
     *
     * @param transactionId1 transaction1 ID
     * @param transactionId2 transaction2 ID
     * @return true if transactionId1 can pay transactionId2, false - otherwise
     */
    @Override
    @WebMethod(exclude = true)
    public boolean canPay(Long transactionId1, Long transactionId2) {
        return canPay(transactionId1, transactionId2, Integer.MIN_VALUE, Integer.MAX_VALUE);
    }


    /**
     * Checks if the first transaction can pay the second transaction.
     *
     * @param transactionId1 transaction1 ID
     * @param transactionId2 transaction2 ID
     * @param priority       priority
     * @return true if transactionId1 can pay transactionId2, false - otherwise
     */
    @Override
    @WebMethod(exclude = true)
    public boolean canPay(Long transactionId1, Long transactionId2, int priority) {
        return canPay(transactionId1, transactionId2, priority, priority);
    }


    /**
     * Checks if the first transaction can pay the second transaction.
     *
     * @param transactionId1 transaction1 ID
     * @param transactionId2 transaction2 ID
     * @param priorityFrom   lower priority boundary
     * @param priorityTo     upper priority boundary
     * @return true if transactionId1 can pay transactionId2, false - otherwise
     */
    @Override
    public boolean canPay(Long transactionId1, Long transactionId2, int priorityFrom, int priorityTo) {

        if (priorityFrom > priorityTo) {
            String errMsg = "priorityFrom must be less or equal to priorityTo";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        Transaction transaction1 = getTransaction(transactionId1);
        if (transaction1 == null) {
            String errMsg = "Transaction with ID = " + transactionId1 + " does not exist";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        Transaction transaction2 = getTransaction(transactionId2);
        if (transaction2 == null) {
            String errMsg = "Transaction with ID = " + transactionId2 + " does not exist";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        boolean compatible = false;

        if (transaction1 instanceof Payment && transaction2 instanceof Charge) {
            if (transaction1.getAmount() != null && transaction1.getAmount().compareTo(BigDecimal.ZERO) > 0 &&
                    transaction2.getAmount() != null && transaction2.getAmount().compareTo(BigDecimal.ZERO) > 0) {
                compatible = true;
            }
        } else if (transaction1 instanceof Payment && transaction2 instanceof Payment) {
            if (transaction1.getAmount() != null && transaction1.getAmount().compareTo(BigDecimal.ZERO) > 0 &&
                    transaction2.getAmount() != null && transaction2.getAmount().compareTo(BigDecimal.ZERO) < 0) {
                compatible = true;
            }
        } else if (transaction1 instanceof Charge && transaction2 instanceof Charge) {
            if (transaction1.getAmount() != null && transaction1.getAmount().compareTo(BigDecimal.ZERO) > 0 &&
                    transaction2.getAmount() != null && transaction2.getAmount().compareTo(BigDecimal.ZERO) < 0) {
                return true;
            }
        }

        if (!compatible) {
            return false;
        }

        TransactionTypeId creditTypeId = transaction1.getTransactionType().getId();
        TransactionTypeId debitTypeId = transaction2.getTransactionType().getId();

        Query query =
                em.createQuery("select cp from CreditPermission cp where cp.creditType.id = :id" +
                        " cp.priority between :priorityFrom and :priorityTo");

        query.setParameter("id", creditTypeId);
        query.setParameter("priorityFrom", priorityFrom);
        query.setParameter("priorityTo", priorityTo);

        List<CreditPermission> creditPermissions = query.getResultList();

        if (creditPermissions != null) {
            for (CreditPermission creditPermission : creditPermissions) {
                String debitTypeMask = creditPermission.getAllowableDebitType();
                if (debitTypeMask != null && Pattern.matches(debitTypeMask, debitTypeId.getId())) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * Determine if the transaction is allowed for the given account ID, transaction type and effective date
     *
     * @param accountId       Account ID
     * @param transactionType Transaction Type
     * @param effectiveDate   Effective Date
     * @return true/false
     */
    @Override
    public boolean isTransactionAllowed(String accountId, String transactionType, Date effectiveDate) {
        // TODO getAccountBlockedStatus ??
        return accountService.doesAccountExist(accountId) &&
                getTransactionType(transactionType, effectiveDate) != null &&
                getAccessControlService().isTransactionTypeAllowed(accountId, transactionType);

    }


}