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
package org.kuali.rice.krms.util;

/**
 * @author Kuali Student Team
 */
public class ExpressionToken implements Cloneable {

    public static int And = 1;        //TODO use AndOrButton class int instead?
    public static int Or = 2;
    public static int StartParenthesis = 3;
    public static int EndParenthesis = 4;
    public static int Condition = 5;
    public String value;
    public int type;
    private String tokenID = "";

    public String getTokenID() {
        return tokenID;
    }

    public void setTokenID(String tokenID) {
        this.tokenID = tokenID;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public static ExpressionToken createAndToken(){
        ExpressionToken t = new ExpressionToken();
        t.type = And;
        t.value = "and";
        return t;
    }

    public static ExpressionToken createOrToken(){
        ExpressionToken t = new ExpressionToken();
        t.type = Or;
        t.value = "or";
        return t;
    }

    public ExpressionToken toggleAndOr(){
        ExpressionToken t = new ExpressionToken ();
        if(type == And){
            t.type = Or;
            t.value = "Or";

        }else if(type == Or){
            t.type = And;
            t.value = "And";
        }
        return t;
    }
    
    public boolean equals(Object obj){
        if(obj instanceof ExpressionToken == false){
            return false;
        }
        ExpressionToken t = (ExpressionToken)obj;
        if(t.value == null){
            return false;
        }
        if(t.value.equals(value) && t.type == type){
            return true;
        }
        return false;
    }
    
    public int hashCode(){
    	int hash =1;
    	hash = hash * 31 + new Integer(type).hashCode();
    	hash = hash * 31 + (value == null ? 0 : value.hashCode());
    	return hash;
    }
    
    public ExpressionToken clone(){
        ExpressionToken t = new ExpressionToken();
        t.type = type;
        t.value = value;
        return t;
    }

    public String toString() {
        if (type == And) {
            return "and";
        } else if (type == Or) {
            return "or";
        } else if (type == StartParenthesis) {
            return "(";
        } else if (type == EndParenthesis) {
            return ")";
        } else if (type == Condition) {
            return value;
        }
        return "";
    }
}
