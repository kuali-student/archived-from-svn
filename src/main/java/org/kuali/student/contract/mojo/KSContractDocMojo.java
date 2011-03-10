package org.kuali.student.contract.mojo;



import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;

import org.kuali.student.contract.model.ServiceContractModel;
import org.kuali.student.contract.model.impl.ServiceContractModelCache;
import org.kuali.student.contract.model.impl.ServiceContractModelQDoxLoader;
import org.kuali.student.contract.model.util.HtmlContractWriter;
import org.kuali.student.contract.model.validation.ServiceContractModelValidator;

/**
 * Says "Hi" to the user.
  @goal kscontractdoc
 */
public class KSContractDocMojo extends AbstractMojo
{	
	/**
	* @parameter
	*/
	private   File coreDirectory;

	/**
	* @parameter
	*/
	private   File commonDirectory;
	/**
	* @parameter
	*/
	private   File lumDirectory;
	/**
	* @parameter
	*/
	private   File htmlDirectory;


	public  void setCoreDirectory(File directory) {
		this.coreDirectory =directory;
	}


	public  void  setCommonDirectory(File directory) {
		this.commonDirectory =directory;
	}


	public  void  setLumDirectory(File directory) {
		this.lumDirectory=directory;
	}
	private ServiceContractModel getModel() {
		List<String> srcDirs = new ArrayList<String>();
		srcDirs.add(this.coreDirectory.toString());
		srcDirs.add(this.commonDirectory.toString());
		srcDirs.add(this.lumDirectory.toString());
		ServiceContractModel instance = new ServiceContractModelQDoxLoader(
				srcDirs);
		return new ServiceContractModelCache(instance);

	}


	private boolean validate(ServiceContractModel model) {
		Collection<String> errors = new ServiceContractModelValidator(model)
		.validate();
		if (errors.size() > 0) {
			StringBuffer buf = new StringBuffer();
			buf.append(errors.size()
					+ " errors found while validating the data.");
			return false;


		}
		return true;
	}

	public void execute() throws MojoExecutionException
	{
		ServiceContractModel model = null;
		HtmlContractWriter writer = null;
		getLog().info("publishing wiki contracts");
		model = this.getModel();
		this.validate(model);
		writer = new HtmlContractWriter(htmlDirectory + "/student", model);
		writer.write();


	}
}
