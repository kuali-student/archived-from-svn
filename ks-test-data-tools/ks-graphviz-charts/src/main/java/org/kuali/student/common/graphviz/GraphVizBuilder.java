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
 */
package org.kuali.student.common.graphviz;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Kuali Student Team
 */
public class GraphVizBuilder extends AbstractGraphVizBuilder {

	private final List<GraphVizSubGraphBuilder>subGraphBuilders = new ArrayList<GraphVizSubGraphBuilder>();
	
	/**
	 * @param digraph
	 */
    public GraphVizBuilder(String digraph) {
	    super(digraph);
    }

	@Override
    protected void writeHeader(StringBuilder builder) {
		
		builder.append("digraph ");
    	builder.append(graphName);
    	builder.append(" {\n");
    	
    	// now write out the sub graphs
    	
    	for (GraphVizSubGraphBuilder subGraphBuilder : this.subGraphBuilders) {
	        
    		builder.append(subGraphBuilder.build());
        }
	    
    }
	
	

	@Override
    protected void writeFooter(StringBuilder builder) {
		builder.append("\n};");	    
    }

	public void addSubGraphBuilder(GraphVizSubGraphBuilder subGraphBuilder) {

		this.subGraphBuilders.add(subGraphBuilder);
    }
    
    

	
	
}
