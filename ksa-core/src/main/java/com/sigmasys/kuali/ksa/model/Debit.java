package com.sigmasys.kuali.ksa.model;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

/**
 * An abstract debit class. The abstraction exists in case other types of debits are to be added at a later time. The concrete Charge class should be used for instantiation of
 * actual debits.
 *
 * @author Paul Heald
 */
@MappedSuperclass
public abstract class Debit extends Transaction {


    /**
     * The reference to Deferment that offsets this transaction.
     * If this is null, isDeferred will also be set to false.
     */
    protected Boolean deferred;

    /**
     * Indicates if debit has been overriden by GL
     */
    protected Boolean glOverriden;

    
    /**
     * If a transaction is deferred, then it will return true here.
     * Deferred transactions also bear the identifier of the deferment transaction that offsets them in deferment
     * @return boolean value
     */
    @org.hibernate.annotations.Type(type="yes_no")
    @Column(name = "IS_DEFERRED")
    public Boolean isDeferred() {
        return deferred;
    }

    public void setDeferred(Boolean deferred) {
        this.deferred = deferred;
    }

    @org.hibernate.annotations.Type(type="yes_no")
    @Column(name = "IS_GL_OVERRIDEN")
    public Boolean isGlOverriden() {
        return glOverriden;
    }

    public void setGlOverriden(Boolean glOverriden) {
        this.glOverriden = glOverriden;
    }

    /**
     * Gets the priority of the debit from the transaction code. The priority of a transaction defines when it is paid off in the payment allocation system.
     * The priority of a debit may change, and is reference against the effective date of the transaction to ensure the correct priority.
     */
    @Transient
    public void getPriority() {
         // TODO
    }

}

