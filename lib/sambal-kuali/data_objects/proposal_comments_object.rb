class CmCommentsObject < CmBaseObject

  attr_accessor  :commentText, :index




  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        index: 0,
        commentText: random_alphanums(10,'test proposal comment '),
    }
    set_options(defaults.merge(opts))
  end

  def create
    on CmProposalCommentsPage do |page|
      page.comment_text_input.set @commentText
      page.add_comment
      page.loading_wait
    end
  end

  def edit (opts={})
    on CmProposalCommentsPage do |page|
      page.edit_comment(opts[:index])
      if(page.alert.exists?)
        page.alert.ok
      end
      page.edit_comment_text_field(opts[:index]).set opts[:commentText]
      page.save_edited_comment(opts[:index])
      sleep 1
    end
    set_options(opts)
  end



  def delete (opts={})
    on CmProposalCommentsPage do |page|
      page.delete_comment(opts[:index])
      if(page.alert.exists?)
        page.alert.ok
      end
    end
  end

  def close_comment_dialog()
    on CmProposalCommentsPage do |page|
      page.close.wait_until_present(60)
      page.close_dialog
      page.loading_wait
    end
    sleep 1
  end
end