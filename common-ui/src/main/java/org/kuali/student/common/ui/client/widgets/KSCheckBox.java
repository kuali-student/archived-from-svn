package org.kuali.student.common.ui.client.widgets;

import com.google.gwt.event.dom.client.BlurEvent;
import com.google.gwt.event.dom.client.BlurHandler;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.event.dom.client.FocusEvent;
import com.google.gwt.event.dom.client.FocusHandler;
import com.google.gwt.event.logical.shared.ValueChangeEvent;
import com.google.gwt.event.logical.shared.ValueChangeHandler;
import com.google.gwt.user.client.ui.CheckBox;


/**
 * KSCheckBox wraps gwt Checkbox.  This class provides most of the same functionality, but sets KS css styles
 * for its default look and a variety of checkbox events (for improved browser compatibility and customizability).  
 * @author Kuali Student Team
 *
 */
public class KSCheckBox extends CheckBox{
    
    /**
     * Creates a check box with no label.
     * 
     */
    public KSCheckBox(){
        super();
        setupDefaultStyle();
    }
    
    /**
     * Creates a check box with the specified text label.
     * 
     * @param label the check box's label
     */
    public KSCheckBox(String label){
        super(label);
        setupDefaultStyle();
    }
    
    /**
     * This method sets the default style for the checkbox and checkbox events.
     * 
     */
    private void setupDefaultStyle(){
        addStyleName(KSStyles.KS_CHECKBOX_STYLE);
        
        this.addBlurHandler(new BlurHandler(){
            public void onBlur(BlurEvent event) {
                KSCheckBox.this.removeStyleName(KSStyles.KS_CHECKBOX_FOCUS_STYLE);
                
            }   
        }); 

        this.addFocusHandler(new FocusHandler(){
            public void onFocus(FocusEvent event) {
                KSCheckBox.this.addStyleName(KSStyles.KS_CHECKBOX_FOCUS_STYLE);

            }       
        });
        
        //hover does not function fully for check boxes as is
/*        this.addMouseOverHandler(new MouseOverHandler(){
            public void onMouseOver(MouseOverEvent event) {
                KSCheckBox.this.addStyleName(KSStyles.KS_CHECKBOX_HOVER_STYLE);
                
            }       
        });
        
        this.addMouseOutHandler(new MouseOutHandler(){

            public void onMouseOut(MouseOutEvent event) {
                KSCheckBox.this.removeStyleName(KSStyles.KS_CHECKBOX_HOVER_STYLE);
                
            }
             
        });*/
        
        this.addValueChangeHandler(new ValueChangeHandler<Boolean>(){
            @Override
            
                public void onValueChange(ValueChangeEvent<Boolean> event) {
                    if(KSCheckBox.this.getValue()){
                        KSCheckBox.this.addStyleName(KSStyles.KS_CHECKBOX_CHECKED_STYLE);
                    }
                    else{
                        KSCheckBox.this.removeStyleName(KSStyles.KS_CHECKBOX_CHECKED_STYLE);
                    }
                    
                }
            });      
    }

}
