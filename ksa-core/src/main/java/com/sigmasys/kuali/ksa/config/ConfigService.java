package com.sigmasys.kuali.ksa.config;

import com.sigmasys.kuali.ksa.model.Constants;
import com.sigmasys.kuali.ksa.model.InitialParameter;
import com.sigmasys.kuali.ksa.model.LocalizedString;
import com.sigmasys.kuali.ksa.service.LocalizationService;
import org.apache.log4j.Level;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import java.util.*;

/**
 * KSA Config Service
 *
 * @author Michael Ivanov
 *         Date: 3/22/12
 *         Time: 4:58 PM
 */
@Service("configService")
@Transactional(readOnly = true)
public class ConfigService {

    @Autowired
    private InitialParameterConfigurer parameterConfigurer;

    @Autowired
    @Qualifier("localizationService")
    private LocalizationService localizationService;


    @PostConstruct
    private void postConstruct() {
        // Setting up locale if "locale" initial parameters exist
        String localeLang = getInitialParameter(Constants.LOCALE_LANG_PARAM_NAME);
        if (localeLang != null && !localeLang.trim().isEmpty()) {
            String localeCountry = getInitialParameter(Constants.LOCALE_COUNTRY_PARAM_NAME);
            Locale locale = (localeCountry != null && !localeCountry.trim().isEmpty()) ?
                    new Locale(localeLang, localeCountry) : new Locale(localeLang);
            Locale.setDefault(locale);
        }
    }

    public Map<String, String> getLocalizedParameters(Locale locale) {
        if (locale == null) {
            throw new IllegalArgumentException("Locale cannot be null");
        }
        List<LocalizedString> localizedStrings =
                localizationService.getLocalizedStrings(locale.toString());
        if (localizedStrings != null) {
            Map<String, String> localizedParameters = new HashMap<String, String>(localizedStrings.size());
            for (LocalizedString string : localizedStrings) {
                localizedParameters.put(string.getId().getId(), string.getValue());
            }
            return localizedParameters;
        }
        return new HashMap<String, String>();
    }


    public String getInitialParameter(String name) {
        return getInitialParameters().get(name);
    }

    public Map<String, String> getInitialParameters() {
        return parameterConfigurer.getInitialParameters();
    }

    @Transactional(readOnly = false)
    public Integer updateInitialParameters(List<InitialParameter> params) {
        return parameterConfigurer.updateInitialParameters(params);
    }

    @Transactional(readOnly = false)
    public Integer deleteInitialParameters(Set<String> paramNames) {
        return parameterConfigurer.deleteInitialParameters(paramNames);
    }

    public List<InitialParameter> getInitialParameterList() {
        return parameterConfigurer.getInitialParameterList();
    }

    public Map<String, String> refreshInitialParameters() {
        parameterConfigurer.loadDatabaseParameters(true);
        return getInitialParameters();
    }

    private Logger getLogger(String loggerName) {
        Logger logger = ("ROOT".equals(loggerName)) ? LogManager.getRootLogger() : LogManager.getLogger(loggerName);
        if (logger != null) {
            return logger;
        }
        throw new RuntimeException("Can not find logger '" + loggerName + "'");
    }

    public void changeLoggingLevel(Map<String, String> loggers) {
        for (Map.Entry<String, String> entry : loggers.entrySet()) {
            String loggerName = entry.getKey();
            String loggerLevel = entry.getValue();
            getLogger(loggerName).setLevel(Level.toLevel(loggerLevel));
        }
    }

    public Map<String, String> getLoggingLevel(String[] loggers) {
        Map<String, String> loggerMap = new HashMap<String, String>(loggers.length);
        for (String loggerName : loggers) {
            Logger logger = getLogger(loggerName);
            loggerMap.put(loggerName, logger.getLevel() != null ? logger.getLevel().toString() : null);
        }
        return loggerMap;
    }

}
