package com.sigmasys.kuali.ksa.config;

import com.sigmasys.kuali.ksa.model.Constants;
import com.sigmasys.kuali.ksa.model.InitialParameter;
import com.sigmasys.kuali.ksa.util.RequestUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kuali.rice.core.api.config.property.Config;
import org.kuali.rice.core.api.config.property.ConfigContext;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.core.Ordered;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

/**
 * InitialParameterConfigurer.
 * It is used in Spring context to set parameter values in ${...} variables and
 * also by ConfigService to populate reference data.
 * <p/>
 * User: IvanovM
 * Date: Nov 28, 2010
 * Time: 10:02:23 PM
 */
@Transactional
public class InitialParameterConfigurer extends PropertyPlaceholderConfigurer {

    private static final Log logger = LogFactory.getLog(InitialParameterConfigurer.class);

    private final Properties databaseProperties = new Properties();
    private final Properties readOnlyProperties = new Properties();

    private String schemaPrefix;
    private NamedParameterJdbcTemplate jdbcTemplate;

    private Config riceConfig;


    public InitialParameterConfigurer(String schemaName) {
        this(schemaName, Ordered.LOWEST_PRECEDENCE);
    }

    public InitialParameterConfigurer(String schemaName, int order) {
        schemaPrefix = (schemaName != null && !schemaName.isEmpty()) ? schemaName + "." : "";
        setOrder(order);
    }

    public void setDataSource(DataSource dataSource) {
        jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
        loadDatabaseParameters();
    }

    public void setRiceConfig(Config riceConfig) {
        this.riceConfig = riceConfig;
    }

    protected void loadDatabaseParameters() {
        loadDatabaseParameters(false);
    }

    private void validateJdbcTemplate() {
        if (jdbcTemplate == null) {
            logger.error("jdbcTemplate is null");
            throw new IllegalStateException("jdbcTemplate is null");
        }
    }

    protected void loadDatabaseParameters(boolean refreshOnly) {

        validateJdbcTemplate();

        if (!refreshOnly) {
            databaseProperties.clear();
        }

        String query = "select NAME as name, VALUE as value from " + schemaPrefix + "KSSA_CONFIG";
        jdbcTemplate.query(query, new HashMap<String, Object>(), new RowCallbackHandler() {
            public void processRow(ResultSet rs) throws SQLException {
                String name = rs.getString("name");
                String value = rs.getString("value");
                databaseProperties.setProperty(name, value);
            }
        });
    }

    @Override
    protected void loadProperties(Properties props) throws IOException {

        // Loading local properties first and saving them as "read-only"
        super.loadProperties(props);
        readOnlyProperties.putAll(props);

        // Local properties should have the higher priority than DB parameters
        props.putAll(databaseProperties);
        props.putAll(readOnlyProperties);

        logger.debug("Initial parameters = " + props);

        if (riceConfig != null) {

            logger.debug("Initializing rice configuration...");

            // Additional properties set up
            String hostName = props.getProperty(Constants.APPLICATION_HOST_PARAM_NAME);
            if (hostName == null) {
                hostName = RequestUtils.getIPAddress();
            }

            logger.debug("Setting the Rice application host name to " + hostName);
            riceConfig.putProperty(Constants.APPLICATION_HOST_PARAM_NAME, hostName);

            riceConfig.parseConfig();
            ConfigContext.init(riceConfig);

            logger.debug("Rice configuration has been initialized");

        }
    }

    private Map<String, String> getParameters(Properties props) {
        Map<String, String> initialParamMap = new HashMap<String, String>(props.size());
        for (Map.Entry<Object, Object> entry : props.entrySet()) {
            String name = (String) entry.getKey();
            String value = (String) entry.getValue();
            initialParamMap.put(name, value);
        }
        return initialParamMap;
    }

    public Map<String, String> getInitialParameters() {
        // Local properties should have the higher priority than DB parameters
        Map<String, String> initialParams = new HashMap<String, String>(getDatabaseParameters());
        initialParams.putAll(getReadOnlyParameters());
        return initialParams;
    }

    public Map<String, String> getDatabaseParameters() {
        return getParameters(databaseProperties);
    }

    public Map<String, String> getReadOnlyParameters() {
        return getParameters(readOnlyProperties);
    }

    public List<InitialParameter> getInitialParameterList() {
        Map<String, String> databaseParams = getDatabaseParameters();
        Map<String, String> readOnlyParams = getReadOnlyParameters();
        List<InitialParameter> params = new ArrayList<InitialParameter>(databaseParams.size() + readOnlyParams.size());
        for (Map.Entry<String, String> entry : databaseParams.entrySet()) {
            params.add(new InitialParameter(entry.getKey(), entry.getValue()));
        }
        for (Map.Entry<String, String> entry : readOnlyParams.entrySet()) {
            params.add(new InitialParameter(entry.getKey(), entry.getValue(), true));
        }
        Collections.sort(params);
        return params;
    }

    public int deleteInitialParameters(Set<String> paramNames) {
        int deleted = deleteDatabaseParameters(paramNames);
        loadDatabaseParameters();
        return deleted;
    }

    private int deleteDatabaseParameters(Set<String> paramNames) {

        validateJdbcTemplate();

        List<String> paramNameList = new ArrayList<String>(paramNames);

        logger.debug("Deleting the following properties from KSA_CONFIG: " + paramNameList);

        if (!paramNameList.isEmpty()) {
            Map<String, String> parameterMap = new HashMap<String, String>(paramNameList.size());
            StringBuilder sql = new StringBuilder("delete from " + schemaPrefix + "KSA_CONFIG where NAME in (");
            for (int i = 0; i < paramNameList.size(); i++) {
                if (i > 0) {
                    sql.append(",");
                }
                String paramName = "p" + i;
                sql.append(":").append(paramName);
                parameterMap.put(paramName, paramNameList.get(i));
            }
            sql.append(")");
            return jdbcTemplate.update(sql.toString(), parameterMap);
        }
        return 0;
    }

    public int updateInitialParameters(List<InitialParameter> params) {
        int updated = updateDatabaseParameters(params);
        loadDatabaseParameters();
        return updated;
    }

    private int updateDatabaseParameters(List<InitialParameter> params) {

        validateJdbcTemplate();

        logger.debug("Deleting the following parameters from KSA_CONFIG: " + params);
        // Deleting the old parameters within the same transaction
        Set<String> paramNames = new HashSet<String>(params.size());
        for (InitialParameter param : params) {
            paramNames.add(param.getName());
        }
        deleteInitialParameters(paramNames);

        // Assembling the batch paremeters for insert statements
        List<Map<String, String>> batchParams = new ArrayList<Map<String, String>>();
        for (InitialParameter param : params) {
            if (!param.isReadOnly()) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("name", param.getName());
                map.put("value", param.getValue());
                batchParams.add(map);
            }
        }
        if (!batchParams.isEmpty()) {
            logger.debug("Inserting the following properties into KSA_CONFIG: " + batchParams);
            String sql = "insert into " + schemaPrefix + "KSA_CONFIG (NAME, VALUE) values (:name, :value)";
            Map<String, ?>[] batchParamArray = new Map[batchParams.size()];
            int[] values = jdbcTemplate.batchUpdate(sql, batchParams.toArray(batchParamArray));
            int insertedRows = 0;
            for (int value : values) {
                insertedRows += value;
            }
            return insertedRows;
        }
        return 0;
    }

    public String getSchemaPrefix() {
        return schemaPrefix;
    }
}
