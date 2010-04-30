/*
 * Copyright 2010 The Kuali Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may	obtain a copy of the License at
 *
 * 	http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kuali.student.lum.lu.assembly.data.client.refactorme.orch;


import org.kuali.student.core.assembly.data.Data;
import org.kuali.student.core.assembly.helper.PropertyEnum;


public class LearningResultOutcomeHelper
{
	private static final long serialVersionUID = 1;
	
	public enum Properties implements PropertyEnum
	{
		OUTCOME_TYPE ("outcomeType"),
		_RUNTIME_DATA ("_runtimeData");
		
		private final String key;
		
		private Properties (final String key)
		{
			this.key = key;
		}
		
		@Override
		public String getKey ()
		{
			return this.key;
		}
	}
	private Data data;
	
	private LearningResultOutcomeHelper (Data data)
	{
		this.data = data;
	}
	
	public static LearningResultOutcomeHelper wrap (Data data)
	{
		if (data == null)
		{
			 return null;
		}
		return new LearningResultOutcomeHelper (data);
	}
	
	public Data getData ()
	{
		return data;
	}		
	
	public void setOutcomeType (String value)
	{
		data.set (Properties.OUTCOME_TYPE.getKey (), value);
	}	
	
	public String getOutcomeType ()
	{
		return data.get (Properties.OUTCOME_TYPE.getKey ());
	}
	
	public void set_runtimeData (RuntimeDataHelper value)
	{
		data.set (Properties._RUNTIME_DATA.getKey (), (value == null) ? null : value.getData ());
	}	
	
	public RuntimeDataHelper get_runtimeData ()
	{
		return RuntimeDataHelper.wrap ((Data) data.get (Properties._RUNTIME_DATA.getKey ()));
	}
	
}

