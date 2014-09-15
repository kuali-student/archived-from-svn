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
        :type => ["doc","docx","gif","gz",
                  "jpg","mp3","pdf","png",
                  "ppt","rar","rtf","tar",
                  "tif","tiff","txt", "wav",
                  "xls", "xml", "zip"
                  ].to_a.sample,
        :file_name => "test_file",
        :description => [random_alphanums(10, "supporting doc description ")," "].to_a.sample,
        :document_level => 1,
        :defer_save => false

    }
    set_options(defaults.merge(opts))

  end

  def create
    view
    on CmSupportingDocumentsPage do |attach|
      attach.add_supporting_doc unless attach.document_select(@document_level).exists?
      file_path = $target_folder+"/"+@file_name+"."+@type
      puts file_path
      puts "Description is #{@description}"
      attach.document_select(@document_level).set file_path
      attach.document_description(@document_level).fit @description
     end
    determine_save_action unless @defer_save
  end

  def view
    on CmCourseInformationPage do |page|
      page.supporting_documents unless page.current_page('Supporting Documents').exists?
    end

  end



  def edit (opts={})
    on CmAuthorsCollaboratorsPage do |attach|
      attach.document_select(opts[:document_level]).set ($file_folder+opts[:file_name]) unless opts[:file_name].nil?
      attach.document_description(opts[:document_level]).fit opts[:description]
    end
    determine_save_action unless opts[:defer_save]
    set_options(opts)
  end



  def delete (opts={})
    view
    on CmSupportingDocumentsPage do |page|
      page.delete(opts[:document_level])
      determine_save_action unless opts[:defer_save]
    end
  end


end


