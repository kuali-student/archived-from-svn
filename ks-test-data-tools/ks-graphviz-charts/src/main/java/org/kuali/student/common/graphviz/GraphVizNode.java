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
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author Kuali Student Team
 * @param <E>
 */
public class GraphVizNode {

	private static final AtomicInteger indexCounter = new AtomicInteger();
	
	private final String nodeName;
	
	private final int id;

	private List<String> fieldOrdering = new ArrayList<String>();

	private Map<String, String> fieldData = new LinkedHashMap<String, String>();

	private Set<GraphVizNode> dependentNodeSet = new LinkedHashSet<GraphVizNode>();

	private boolean tallMode = true;
	/**
	 * 
	 */
	public GraphVizNode(String nodeName) {
		this.nodeName = nodeName;
		this.id = indexCounter.incrementAndGet();
	}

	public String buildHeader() {

		StringBuilder builder = new StringBuilder();

		builder.append(getId());

		builder.append(" [shape=record,label=\"");
		
		if (tallMode) {
			builder.append ("{ ");
		}
		
		builder.append(nodeName);

		for (String name : fieldOrdering) {

			builder.append(" | { ");
			builder.append(name);
			builder.append(" | ");
			String value = fieldData.get(name);

			builder.append(value);
			builder.append(" } ");
		}

		if (tallMode) {
			builder.append(" } ");
		}
		
		builder.append("\"];\n");

		return builder.toString();
	}

	public String buildDependencies() {

		StringBuilder builder = new StringBuilder();

		for (GraphVizNode dependency : this.dependentNodeSet) {

			builder.append(getId());
			builder.append(" -> ");
			builder.append(dependency.getId());
			builder.append("\n");

		}
		return builder.toString();
	}

	public String getNodeName() {
		return nodeName;
	}
	

	public int getId() {
		return id;
	}

	public void setProperty(String name, String value) {

		this.fieldOrdering.add(name);

		this.fieldData.put(name, value);

	}

	public void addDependency(GraphVizNode dependentNode) {
		this.dependentNodeSet.add(dependentNode);
	}

	/**
	 * Resolve the entire set of our dependencies and our dependencies, dependencies.
	 * 
	 * @return
	 */
	public void collectDependencies (Set<GraphVizNode>resolvedDependencySet) {
		Set<GraphVizNode> nodeSet = new HashSet<GraphVizNode>();
		nodeSet.addAll(this.dependentNodeSet);
		
		// skip any that have already been resolved.
		nodeSet.removeAll(resolvedDependencySet);
		
		for (GraphVizNode graphVizNode : nodeSet) {
			
			resolvedDependencySet.add(graphVizNode);
			graphVizNode.collectDependencies(resolvedDependencySet);
			
        }
		
	}
}
