package com.sigmasys.kuali.ksa.service.drools;

import com.sigmasys.kuali.ksa.config.ConfigService;
import com.sigmasys.kuali.ksa.exception.InvalidRulesException;
import com.sigmasys.kuali.ksa.model.Constants;
import com.sigmasys.kuali.ksa.model.RuleSet;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.drools.KnowledgeBase;
import org.drools.KnowledgeBaseFactory;
import org.drools.builder.*;
import org.drools.command.Command;
import org.drools.command.CommandFactory;
import org.drools.definition.KnowledgePackage;
import org.drools.io.Resource;
import org.drools.io.ResourceFactory;
import org.drools.runtime.ExecutionResults;
import org.drools.runtime.StatelessKnowledgeSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import javax.annotation.PostConstruct;
import java.io.StringReader;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * DroolsService
 *
 * @author Michael Ivanov
 *         Date: 5/21/12
 */
@Service("droolsService")
@Transactional
@SuppressWarnings("unchecked")
public class DroolsService {

    private static final Log logger = LogFactory.getLog(DroolsService.class);

    public static final String DROOLS_CONTEXT_NAME = "droolsContext";

    static {
        System.setProperty("drools.compiler", "JANINO");
        System.setProperty("drools.dialect.java.compiler", "JANINO");
    }

    public static enum PersistenceType {
        CLASSPATH,
        DATABASE
    }

    @Autowired
    private ConfigService configService;

    @Autowired
    private DroolsPersistenceService droolsPersistenceService;

    private Resource dslResource;

    // Map of <DRL file name, KnowledgeBase> objects
    private final Map<String, KnowledgeBase> knowledgeBases = new HashMap<String, KnowledgeBase>();


    @PostConstruct
    private void postConstruct() {
        String dslId = getDslId();
        logger.info("Initializing DSL resource '" + dslId + "'");
        dslResource = getRuleSetResource(getDslId());
        logger.info("DSL resource '" + dslId + "' has been initialized");
    }

    private Collection<KnowledgePackage> buildKnowledgePackages(String ruleSetId, Resource rulesResource,
                                                                ResourceType resourceType) {
        KnowledgeBuilder builder = KnowledgeBuilderFactory.newKnowledgeBuilder();
        if (ResourceType.DSLR.equals(resourceType)) {
            logger.info("Initializing DSL knowledge base...");
            builder.add(dslResource, ResourceType.DSL);
        }
        builder.add(rulesResource, resourceType);
        handleErrors(builder.getErrors(), ruleSetId);
        return builder.getKnowledgePackages();
    }

    private synchronized KnowledgeBase getKnowledgeBase(String ruleSetId, ResourceType resourceType) {
        try {
            KnowledgeBase knowledgeBase = knowledgeBases.get(ruleSetId);
            if (knowledgeBase == null) {
                Collection<KnowledgePackage> knowledgePackages =
                        buildKnowledgePackages(ruleSetId, getRuleSetResource(ruleSetId), resourceType);
                knowledgeBase = KnowledgeBaseFactory.newKnowledgeBase();
                knowledgeBase.addKnowledgePackages(knowledgePackages);
                knowledgeBases.put(ruleSetId, knowledgeBase);
            }
            return knowledgeBase;
        } catch (InvalidRulesException ire) {
            throw ire;
        } catch (Throwable t) {
            String errMsg = "Cannot retrieve KnowledgeBase from '" + ruleSetId + "'";
            logger.error(errMsg, t);
            throw new RuntimeException(errMsg, t);
        }
    }

    private void handleErrors(KnowledgeBuilderErrors errors, String ruleSetId) {
        if (errors != null && !errors.isEmpty()) {
            StringBuilder errorMessage = new StringBuilder();
            errorMessage.append("There are problems in compiling the rules for '").append(ruleSetId).append("' \n");
            for (KnowledgeBuilderError error : errors) {
                errorMessage.append(error).append("\n");
            }
            logger.error(errorMessage);
            throw new InvalidRulesException(errorMessage.toString());
        }
    }

    private <T> T fireRules(KnowledgeBase knowledgeBase, T droolsContext, Map<String, Object> globalParams) {
        try {
            StatelessKnowledgeSession session = knowledgeBase.newStatelessKnowledgeSession();
            if (globalParams != null) {
                for (Map.Entry<String, Object> entry : globalParams.entrySet()) {
                    session.setGlobal(entry.getKey(), entry.getValue());
                }
            }
            Command command = CommandFactory.newInsert(droolsContext, DROOLS_CONTEXT_NAME);
            ExecutionResults results = session.execute(CommandFactory.newBatchExecution(Arrays.asList(command)));
            return (T) results.getValue(DROOLS_CONTEXT_NAME);
        } catch (Throwable t) {
            logger.error(t.getMessage(), t);
            throw new RuntimeException(t.getMessage(), t);
        }
    }

    /**
     * Returns a Drools resource using a rule set identifier either from the classpath (by a filename) or
     * from the database (by a rule set ID column name).
     *
     * @param ruleSetId a rule set identifier
     * @return <code>Resource</code> instance
     */
    protected Resource getRuleSetResource(String ruleSetId) {
        switch (getPersistenceType()) {
            case CLASSPATH:
                return ResourceFactory.newClassPathResource(Constants.DROOLS_CLASSPATH + "/" + ruleSetId);
            case DATABASE:
                RuleSet ruleSet = droolsPersistenceService.getRules(ruleSetId);
                if (ruleSet == null) {
                    String errMsg = "Rule Set specified by ID = " + ruleSetId + " does not exist";
                    logger.error(errMsg);
                    throw new IllegalStateException(errMsg);
                }
                return ResourceFactory.newByteArrayResource(ruleSet.getRules().getBytes());
            default:
                String errMsg = "Cannot find resource handlers for persistence type = " + getPersistenceType();
                logger.error(errMsg);
                throw new IllegalStateException(errMsg);
        }
    }

    // ------------------------   PUBLIC METHOD DEFINITIONS -----------------------------------------------------


    public <T> T fireRules(String ruleSetId, ResourceType resourceType, T droolsContext,
                           Map<String, Object> globalParams) {
        return fireRules(getKnowledgeBase(ruleSetId, resourceType), droolsContext, globalParams);
    }

    public <T> T fireRules(String ruleSetId, ResourceType resourceType, T droolsContext) {
        return fireRules(getKnowledgeBase(ruleSetId, resourceType), droolsContext, null);
    }

    public void validateRuleSet(RuleSet ruleSet, ResourceType resourceType) {
        Resource ruleSetResource = ResourceFactory.newReaderResource(new StringReader(ruleSet.getRules()));
        buildKnowledgePackages(ruleSet.getId(), ruleSetResource, resourceType);
    }

    public String getDslId() {
        String dslId = configService.getInitialParameter(Constants.DROOLS_DSL_ID_PARAM_NAME);
        if (!StringUtils.hasText(dslId)) {
            String errMsg = "Parameter '" + Constants.DROOLS_DSL_ID_PARAM_NAME + "' must be set";
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }
        return dslId;
    }

    public PersistenceType getPersistenceType() {
        String type = configService.getInitialParameter(Constants.DROOLS_PERSISTENCE_PARAM_NAME);
        if (!StringUtils.hasText(type)) {
            String errMsg = "Parameter '" + Constants.DROOLS_PERSISTENCE_PARAM_NAME + "' must be set";
            logger.error(errMsg);
            throw new IllegalStateException(errMsg);
        }
        return Enum.valueOf(PersistenceType.class, type);
    }

    public void refresh() {
        knowledgeBases.clear();
        postConstruct();
    }

    public void reloadRuleSet(String ruleSetId, ResourceType resourceType) {
        if (ruleSetId.equals(getDslId())) {
            postConstruct();
        } else {
            knowledgeBases.remove(ruleSetId);
            getKnowledgeBase(ruleSetId, resourceType);
        }
    }


}
