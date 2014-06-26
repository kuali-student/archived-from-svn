class CmSupportingDocsObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor :type,
                :file_name,
                :status,
                :description,
                :document_level





  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :type => "pdf",
        :file_name => "price_list.pdf",
        :description => "Price List Details",
        :document_level => 1

    }
    set_options(defaults.merge(opts))

  end

  def create
    view
    on CmSupportingDocuments do |attach|
      attach.add_supporting_doc unless attach.document_select(@document_level).exists?
      attach.document_select(@document_level).set ($file_folder+@file_name)
      attach.document_description(@document_level).fit @description
    end
    determine_save_action unless @defer_save
  end

  def view
    on CmCourseInformation do |page|
      page.supporting_documents unless page.current_page('Supporting Documents').exists?
    end

  end



  def edit (opts={})
    on CmAuthorsCollaborators do |attach|
      attach.document_select(opts[:document_level]).set ($file_folder+opts[:file_name]) unless opts[:file_name].nil?
      attach.document_description(opts[:document_level]).fit opts[:description]
    end
    determine_save_action unless opts[:defer_save]
    set_options(opts)
  end



  def delete

  end


end


