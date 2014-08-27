class CmAuthCollaboratorObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Utilities

  attr_accessor  :name,
                 :look_value,
                 :permission,
                 :action_required,
                 :author_notation,
                 :author_level,
                 :auto_lookup,
                 :defer_save




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :name => "CLIVE",
        :permission => "View",
        :action_required => "FYI",
        :author_notation => :set,
        :author_level => 1,
        :auto_lookup => true,
        :defer_save => false
    }
    set_options(defaults.merge(opts))

  end

  def create
    on CmAuthorsCollaborators do |page|
      page.authors_collaborators unless page.current_page('Authors & Collaborators').exists?
      page.add_person unless page.author_name(@author_level).exists?
      page.author_name(@author_level).set @lookup_value unless @lookup_value.nil?
      page.author_name(@author_level).set @name if @lookup_value.nil?
      page.auto_lookup @name if @auto_lookup
      page.action_required(@author_level).pick! @action_required
      page.loading_wait
      page.author_permission(@author_level).wait_until_present
      page.author_permission(@author_level).select @permission
      page.author_notation(@author_level).fit @author_notation if @author_notation == :set
    end
    determine_save_action unless @defer_save
  end





  def edit (opts={})
    on CmAuthorsCollaborators do |page|
      page.authors_collaborators unless page.current_page('Authors & Collaborators').exists?
      page.add_person unless page.author_name(opts[:author_level]).exists?
      page.author_name(opts[:author_level]).set opts[:name] unless opts[:name].nil?
      page.auto_lookup(opts[:name]) if opts[:auto_lookup]
      page.author_permission(opts[:author_level]).pick! opts[:permission]
      page.author_notation(opts[:author_level]).fit opts[:author_notation]
    end
    determine_save_action unless opts[:defer_save]
    set_options(opts)
  end



  def delete (opts={})
    on CmAuthorsCollaborators do |page|
      page.authors_collaborators unless page.current_page('Authors & Collaborators').exists?
      page.delete_author(opts[:author_level])
    end
    determine_save_action unless opts[:defer_save]
  end


  end


