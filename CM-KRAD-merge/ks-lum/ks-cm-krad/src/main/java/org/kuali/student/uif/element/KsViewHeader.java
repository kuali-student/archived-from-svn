/**
 * Copyright 2005-2013 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl2.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.uif.element;

import org.kuali.rice.krad.datadictionary.parse.BeanTag;
import org.kuali.rice.krad.datadictionary.parse.BeanTagAttribute;

/**
 * @author OpenCollab/rSmart KRAD CM Conversion Alliance!
 */
@BeanTag(name = "viewHeader-bean", parent = "Uif-ViewHeader")
public class KsViewHeader extends org.kuali.rice.krad.uif.element.ViewHeader {

    private boolean sticky;

    /**
     * If true, this ViewHeader will be sticky (fixed to top of window, stays at top during scrolling)
     *
     * @return true if sticky, false otherwise
     */
    @BeanTagAttribute(name = "sticky")
    public boolean isSticky() {
        return sticky;
    }

    /**
     * Set to true to make this ViewHeader sticky
     *
     * @param sticky
     */
    public void setSticky(boolean sticky) {
        this.sticky = sticky;
    }

}
