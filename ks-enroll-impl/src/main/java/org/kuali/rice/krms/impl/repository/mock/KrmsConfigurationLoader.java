/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.rice.krms.impl.repository.mock;

import org.kuali.rice.krms.api.repository.RuleManagementService;
import org.kuali.rice.krms.api.repository.term.TermRepositoryService;
import org.kuali.rice.krms.api.repository.type.KrmsTypeRepositoryService;

/**
 *
 * @author nwright
 */
public class KrmsConfigurationLoader {

    private KrmsTypeRepositoryService krmsTypeRepositoryService = null;
    private RuleManagementService ruleManagementService = null;
    private TermRepositoryService termRepositoryService = null;

    public KrmsTypeRepositoryService getKrmsTypeRepositoryService() {

        return krmsTypeRepositoryService;
    }

    public void setKrmsTypeRepositoryService(KrmsTypeRepositoryService krmsTypeRepositoryService) {
        this.krmsTypeRepositoryService = krmsTypeRepositoryService;
    }

    public RuleManagementService getRuleManagementService() {
        return ruleManagementService;
    }

    public void setRuleManagementService(RuleManagementService ruleManagementService) {
        this.ruleManagementService = ruleManagementService;
    }

    public TermRepositoryService getTermRepositoryService() {
        return termRepositoryService;
    }

    public void setTermRepositoryService(TermRepositoryService termRepositoryService) {
        this.termRepositoryService = termRepositoryService;
    }

    public void loadConfiguration() {
        this.loadTypes();
        this.loadTypeRelations();
        this.loadNlUsages();
        this.loadNaturalLanguateTemplates();
        this.loadTermSpecs();
        this.loadTermResolvers();
        this.loadContexts();
    }

    private void loadTypes() {
        KrmsTypeLoader loader = new KrmsTypeLoader();
        loader.setKrmsTypeRepositoryService(krmsTypeRepositoryService);
        loader.load();
    }

    private void loadTypeRelations() {
        KrmsTypeRelationLoader loader = new KrmsTypeRelationLoader();
        loader.setKrmsTypeRepositoryService(krmsTypeRepositoryService);
        loader.load();
    }

    private void loadNlUsages() {
        KrmsNaturalLanguageUsageLoader loader = new KrmsNaturalLanguageUsageLoader();
        loader.setRuleManagementService(this.ruleManagementService);
        loader.load();
    }

    private void loadNaturalLanguateTemplates() {
        KrmsNaturalLanguageTemplateLoader loader = new KrmsNaturalLanguageTemplateLoader();
        loader.setRuleManagementService(this.ruleManagementService);
        loader.load();
    }

    private void loadTermSpecs() {
        KrmsTermSpecificationLoader loader = new KrmsTermSpecificationLoader();
        loader.setTermRepositoryService(this.termRepositoryService);
        loader.load();
    }

    private void loadTermResolvers() {
        KrmsTermResolverLoader loader = new KrmsTermResolverLoader();
        loader.setTermRepositoryService(this.termRepositoryService);
        loader.load();
    }
    // TODO: decide if we should even load these instead of find/create them as needed

    private void loadContexts() {
        KrmsContextLoader loader = new KrmsContextLoader();
        loader.setRuleManagementService(this.ruleManagementService);
        loader.load();
    }
}
