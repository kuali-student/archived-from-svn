
package org.collegeboard.inas._2013;

import javax.xml.ws.WebFault;
import org.collegeboard.inas.faults.UnsupportedYearFault;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.1.6 in JDK 6
 * Generated source version: 2.1
 * 
 */
@WebFault(name = "UnsupportedYearFault", targetNamespace = "http://INAS.collegeboard.org/faults/")
public class INeedAnalysisXmlEngineRunNeedAnalysisUnsupportedYearFaultFaultFaultMessage
    extends Exception
{

    /**
     * Java type that goes as soapenv:Fault detail element.
     * 
     */
    private UnsupportedYearFault faultInfo;

    /**
     * 
     * @param message
     * @param faultInfo
     */
    public INeedAnalysisXmlEngineRunNeedAnalysisUnsupportedYearFaultFaultFaultMessage(String message, UnsupportedYearFault faultInfo) {
        super(message);
        this.faultInfo = faultInfo;
    }

    /**
     * 
     * @param message
     * @param faultInfo
     * @param cause
     */
    public INeedAnalysisXmlEngineRunNeedAnalysisUnsupportedYearFaultFaultFaultMessage(String message, UnsupportedYearFault faultInfo, Throwable cause) {
        super(message, cause);
        this.faultInfo = faultInfo;
    }

    /**
     * 
     * @return
     *     returns fault bean: org.collegeboard.inas.faults.UnsupportedYearFault
     */
    public UnsupportedYearFault getFaultInfo() {
        return faultInfo;
    }

}
