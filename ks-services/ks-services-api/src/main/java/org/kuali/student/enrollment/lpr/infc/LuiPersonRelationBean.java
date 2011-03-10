/*
* Copyright 2011 The Kuali Foundation
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
package org.kuali.student.enrollment.lpr.infc;

import org.kuali.student.common.infc.AttributeInfc;
import org.kuali.student.common.infc.MetaInfc;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class LuiPersonRelationBean
        implements LuiPersonRelationInfc, Serializable {

    private static final long serialVersionUID = 1L;
    private String luiId;

    /**
     * Set ????
     * <p/>
     * Type: String
     * <p/>
     * Name: LUI
     * Unique identifier for a Learning Unit Instance (LUI).
     */
    @Override
    public void setLuiId(String luiId) {
        this.luiId = luiId;
    }

    /**
     * Get ????
     * <p/>
     * Type: String
     * <p/>
     * Name: LUI
     * Unique identifier for a Learning Unit Instance (LUI).
     */
    @Override
    public String getLuiId() {
        return this.luiId;
    }

    private String personId;

    /**
     * Set ????
     * <p/>
     * Type: String
     * <p/>
     * Name: Person
     * Unique identifier for a person record.
     */
    @Override
    public void setPersonId(String personId) {
        this.personId = personId;
    }

    /**
     * Get ????
     * <p/>
     * Type: String
     * <p/>
     * Name: Person
     * Unique identifier for a person record.
     */
    @Override
    public String getPersonId() {
        return this.personId;
    }

    private Date effectiveDate;

    /**
     * Set ????
     * <p/>
     * Type: Date
     * <p/>
     * Name:Effective
     * Date/time this relationship became effective. Must be less than or equal to the
     * expirationDate specified.
     */
    @Override
    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    /**
     * Get ????
     * <p/>
     * Type: Date
     * <p/>
     * Name:Effective
     * Date/time this relationship became effective. Must be less than or equal to the
     * expirationDate specified.
     */
    @Override
    public Date getEffectiveDate() {
        return this.effectiveDate;
    }

    private Date expirationDate;

    /**
     * Set ????
     * <p/>
     * Type: Date
     * <p/>
     * Name: Expiration
     * Date/time this relationship is no longer effective. Must be greater than or
     * equal to the effectiveDate specified.
     */
    @Override
    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    /**
     * Get ????
     * <p/>
     * Type: Date
     * <p/>
     * Name: Expiration
     * Date/time this relationship is no longer effective. Must be greater than or
     * equal to the effectiveDate specified.
     */
    @Override
    public Date getExpirationDate() {
        return this.expirationDate;
    }

    private List<AttributeInfc> attributes;

    /**
     * Set ????
     * <p/>
     * Type: List<AttributeInfc>
     * <p/>
     * Name: Generic/dynamic
     * List of key/value pairs, typically used for dynamic attributes.
     */
    @Override
    public void setAttributes(List<AttributeInfc> attributes) {
        this.attributes = attributes;
    }

    /**
     * Get ????
     * <p/>
     * Type: List<AttributeInfc>
     * <p/>
     * Name: Generic/dynamic
     * List of key/value pairs, typically used for dynamic attributes.
     */
    @Override
    public List<AttributeInfc> getAttributes() {
        return this.attributes;
    }

    private MetaInfc metaInfo;

    /**
     * Set ????
     * <p/>
     * Type: MetaInfo
     * <p/>
     * Name: Create/Update meta
     * Create and last update info for the structure. This is optional and treated as
     * read only since the data is set by the internals of the service during
     * maintenance operations.
     */
    @Override
    public void setMetaInfo(MetaInfc metaInfo) {
        this.metaInfo = metaInfo;
    }

    /**
     * Get ????
     * <p/>
     * Type: MetaInfo
     * <p/>
     * Name: Create/Update meta
     * Create and last update info for the structure. This is optional and treated as
     * read only since the data is set by the internals of the service during
     * maintenance operations.
     */
    @Override
    public MetaInfc getMetaInfo() {
        return this.metaInfo;
    }

    private String type;

    /**
     * Set ????
     * <p/>
     * Type: String
     * <p/>
     * Name: LUI Person Relation
     * Unique identifier for the type of LUI to Person relation.
     */
    @Override
    public void setType(String type) {
        this.type = type;
    }

    /**
     * Get ????
     * <p/>
     * Type: String
     * <p/>
     * Name: LUI Person Relation
     * Unique identifier for the type of LUI to Person relation.
     */
    @Override
    public String getType() {
        return this.type;
    }

    private String state;

    /**
     * Set ????
     * <p/>
     * Type: String
     * <p/>
     * Name: Relation
     * Unique identifier for the state of the relationship between a LUI and person.
     */
    @Override
    public void setState(String state) {
        this.state = state;
    }

    /**
     * Get ????
     * <p/>
     * Type: String
     * <p/>
     * Name: Relation
     * Unique identifier for the state of the relationship between a LUI and person.
     */
    @Override
    public String getState() {
        return this.state;
    }

    private String id;

    /**
     * Set ????
     * <p/>
     * Type: String
     * <p/>
     * Name: LUI Person Relation
     * Unique identifier for the LUI to Person relation. This is optional, due to the
     * identifier being set at the time of creation. Once the relation has been
     * created, this should be seen as required.
     */
    @Override
    public void setId(String id) {
        this.id = id;
    }

    /**
     * Get ????
     * <p/>
     * Type: String
     * <p/>
     * Name: LUI Person Relation
     * Unique identifier for the LUI to Person relation. This is optional, due to the
     * identifier being set at the time of creation. Once the relation has been
     * created, this should be seen as required.
     */
    @Override
    public String getId() {
        return this.id;
    }
}

