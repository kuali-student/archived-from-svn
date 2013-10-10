/*
 * Copyright 2009 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.loader.rules;

import org.apache.log4j.Logger;

import java.util.Date;

/**
 * @author nwright
 */
public class RulesDataLoaderFromCommandLine {

    private static final Logger log = Logger
            .getLogger(RulesDataLoaderFromCommandLine.class);

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        RulesDataLoaderFromCommandLine instance =
                new RulesDataLoaderFromCommandLine();
        instance.execute(args);

    }

    private void execute(String[] args) {
        if (args == null) {
            throw new RuntimeException("args is null");
        }
        if (args.length == 0) {
            throw new RuntimeException("no args specified");
        }
        if (args.length == 1) {
            //Assume source and destination are the same
            String sourceHost = args[0];
            String destHost = args[0];
            convertRuleData(sourceHost, destHost);
            //copy(sourceHost);
            //cluSetFix(sourceHost);
        } else {
            String sourceHost = args[0];
            String destHost = args[1];
            convertRuleData(sourceHost, destHost);
            //copy(sourceHost);
            //cluSetFix(sourceHost);
        }
    }

    protected void cluSetFix(String sourceHostUrl){
        RulesDataCOCopyCluSetFix cluSetFix = new RulesDataCOCopyCluSetFix();
        ServiceFactory serviceFactory = new ServiceFactory();
        serviceFactory.setHostUrl(sourceHostUrl);
        System.out.println("Connecting to Clu Service...");
        cluSetFix.setCluService(serviceFactory.getCluService());
        System.out.println("Connecting to Term Repository Service...");
        cluSetFix.setTermRepositoryService(serviceFactory.getTermRepositoryService());

        System.out.println(new Date() + " starting cluSet fix... ");
        cluSetFix.startClusetFix();

        System.out.println(new Date() + " Done with cluSet fix... ");
    }

    protected void copy(String sourceHostUrl){
        RulesDataCLUtoCOCopier copier = new RulesDataCLUtoCOCopier();
        ServiceFactory serviceFactory = new ServiceFactory();
        serviceFactory.setHostUrl(sourceHostUrl);
        System.out.println("Connecting to Course Service...");
        copier.setCourseService(serviceFactory.getCourseService());
        System.out.println("Connecting to RuleManagement Service...");
        copier.setRuleManagementService(serviceFactory.getRuleManagementService());
        System.out.println("Connecting to KRMS Type Repository Service...");
        copier.setKrmsTypeRepositoryService(serviceFactory.getKrmsTypeRepositoryService());
        System.out.println("Connecting to Term Repository Service...");
        copier.setTermRepositoryService(serviceFactory.getTermRepositoryService());

        System.out.println(new Date() + " starting copy... ");
        copier.startCopy();

        System.out.println(new Date() + " Done with copy... ");
    }

    protected void convertRuleData(String sourceHostUrl, String destHostUrl) {
        RulesDataLoader rulesLoader = new RulesDataLoader();
        KRMSHelper krmsHelper = new KRMSHelper();
        StatementHelper statementHelper = new StatementHelper();


        ServiceFactory serviceFactory = new ServiceFactory();
        serviceFactory.setHostUrl(sourceHostUrl);
        System.out.println("Connecting to Course Service...");
        statementHelper.setCourseService(serviceFactory.getCourseService());
        System.out.println("Connecting to Statement Service...");
        statementHelper.setStatementService(serviceFactory.getStatementService());
        System.out.println("Connecting to RuleManagement Service...");
        
        ServiceFactory destServiceFactory = new ServiceFactory();
        destServiceFactory.setHostUrl(destHostUrl);
        
        krmsHelper.setRuleManagementService(destServiceFactory.getRuleManagementService());
        System.out.println("Connecting to KRMS Type Repository Service...");
        krmsHelper.setKrmsTypeRepositoryService(destServiceFactory.getKrmsTypeRepositoryService());
        System.out.println("Connecting to Term Repository Service...");
        krmsHelper.setTermRepositoryService(destServiceFactory.getTermRepositoryService());

        System.out.println(new Date() + " Starting conversion... ");
        rulesLoader.setKrmsHelper(krmsHelper);
        rulesLoader.setStatementHelper(statementHelper);
        rulesLoader.startConversion();
        System.out.println(new Date() + " Conversion finished... ");

    }
}
