/**
 *
 */
package org.kuali.student.rules.statement;

import java.math.BigDecimal;
import java.util.List;

/**
 * A constraint that specifies that sum of a list of values is less than the required amount.
 * 
 * @param <E>
 *            the type of elements being constrained
 * @author <a href="mailto:randy@berkeley.edu">Randy Ballew</a>
 */
public class SumProposition<E extends Number> extends AbstractProposition<BigDecimal> {

    // ~ Instance fields --------------------------------------------------------

    List<E> factSet;

    // ~ Constructors -----------------------------------------------------------

    public SumProposition() {
        super();
    }

    public SumProposition(String propositionName, ComparisonOperator operator, String expectedValue, List<E> factSet) {
        super(propositionName, operator, expectedValue);
        this.factSet = factSet;
    }

    
    // ~ Methods ----------------------------------------------------------------    

    
    @Override
    public Boolean apply() {
        
        BigDecimal expectedValue = getDecimalValue(expectedValueAsString);
        
        BigDecimal sum = sum();

        result = checkTruthValue(sum, expectedValue);
        
        cacheReport("Total is short by %s", sum, expectedValue);

        return result;
    }
    
    
    /*
     * (non-Javadoc)
     * 
     * @see org.kuali.rules.constraint.AbstractConstraint#cacheAdvice(java.lang.String, java.lang.Object[])
     */
    @Override
    protected void cacheReport(String format, Object... args) {
        if (result) {
            report.setSuccessMessage("sum constraint fulfilled");
            return;
        }

        BigDecimal sum = (BigDecimal) args[0];
        BigDecimal expectedValue = (BigDecimal) args[1];

        // TODO: Use the operator to compute exact message
        BigDecimal needed = expectedValue.subtract(sum);
        String advice = String.format(format, needed.toString());
        report.setFailureMessage(advice);
    }


    /**
     * 
     * This method sums all the element in the fact list
     * 
     * @return
     */
    private BigDecimal sum() {
       BigDecimal sum = new BigDecimal("0.0");
       
       for(E element : factSet) {
           sum = sum.add( getDecimalValue(element) );
       }
       
       return sum;
    }
    
    /**
     * 
     * This method converts a given value of any Number type to big decimal
     * 
     * @param value
     * @return
     */
    private BigDecimal getDecimalValue(Object value) {
        BigDecimal decimalValue = null;
        
        if(value instanceof java.lang.String) {
            decimalValue = new BigDecimal((java.lang.String) value);
        } else if(value instanceof java.math.BigDecimal) {
            decimalValue = (java.math.BigDecimal) value;
        } else if(value instanceof java.lang.Byte
                || value instanceof java.lang.Short 
                || value instanceof java.lang.Integer 
                || value instanceof java.lang.Long) {
            decimalValue = BigDecimal.valueOf(((java.lang.Number) value).longValue());
        } else if(value instanceof java.lang.Float
                || value instanceof java.lang.Double) {
            decimalValue =  BigDecimal.valueOf(((java.lang.Number) value).doubleValue());
        }  else if(value instanceof java.lang.Number) {
            decimalValue =  BigDecimal.valueOf(((java.lang.Number) value).doubleValue());
        }
        
        // If value is none of the above type then throw exception
        if(null == decimalValue) {
            throw new IllegalArgumentException("Value cannot be converted to BigDecimal");
        }
          
        return decimalValue;
    }
    
    /**
     * @return the factSet
     */
    public List<E> getFactSet() {
        return factSet;
    }

    /**
     * @param factSet
     *            the factSet to set
     */
    public void setFactSet(List<E> factSet) {
        this.factSet = factSet;
    }
}
