class BasePage < PageFactory

  class << self

    # COMMENTED CODE OUT, I WAS NOT SURE IF NEEDED FOR NORMAL CM SO KEPT, BUT NOT NEEDED FOR KRAD
    # COMMENTED CODE OUT, I WAS NOT SURE IF NEEDED FOR NORMAL CM SO KEPT, BUT NOT NEEDED FOR KRAD
    # COMMENTED CODE OUT, I WAS NOT SURE IF NEEDED FOR NORMAL CM SO KEPT, BUT NOT NEEDED FOR KRAD

    def wrapper_elements
      #element(:logout_el) { |b| b.link(text: "Logout") }
      #action(:logout) { |b| b.logged_in_link.click; b.logout_el.click }
      #
      #action(:enrollment_via_breadcrumb) { |b| b.link(id: "KS-HomewardPathBreadcrumbs-Enrollment").click }
      #action(:home) { |b| b.frm.link(id: "KS-HomewardPathBreadcrumbs-Home").click }
      #
      #action(:action_list) { |b| b.link(title: "Action List").click }
      element(:logged_in_link) { |b| b.div(class: "ks-uif-viewHeader-container navbar-inverse navbar").link(class: "dropdown-toggle") }
      value(:logged_in_user) { |b| b.div(class: "ks-uif-viewHeader-container navbar-inverse navbar").link(class: "dropdown-toggle").text }

      element(:loading) { |b| b.image(alt: "Loading...") }
      #element(:adding) { |b| b.frm.image(alt: "Adding Line...") }

      element(:growl_div) { |b| b.div(id: "jGrowl") }
      element(:growl_message_div) { |b| b.growl_div.div(class: "jGrowl-message") }
      value(:growl_text) { |b| b.growl_message_div.wait_until_present; b.growl_message_div.text }

      action(:cm_home_via_breadcrumb) { |b| b.a(id: "KS-HomewardPathBreadcrumbs-CurriculumManagement").click; b.loading_wait }
      action(:functional_home_via_breadcrumb) { |b| b.a(id: "KS-HomewardPathBreadcrumbs-Home").click; b.loading_wait }

    end

    #def frame_element
    #  #element(:frm) { |b| b.frame(id: "iframeportlet") }
    #  element(:frm) { |b| b } #with iframe removed
    #end
    #
    #def green_search_buttons
    #  action(:search) { |b| b.frm.button(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!
    #  action(:clear_values) { |b| b.frm.button(text: "Clear Values").click; b.loading.wait_while_present } # Persistent ID needed!
    #  action(:cancel) { |b| b.frm.button(text: "Cancel").click; b.loading.wait_while_present } # Persistent ID needed!
    #  action(:close) { |b| b.frm.button(text: "Close").click; b.loading.wait_while_present } # Persistent ID needed!
    #end
    #
    #def validation_elements
    #  value(:error_header) { |b| b.frm.h3(id: "pageValidationHeader").text }
    #  value(:info_header) { |b| b.frm.h3(id: "pageValidationHeader").text }
    #  element(:error_list) { |b| b.frm.ul(id: "pageValidationList") }
    #  element(:info_list) { |b| b.frm.ul(id: "pageValidationList") }
    #  value(:first_error) { |b| b.error_list.link.text }
    #  value(:first_msg) { |b| b.info_list.li.text }
    #  element(:auth_error) { |b| b.error_list.li(text: /(:?You cannot access|You are not authorized)/) }
    #end
    #
    #def krms_frame_elements
    #  #element(:frm) { |b| b.frame(:id=>/easyXDM_default\d+_provider/).frame(id: "iframeportlet") }
    #  element(:frm) { |b| b }
    #  element(:frm_popup) { |b| b.frame(:class=>"fancybox-iframe")}
    #end

    def cm_elements

      links('Course Information', 'Governance', 'Course Logistics',
             'Learning Objectives', 'Course Requisites', 'Active Dates', 'Financials', 'Authors & Collaborators', 'Supporting Documents')
      action(:authors_collaborators) { |b| b.link(text: 'Authors & Collaborators').click }

      action(:current_page) {|link_text, b| b.li(class: 'uif-navigationItem uif-navigationItem-current').link(text: "#{link_text}")}

      element(:adding_line) { |b| b.image(alt: "Adding Line...") }
      element(:saving) { |b| b.image(alt: "Saving...") }
      element(:deleting_line) { |b| b.image(alt: "Deleting Line...") }

      action(:loading_wait) {|b| b.image(alt: "Loading...").wait_while_present }
      action(:loading_extended_wait) {|b| b.image(alt: "Loading...").wait_while_present(90) }
      action(:adding_line_wait) {|b| b.adding_line.wait_while_present }
      action(:deleting_line_wait) { |b| b.deleting_line.wait_while_present }
      action(:saving_wait) { |b| b.saving.wait_while_present }
      action(:save_progress) { |b| b.button(text: "Save Progress").click }
      element(:approve_and_activate_button) { |b| b.button(text: "Approve and Activate") }
      element(:approve_and_activate_disabled) { |b| b.button(text: "Approve and Activate", class: /disabled/) }
      action(:approve_and_activate) { |b| b.approve_and_activate_button.click }
      action(:cancel_action) { |b| b.link(id: "CM-Proposal-Course-View-Cancel").click; b.loading.wait_while_present }
      element(:cancel_proposal_button) { |b| b.div(id: "CM-Proposal-Course-Create-RightHeader").link(title: "Cancel Proposal") }
      action(:cancel_proposal) { |b| b.cancel_proposal_button.click; b.loading.wait_while_present }
      action(:confirm_cancel_proposal) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Confirm").click; b.loading.wait_while_present }
      element(:review_proposal_element) { |b| b.a(id: "CM-Proposal-Course-ReviewProposalLink") }
      action(:review_proposal) { |b| b.review_proposal_element.click; b.loading_wait }
      element(:approve_and_retire_button) { |b| b.button(text: "Approve and Retire") }
      element(:approve_and_retire_disabled) { |b| b.button(text: "Approve and Retire", class: /disabled/) }
      action(:approve_and_retire) { |b| b.approve_and_retire_button.click }

      element(:save_continue) { |b| b.button(id: 'usave') }
      action(:save_and_continue) { |b| b.save_continue.click; b.saving_wait }

      # For Auto Lookup drop down that appears in KRAD
      action(:auto_lookup) { |lookup_results, b| b.link(text: /#{lookup_results}/).when_present.click}

      #ADVANCED SEARCH BOXES
      action(:advanced_search) { |b| b.link(text: 'Advanced Search').click; b.adv_search_button.wait_until_present}
      #Course Information:  Joint Offering
      element(:adv_search_by) { |b| b.frame(class: 'fancybox-iframe').select_list(name: 'lookupCriteria[searchBy]') }
      element(:adv_given_name) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[courseTitle]') }
      element(:adv_course_code) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[courseCode]') }
      element(:adv_plain_text_description) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[descr.plain]') }

      element(:adv_course_title) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[title]') }
      element(:adv_course_code_rule) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[code]') }
      element(:adv_plain_text_description_rule) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[description]') }

      action(:adv_return_value) { |title_return_value, b| b.frame(class: 'fancybox-iframe').link(title: 'return value ='+"#{title_return_value}").click; b.loading_wait }

      #Course Information: Instructor
      element(:adv_name) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[displayName]') }
      element(:adv_username) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[personId]') }
      element(:adv_username_capD){ |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[personID]') }

      action(:adv_return_value_instructor) { |title_return_value, b| b.frame(class: 'fancybox-iframe').link(title: 'return value Name='+"#{title_return_value}").click; b.loading_wait }
      action(:adv_return_value_name) { |title_return_value, b| b.frame(class: 'fancybox-iframe').link(title: 'return value Name='+"#{title_return_value}").click; b.loading_wait }

      #Governance: Administering Org
      element(:adv_identifier) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[id]') }
      element(:adv_org_name) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[organizationName]') }
      element(:adv_abbreviation) { |b| b.frame(class: 'fancybox-iframe').text_field(name: 'lookupCriteria[abbreviation]') }

      action(:adv_admin_org_return_value) { |org_name, org_abbr, b | b.frame(class: 'fancybox-iframe').link(title: 'return value Name=' + "#{org_name}" + ' Abbreviation=' + "#{org_abbr}").click; b.loading_wait }

      element(:adv_search_button) { |b| b.frame(class: 'fancybox-iframe').button(id: 'button_search') }
      action(:adv_search) { |b| b.adv_search_button.click; b.loading_wait }
      action(:adv_clear_values) { |b| b.frame(class: 'fancybox-iframe').button(id: 'button_clearValues').click }
      action(:adv_close) { |b| b.frame(class: 'fancybox-iframe').button(id: 'button_close').click }

      action(:adv_x) { |b| b.div(class: 'fancybox-item fancybox-close').click }

      value(:page_validation_text) { |b| b.ul(id: "pageValidationList").text }
      value(:page_header_text) { |b| b.header(id: "CM-Proposal-Course-Create-Header").span(class: "uif-headerText-span").text }

      #element(:search_results_table) {|b| b.frame(class: 'fancybox-iframe').div(class: 'dataTables_wrapper').table }
      value(:page_validation_header) { |b| b.div(id: "CM-Proposal-Course-Create-Page_messages").h3(id: "pageValidationHeader").text }
      value(:review_proposal_error) { |b| b.p(id: "CM-Proposal-Review-Error-Message").text }

      element(:comments_link) {|b|b.div(id: "CM-Proposal-Course-Create-RightHeader").a(title: "Comments")}
      element(:decisions_link) {|b|b.div(id: "CM-Proposal-Course-Create-RightHeader").a(title: "Decisions")}
      element(:copy_proposal_icon) {|b|b.a(title: "Copy to New Proposal")}
      action(:load_comments) { |b| b.comments_link.i(class: "ks-fontello-icon-comment" ).click }
      action(:load_decisions) { |b| b.decisions_link.i(class: "ks-fontello-icon-hammer" ).click }
      action(:copy_proposal) {|b|b.copy_proposal_icon.i(class: "ks-fontello-icon-docs" ).click}

      # Export
      element(:export_icon) {|b|b.a(title: "Export").i(class: "ks-fontello-icon-export" )}
      action(:export_action) {|b|b.export_icon.click }
      element(:export_as_pdf_link) { |b| b.a(id: "CM-ExportAction-PDF")}
      element(:export_as_doc_link) { |b| b.a(id: "CM-ExportAction-DOC")}

      #Print
      element(:print_icon) {|b|b.a(title: "Print").i(class: "ks-fontello-icon-print")}

      #Version
      element(:modify_button) {|b|b.button(id: "CM-VersionHistory-ModifyButton")}
      action(:modify_course) { |b| b.modify_button.click;  b.loading_wait }
      element(:version_history_button) {|b|b.button(id: "CM-VersionHistory-Button")}
      action(:lookup_version_history) { |b| b.version_history_button.click }

    end

    def links(*links_text)
      links_text.each { |link| elementate(:link, link) }
    end

    def damballa(text)
      StringFactory::damballa(text)
    end

    def elementate(type, text)
      identifiers={:link=>:text, :button=>:value}
      el_name=damballa("#{text}_#{type}")
      act_name=damballa(text)
      element(el_name) { |b| b.send(type, identifiers[type]=>text) }
      action(act_name) { |b| b.send(type, identifiers[type]=>text).click }
    end

  end #class self end
end
