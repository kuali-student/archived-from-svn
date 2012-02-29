/*
 * Copyright 2010 The Kuali Foundation Licensed under the
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

package org.kuali.student.core.organization.dto;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import org.kuali.student.core.organization.infc.OrgTree;
import org.w3c.dom.Element;


@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "OrgTreeInfo", propOrder = {
                "displayName", "orgHierarchyId", "orgId", "parentId",
                "positions", "positionId", "personId", "relationTypeKey"
                /*TODO KSCM-gwt-compile , "_futureElements" */ })

public class OrgTreeInfo 
    implements OrgTree, Serializable {

    private static final long serialVersionUID = 7315439355073246895L;
    
    @XmlElement
    private String displayName;

    @XmlElement
    private String orgHierarchyId;
	
    @XmlElement
    private String orgId;
	
    @XmlElement
    private String parentId;
	
    @XmlElement
    private Long positions;

    @XmlElement
    private String positionId;
	
    @XmlElement
    private String personId;
	
    @XmlElement
    private String relationTypeKey;
	
    //TODO KSCM-gwt-compile
    //@XmlAnyElement
    //private List<Element> _futureElements;


    /**
     * Constructs a new OrgTreeInfo.
     */
    public OrgTreeInfo() {
        super();
    }
    
    public OrgTreeInfo(String orgId, String parentId, String displayName) {
        super();
        this.orgId = orgId;
        this.parentId = parentId;
        this.displayName = displayName;
    }
    
    /**
     * Constructs a new OrgTreeInfo from another OrgTree
     *
     * @param orgTree the org tree to copy
     */
    public OrgTreeInfo(OrgTree tree) {
        if (tree != null) {
            this.displayName = tree.getDisplayName();
            this.orgHierarchyId = tree.getOrgHierarchyId();
            this.orgId = tree.getOrgId();
            this.parentId = tree.getParentId();
            this.positions = tree.getPositions();
            this.positionId = tree.getPositionId();
            this.personId = tree.getPersonId();
            this.relationTypeKey = tree.getRelationTypeKey();
        }
    }	
        
    @Override
    public String getDisplayName() {
        return displayName;
    }
    
    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    @Override
    public String getOrgHierarchyId() {
        return orgHierarchyId;
    }
    
    public void setOrgHierarchyId(String orgHierarchyId) {
        this.orgHierarchyId = orgHierarchyId;
    }

    @Override
    public String getOrgId() {
        return orgId;
    }
	
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    @Override
    public String getParentId() {
        return parentId;
    }
    
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    @Override
    public Long getPositions(){
        return positions;
    }
    
    public void setPositions(Long positions){
        this.positions = positions;
    }

    @Override
    public String getPositionId() {
        return positionId;
    }

    public void setPositionId(String positionId) {
        this.positionId = positionId;
    }
    
    @Override
    public String getPersonId() {
        return personId;
    }
    
    public void setPersonId(String personId) {
        this.positionId = personId;
    }
    
    @Override
    public String getRelationTypeKey() {
        return relationTypeKey;
    }

    public void setRelationTypeKey(String relationTypeKey) {
        this.relationTypeKey = relationTypeKey;
    }    
}
