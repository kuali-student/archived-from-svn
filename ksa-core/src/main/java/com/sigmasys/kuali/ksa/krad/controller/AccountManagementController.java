package com.sigmasys.kuali.ksa.krad.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.kuali.rice.core.api.util.KeyValue;
import org.kuali.rice.kim.impl.identity.address.EntityAddressTypeBo;
import org.kuali.rice.kim.impl.identity.email.EntityEmailTypeBo;
import org.kuali.rice.kim.impl.identity.name.EntityNameTypeBo;
import org.kuali.rice.kim.impl.identity.phone.EntityPhoneTypeBo;
import org.kuali.rice.krad.keyvalues.KeyValuesFinder;
import org.kuali.rice.krad.web.form.UifFormBase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.sigmasys.kuali.ksa.gwt.client.view.widget.value.DateRangeValue;
import com.sigmasys.kuali.ksa.krad.form.AdminForm;
import com.sigmasys.kuali.ksa.krad.util.*;
import com.sigmasys.kuali.ksa.model.*;
import com.sigmasys.kuali.ksa.service.AuditableEntityService;

@Controller
@RequestMapping(value = "/accountManagement")
@Transactional
public class AccountManagementController extends GenericSearchController {
	
	@Autowired
	private AuditableEntityService auditableEntityService;

	/*
	 * Option KeyValueFinders.
	 */
	private volatile KeyValuesFinder nameTypeOptionsFinder;
	private volatile KeyValuesFinder addressTypeOptionsFinder;
	private volatile KeyValuesFinder emailTypeOptionsFinder;
	private volatile KeyValuesFinder phoneTypeOptionsFinder;
	private volatile KeyValuesFinder accountStatusTypeOptionsFinder;
	private volatile KeyValuesFinder latePeriodOptionsFinder;
	private volatile KeyValuesFinder bankTypeOptionsFinder;
	private volatile KeyValuesFinder taxTypeOptionsFinder;
	private volatile KeyValuesFinder idTypeKeyValuesFinder;
	private volatile KeyValuesFinder searchResultFieldsOptionsFinder;

	

	/**
	 * Creates an initial form, which is the Admin page form.
	 */
	@Override
	protected UifFormBase createInitialForm(HttpServletRequest request) {
		return new AdminForm();
	}
	
	/**
	 * Handles creation of a new form for a new personal account.
	 * 
	 * @param form		Admin form.
	 * @param request	HTTP Servlet request.
	 * @return	The new form with a new personal account.
	 */
	@RequestMapping(method = RequestMethod.GET, params = "methodToCall=newPersonAccount")
	public ModelAndView newPersonAccount(@ModelAttribute("KualiForm") AdminForm form, HttpServletRequest request) {
		// Populate the form:
		populateForNewPersonAccount(form);
		
		return getUIFModelAndView(form);
	}
	
	/**
	 * Cancels the current page and goes back to the landing page.
	 * @param form
	 * @param request
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, params = "methodToCall=cancel")
	public ModelAndView cancel(@ModelAttribute("KualiForm") AdminForm form, HttpServletRequest request) {
		// Nullify the Account and Account info:
		form.setAccount(null);
		form.setAccountInfo(null);
		form.setAccountUserPreferences(null);
		form.setPageId("AccountManagement");
		form.setViewId("AdminView");
		
		return getUIFModelAndView(form);
	}
	
	/**
	 * Handles saving of a new account.
	 * @param form
	 * @param request
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, params = "methodToCall=saveNewPersonAccount")
	public ModelAndView saveNewPersonAccount(@ModelAttribute("KualiForm") AdminForm form, HttpServletRequest request) {
		// Save an Account:
		
		return getUIFModelAndView(form);
	}
	
	
	/**
	 * Handles display of the Search Person Account page.
	 * @param form
	 * @param request
	 * @return
	 */
	@RequestMapping(method = RequestMethod.GET, params = "methodToCall=searchPersonAccount")
	public ModelAndView searchPersonAccount(@ModelAttribute("KualiForm") AdminForm form, HttpServletRequest request) {
		// Populate the form:
		populateForSearchPersonAccount(form);
		
		return getUIFModelAndView(form);
	}
	
	/**
	 * Handles Person Account search and redirection to the search result page.
	 * 
	 * @param form
	 * @param request
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, params = "methodToCall=doSearchPersonAccount")
	public ModelAndView doSearchPersonAccount(@ModelAttribute("KualiForm") AdminForm form, HttpServletRequest request) {
		// Navigate to the landing page for now:
		return cancel(form, request);
	}
	
	/* ========================================================================================
	 * 
	 * Select control option finders.
	 * 
	 * ========================================================================================*/

	/*
	 * Returns KIM Name type option finder.
	 */
	public KeyValuesFinder getNameTypeOptionsFinder() {
		if (nameTypeOptionsFinder == null) {
			synchronized(this) {
				if (nameTypeOptionsFinder == null) {
					nameTypeOptionsFinder = new KradTypeEntityKeyValuesFinder<EntityNameTypeBo>(EntityNameTypeBo.class);
				}
			}
		}
		
		return nameTypeOptionsFinder;
	}

	/*
	 * Returns KIM Address type option finder.
	 */
	public KeyValuesFinder getAddressTypeOptionsFinder() {
		if (addressTypeOptionsFinder == null) {
			synchronized(this) {
				if (addressTypeOptionsFinder == null) {
					addressTypeOptionsFinder = new KradTypeEntityKeyValuesFinder<EntityAddressTypeBo>(EntityAddressTypeBo.class);
				}
			}
		}
		
		return addressTypeOptionsFinder;
	}

	/*
	 * Returns KIM Email type options finder.
	 */
	public KeyValuesFinder getEmailTypeOptionsFinder() {
		if (emailTypeOptionsFinder == null) {
			synchronized(this) {
				if (emailTypeOptionsFinder == null) {
					emailTypeOptionsFinder = new KradTypeEntityKeyValuesFinder<EntityEmailTypeBo>(EntityEmailTypeBo.class);
				}
			}
		}
		
		return emailTypeOptionsFinder;
	}

	/*
	 * Returns KIM Phone type options finder. 
	 */
	public KeyValuesFinder getPhoneTypeOptionsFinder() {
		if (phoneTypeOptionsFinder == null) {
			synchronized(this) {
				if (phoneTypeOptionsFinder == null) {
					phoneTypeOptionsFinder = new KradTypeEntityKeyValuesFinder<EntityPhoneTypeBo>(EntityPhoneTypeBo.class);
				}
			}
		}
		
		return phoneTypeOptionsFinder;
	}

	/*
	 * Returns Account status option finder. 
	 */
	public KeyValuesFinder getAccountStatusTypeOptionsFinder() {
		if (accountStatusTypeOptionsFinder == null) {
			synchronized(this) {
				if (accountStatusTypeOptionsFinder == null) {
					accountStatusTypeOptionsFinder = new AuditableEntityKeyValuesFinder<AccountStatusType>(auditableEntityService, AccountStatusType.class);
				}
			}
		}
		
		return accountStatusTypeOptionsFinder;
	}

	/*
	 * Returns LatePeriod type option finder. 
	 */
	public KeyValuesFinder getLatePeriodOptionsFinder() {
		if (latePeriodOptionsFinder == null) {
			synchronized(this) {
				if (latePeriodOptionsFinder == null) {
					latePeriodOptionsFinder = new AuditableEntityKeyValuesFinder<LatePeriod>(auditableEntityService, LatePeriod.class);
				}
			}
		}
		
		return latePeriodOptionsFinder;
	}

	/*
	 * Returns BankType option finder. 
	 */
	public KeyValuesFinder getBankTypeOptionsFinder() {
		if (bankTypeOptionsFinder == null) {
			synchronized(this) {
				if (bankTypeOptionsFinder == null) {
					bankTypeOptionsFinder = new AuditableEntityKeyValuesFinder<BankType>(auditableEntityService, BankType.class);
				}
			}
		}
		
		return bankTypeOptionsFinder;
	}

	/*
	 * Returns TaxType option finder.
	 */
	public KeyValuesFinder getTaxTypeOptionsFinder() {
		if (taxTypeOptionsFinder == null) {
			synchronized(this) {
				if (taxTypeOptionsFinder == null) {
					taxTypeOptionsFinder = new AuditableEntityKeyValuesFinder<TaxType>(auditableEntityService, TaxType.class);
				}
			}
		}
		
		return taxTypeOptionsFinder;
	}

	/*
	 * Returns IdType option finder.
	 */
	public KeyValuesFinder getIdTypeKeyValuesFinder() {
		if (idTypeKeyValuesFinder == null) {
			synchronized(this) {
				if (idTypeKeyValuesFinder == null) {
					idTypeKeyValuesFinder = new AuditableEntityKeyValuesFinder<IdType>(auditableEntityService, IdType.class);
				}
			}
		}
		
		return idTypeKeyValuesFinder;
	}
	
	/*
	 * Returns Search Result Fields option finder.
	 */
	public KeyValuesFinder getSearchResultFieldsOptionsFinder() {
		if (searchResultFieldsOptionsFinder == null) {
			synchronized(this) {
				if (searchResultFieldsOptionsFinder == null) {
					searchResultFieldsOptionsFinder = new AccountSearchResultFieldsKeyValuesFinder();
				}
			}
		}
		
		return searchResultFieldsOptionsFinder;
	}
	
	
	/* *******************************************************************************************************************
	 * 
	 * Helper methods. 
	 * 
	 * ******************************************************************************************************************/
	
	/*
	 * Populates the given form for a New Person Account page.
	 */
	private void populateForNewPersonAccount(AdminForm form) {
		// Nullify the Account to make sure a new one is being created:
		form.setAccount(null);
		
		// Create a new AccountInformation holder object:
		AdminForm.AccountInformation accountInfo = new AdminForm.AccountInformation();
		PersonName name = new PersonName();
		PostalAddress address = new PostalAddress();
		ElectronicContact electronicContact = new ElectronicContact();
        BigDecimal creditLimit = new BigDecimal(0);
		
		accountInfo.setName(name);
		accountInfo.setAddress(address);
		accountInfo.setElectronicContact(electronicContact);
		accountInfo.setDateOfBirth(new Date());
		accountInfo.setAbleToAuthenticate(Boolean.TRUE);
		accountInfo.setCreditLimit(creditLimit);
		form.setAccountInfo(accountInfo);
		
		// Set option finders:
		form.setNameTypeOptionsFinder(getNameTypeOptionsFinder());
		form.setAddressTypeOptionsFinder(getAddressTypeOptionsFinder());
		form.setEmailTypeOptionsFinder(getEmailTypeOptionsFinder());
		form.setPhoneTypeOptionsFinder(getPhoneTypeOptionsFinder());
		form.setLatePeriodOptionsFinder(getLatePeriodOptionsFinder());
		form.setBankTypeOptionsFinder(getBankTypeOptionsFinder());
		form.setTaxTypeOptionsFinder(getTaxTypeOptionsFinder());
		form.setIdTypeKeyValuesFinder(getIdTypeKeyValuesFinder());
		form.setAccountStatusTypeOptionsFinder(getAccountStatusTypeOptionsFinder());
	}
	
	/*
	 * Populates the specified form for a Search Person Account page.
	 */
	private void populateForSearchPersonAccount(AdminForm form) {
		// Populate for New Person Account first:
		populateForNewPersonAccount(form);
		
		// Add additional Search specific info:
		AdminForm.AccountSearchInformation accountSearchInfo = new AdminForm.AccountSearchInformation();
		
		accountSearchInfo.setIsKimAccount(true);
		accountSearchInfo.setLastNameSubstringSearch(true);
		accountSearchInfo.setDobDateRange(new DateRangeValue());
		accountSearchInfo.setLastUpdateDateRange(new DateRangeValue());
		accountSearchInfo.setCreationDateRange(new DateRangeValue());
		accountSearchInfo.setUserPreference(new UserPreference());
		accountSearchInfo.setSearchResultFields(new ArrayList<String>());
		form.setSearchResultFieldsOptionsFinder(getSearchResultFieldsOptionsFinder());
		form.setAccountSearchInfo(accountSearchInfo);
	}
}
