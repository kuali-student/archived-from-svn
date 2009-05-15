package org.kuali.student.common.ui.client.mvc;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.kuali.student.common.ui.client.mvc.ModelChangeEvent.Action;
import org.kuali.student.core.dto.Idable;

import com.google.gwt.event.shared.HandlerManager;
import com.google.gwt.event.shared.HandlerRegistration;

/**
 * Model object used as a container for the model state. Sources ModelChangeEvents used for tracking the model state.
 * 
 * @author Kuali Student Team
 * @param <T>
 *            the type of model object to be contained within the model
 */
public class Model<T extends Idable> {
    private Map<String, T> data = new HashMap<String, T>();
    private HandlerManager handlers = new HandlerManager(this);

    /**
     * Adds an object to the model, and fires a ModelChangeEvent
     * 
     * @param object
     */
    public void add(T object) {
        data.put(object.getId(), object);
        handlers.fireEvent(new ModelChangeEvent<T>(Action.ADD, object));
    }

    /**
     * Returns the model object associated with the specified identifier
     * 
     * @param id
     * @return
     */
    public T get(String id) {
        return data.get(id);
    }

    /**
     * Removes the model object associated with the specified identifier
     * 
     * @param id
     * @return the object that was removed, or null if not found
     */
    public T remove(String id) {
        T result = data.remove(id);
        if (result != null) {
            handlers.fireEvent(new ModelChangeEvent<T>(Action.REMOVE, result));
        }
        return result;
    }

    /**
     * Removes the specified model object from the model
     * 
     * @param object
     * @return the object that was removed, or null if not found
     */
    public T remove(T object) {
        return remove(object.getId());
    }

    /**
     * "Updates" the model object within the model. If the object does not exist in the model, then it is added. Fires a
     * ModelChangeEvent with an action indicating whether it was added or updated.
     * 
     * @param object
     */
    public void update(T object) {
        T existing = data.put(object.getId(), object);
        if (existing == null) {
            handlers.fireEvent(new ModelChangeEvent<T>(Action.ADD, object));
        } else {
            handlers.fireEvent(new ModelChangeEvent<T>(Action.UPDATE, object));
        }
    }

    /**
     * Adds a ModelChangeHandler that will be invoked for ModelChangeEvents
     * 
     * @param handler
     *            the handler to add
     * @return HandlerRegistration that can be used to unregister the handler later
     */
    public HandlerRegistration addModelChangeHandler(ModelChangeHandler<T> handler) {
        return handlers.addHandler(ModelChangeEvent.TYPE, handler);
    }

    /**
     * Returns an unsorted, umodifiable collection of the values contained within the model.
     * 
     * @return an unsorted, umodifiable collection of the values contained within the model.
     */
    public Collection<T> getValues() {
        return Collections.unmodifiableList(new ArrayList<T>(data.values()));
    }
}
