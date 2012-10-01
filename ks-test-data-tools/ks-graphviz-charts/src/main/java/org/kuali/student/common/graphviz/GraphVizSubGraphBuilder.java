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

import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author Kuali Student Team
 */
public class GraphVizSubGraphBuilder extends AbstractGraphVizBuilder {

	private static final AtomicInteger counter = new AtomicInteger();
	
	/**
	 * @param digraph
	 */
    public GraphVizSubGraphBuilder(String digraph) {
	    super(digraph);
    }

	@Override
    protected void writeHeader(StringBuilder builder) {
		builder.append("subgraph cluster");
		builder.append(counter.incrementAndGet());
    	builder.append(" {\n");	    
    	
    	builder.append("label=\"");
    	builder.append(graphName);
    	builder.append("\";\n");
    }

	@Override
    protected void writeFooter(StringBuilder builder) {
		
		builder.append("\n}\n");
	    
    }
    
    

	
}
