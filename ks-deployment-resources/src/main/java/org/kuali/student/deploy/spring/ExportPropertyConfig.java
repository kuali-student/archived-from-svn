/**
 * Copyright 2011 The Kuali Foundation Licensed under the
 * Educational Community License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may
 * obtain a copy of the License at
 *
 * http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

package org.kuali.student.deploy.spring;

import java.io.File;
import java.util.List;
import java.util.Properties;

import org.kuali.common.jalc.spring.ModularDataExportConfig;
import org.kuali.common.jalc.spring.ModularSchemaExportConfig;
import org.kuali.common.jdbc.spring.JdbcMavenPropertySourceConfig;
import org.kuali.common.util.property.ProjectProperties;
import org.kuali.common.util.property.PropertiesContext;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ExportPropertyConfig extends JdbcMavenPropertySourceConfig {

    protected static final String APP_PREFIX = "student.export.app.";

    protected static final String APP_ARTIFACT_ID = "ks-impex-app-db";

    protected static final String WILDCARD = ".*";

    protected static final String APP_INCLUDE = "KS" + WILDCARD;

    protected static final String RICE_PREFIX = "student.export.rice.";

    protected static final String RICE_ARTIFACT_ID = "ks-impex-rice-db";

    protected static final String RICE_INCLUDE = "KR" + WILDCARD;

    protected static final String BUNDLED_PREFIX = "student.export.bundled.";

    protected static final String BUNDLED_ARTIFACT_ID = "ks-impex-bundled-db";

    protected static final String BUNDLED_INCLUDE = APP_INCLUDE + "," + RICE_INCLUDE;

    protected static final String SCHEMA_PROPERTY_PREFIXES = APP_PREFIX + "," + RICE_PREFIX + "," + BUNDLED_PREFIX;

    protected static final String DATA_PROPERTY_PREFIXES = APP_PREFIX + "," + RICE_PREFIX;

    protected static final String SOURCE_DB_TABLE_STATISTICS_LOCATION = "${project.basedir}/../../ks-deployment-resources/src/main/resources/org/kuali/student/impex/ks-source-db.properties";

    protected static final String SCHEMA_OUTPUT_LOCATION_SUFFIX = "-schema.xml";

    protected static final String CONSTRAINT_SCHEMA_OUTPUT_LOCATION_SUFFIX = "-constraints" + SCHEMA_OUTPUT_LOCATION_SUFFIX;

    protected static final String FS = File.separator;

    protected static final String EXPORT_PATH = "db-export";

    protected static final String RESOURCES_PATH = "src" + FS + "main" + FS + "resources" + FS;

    protected static final String SYNC_GLOBAL_PREFIX = "student.export.sync.global.";

    protected static final String SYNC_PROPERTY_PREFIXES = SCHEMA_PROPERTY_PREFIXES + "," + SYNC_GLOBAL_PREFIX;

    protected static final String DATA_FILE_EXTENSION = ".mpx";

    @Override
    protected List<ProjectProperties> getOtherProjectProperties() {
        Properties props = new Properties();

        // add properties for the prefixes
        props.put(ModularSchemaExportConfig.PROPERTY_PREFIXES_KEY, SCHEMA_PROPERTY_PREFIXES);
        props.put(ModularDataExportConfig.PROPERTY_PREFIXES_KEY, DATA_PROPERTY_PREFIXES);
        props.put(DbExportConfig.SYNC_DEFINITIONS_PREFIX_KEY, SYNC_PROPERTY_PREFIXES);

        // schema export properties
        populateSchemaProps(props, APP_PREFIX, APP_INCLUDE, APP_ARTIFACT_ID);
        populateSchemaProps(props, RICE_PREFIX, RICE_INCLUDE, RICE_ARTIFACT_ID);
        populateSchemaProps(props, BUNDLED_PREFIX, BUNDLED_INCLUDE, BUNDLED_ARTIFACT_ID);

        // data export properties
        props.put(ModularDataExportConfig.STATISTICS_LOCATION_KEY, SOURCE_DB_TABLE_STATISTICS_LOCATION);
        populateDataProps(props, APP_PREFIX, APP_INCLUDE, APP_ARTIFACT_ID);
        populateDataProps(props, RICE_PREFIX, RICE_INCLUDE, RICE_ARTIFACT_ID);
        // do not populate data properties for KS-BUNDLED, since it gets all data files from APP and RICE

        // add a sync commit path entry for the database statistics file
        props.put(SYNC_GLOBAL_PREFIX + DbExportConfig.SYNC_COMMIT_PATH_KEY, SOURCE_DB_TABLE_STATISTICS_LOCATION);

        ProjectProperties exportProjectProperties = new ProjectProperties(getProjectProperties().getProject(), new PropertiesContext(props));

        List<ProjectProperties> results = super.getOtherProjectProperties();
        results.add(exportProjectProperties);

        return results;
    }

    protected void populateSchemaProps(Properties props, String prefix, String include, String artifactId) {
        // add properties for schema export
        props.put(prefix + ModularSchemaExportConfig.NAME_INCLUDE_KEY, include);

        String artifactResourceDir = getArtifactResourceDir(artifactId);

        StringBuilder schemaSb = new StringBuilder(artifactResourceDir);
        schemaSb.append(artifactId).append(SCHEMA_OUTPUT_LOCATION_SUFFIX);
        props.put(prefix + ModularSchemaExportConfig.OUTPUT_LOCATION_KEY, schemaSb.toString());

        StringBuilder constraintSb = new StringBuilder(artifactResourceDir);
        constraintSb.append(artifactId).append(CONSTRAINT_SCHEMA_OUTPUT_LOCATION_SUFFIX);
        props.put(prefix + ModularSchemaExportConfig.FOREIGN_KEY_OUTPUT_LOCATION_KEY, constraintSb.toString());

        // add properties for schema file sync
        props.put(prefix + DbExportConfig.SYNC_REQUEST_SOURCE_DIR_KEY, artifactResourceDir);
        props.put(prefix + DbExportConfig.SYNC_REQUEST_DESTINATION_DIR_KEY, getTargetDir(artifactId));
        props.put(prefix + DbExportConfig.SYNC_REQUEST_FILTER_EXPRESSION_KEY, artifactId + WILDCARD + SCHEMA_OUTPUT_LOCATION_SUFFIX);
    }

    protected void populateDataProps(Properties props, String prefix, String include, String artifactId) {
        String artifactResourceDir = getArtifactResourceDir(artifactId);
        String syncTargetDir = getTargetDir(artifactId);

        // add properties for data export
        props.put(prefix + ModularDataExportConfig.NAME_INCLUDE_KEY, include);
        props.put(prefix + ModularDataExportConfig.OUTPUT_LOCATION_KEY, artifactResourceDir);

        // add properties for data file sync
        props.put(prefix + DbExportConfig.SYNC_COMMIT_PATH_KEY, syncTargetDir);

        props.put(prefix + DbExportConfig.SYNC_REQUEST_SOURCE_DIR_KEY, artifactResourceDir);
        props.put(prefix + DbExportConfig.SYNC_REQUEST_DESTINATION_DIR_KEY, syncTargetDir);
        props.put(prefix + DbExportConfig.SYNC_REQUEST_FILTER_EXPRESSION_KEY, include + DATA_FILE_EXTENSION);
    }

    protected String getArtifactResourceDir(String artifactId) {
        StringBuilder sb = new StringBuilder();
        sb.append("${project.build.outputDirectory}");
        sb.append(FS);
        sb.append(EXPORT_PATH);
        sb.append(FS);
        sb.append(artifactId);
        sb.append(FS);

        return sb.toString();
    }

    protected String getTargetDir(String artifactId) {
        StringBuilder sb = new StringBuilder();
        sb.append("${project.basedir}");
        sb.append(FS);
        sb.append(artifactId);
        sb.append(FS);
        sb.append(RESOURCES_PATH);

        return sb.toString();
    }
}
