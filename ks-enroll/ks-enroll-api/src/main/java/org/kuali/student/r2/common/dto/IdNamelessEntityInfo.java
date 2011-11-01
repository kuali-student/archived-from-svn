/*
 * Copyright 2010 The Kuali Foundation Licensed under the Educational
 * Community License, Version 2.0 (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a
 * copy of the License at http://www.osedu.org/licenses/ECL-2.0 Unless
 * required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

package org.kuali.student.r2.common.dto;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;

import org.kuali.student.r2.common.infc.IdNamelessEntity;

/**
 * Provides basic method for a nameless entity.
 */
@SuppressWarnings("serial")
@XmlTransient
public abstract class IdNamelessEntityInfo 
    extends TypeStateEntityInfo 
    implements IdNamelessEntity, Serializable {

    @XmlAttribute
    private String id;

    protected IdNamelessEntityInfo() {
        super ();
        id = null;
    }

    public IdNamelessEntityInfo(IdNamelessEntity builder) {
        super(builder);
        this.id = builder.getId();
    }

    @Override
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
