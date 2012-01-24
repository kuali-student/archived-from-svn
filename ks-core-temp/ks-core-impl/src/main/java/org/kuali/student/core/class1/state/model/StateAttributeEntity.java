package org.kuali.student.core.class1.state.model;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.kuali.student.common.infc.Attribute;
import org.kuali.student.core.generic.entity.BaseAttributeEntity;

@Entity
@Table(name = "KSEN_STATE_ATTR")
public class StateAttributeEntity extends BaseAttributeEntity<StateEntity> {
    
    @ManyToOne
    @JoinColumn(name = "OWNER")
    private StateEntity owner;

    public StateAttributeEntity () {
    }
    
    public StateAttributeEntity(String key, String value) {
        super(key, value);
    }

    public StateAttributeEntity(Attribute att) {
        super(att);
    }

    @Override
    public void setOwner(StateEntity owner) {
        this.owner = owner;
    }

    @Override
    public StateEntity getOwner() {
        return owner;
    }
}
