/**
 * 
 */
/*
 * Copyright 2012 The Kuali Foundation
 *
 * Licensed under the the Educational Community License, Version 1.0
 * (the "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl1.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */package org.kuali.student.common.graphviz;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author Kuali Student Team
 *
 */
public abstract class AbstractGraphVizBuilder {

	
	private final List<GraphVizNode>nodeList = new ArrayList<GraphVizNode>();
	
	protected final String graphName;
	
	/**
	 * 
	 */
	public AbstractGraphVizBuilder(String digraph) {
		this.graphName = digraph;
		
	}
	
	public String build() {
		StringBuilder builder = new StringBuilder();
		
		Set<GraphVizNode>allNodesSet = new HashSet<GraphVizNode>();
		
		allNodesSet.addAll(this.nodeList);
		
		for (GraphVizNode graphVizNode : this.nodeList) {
	        
			graphVizNode.collectDependencies(allNodesSet);
			
        }
		
		// write the header
    	writeHeader(builder);
    
    	
    	
    	for (GraphVizNode node : allNodesSet) {
	        
    		// write the header definition for each node
    		builder.append(node.buildHeader());
    	
    	}
    	for (GraphVizNode node : allNodesSet) {
	     
    		// write the relationships between the nodes.
    		builder.append(node.buildDependencies());
    	}
    	
    	
    	writeFooter(builder);
    	
    	return builder.toString();
    	
	}

	protected abstract void writeHeader(StringBuilder builder);
	
	protected abstract void writeFooter (StringBuilder builder);

	public void addNode(GraphVizNode node) {

		this.nodeList.add(node);
    }

}
