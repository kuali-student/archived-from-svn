/**
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

package org.kuali.student.r2.common.search.dto;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import java.io.Serializable;

@XmlAccessorType(XmlAccessType.FIELD)
public class JoinComparisonInfo implements Serializable {
	private static final long serialVersionUID = 1L;
	public enum ComparisonType {EQUALS,NOTEQUALS,LESSTHAN,GREATERTHAN,LESSTHANEQUALS,GREATERTHANEQUALS};
	
	private ComparisonType type;
	private ComparisonParamInfo leftHandSide;
	private ComparisonParamInfo rightHandSide;
	public ComparisonType getType() {
		return type;
	}
	public void setType(ComparisonType type) {
		this.type = type;
	}
	public ComparisonParamInfo getLeftHandSide() {
		return leftHandSide;
	}
	public void setLeftHandSide(ComparisonParamInfo leftHandSide) {
		this.leftHandSide = leftHandSide;
	}
	public ComparisonParamInfo getRightHandSide() {
		return rightHandSide;
	}
	public void setRightHandSide(ComparisonParamInfo rightHandSide) {
		this.rightHandSide = rightHandSide;
	}
	
}
