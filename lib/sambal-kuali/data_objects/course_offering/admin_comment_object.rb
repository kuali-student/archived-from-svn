class AdminCommentObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :text,
                :hyperlinked_text,
                :bold_text,
                :created_date,
                :creator,
                :last_editor,
                :edited_date,
                :parent_obj

  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :text => "comment text #{random_alphanums(4)}",
        :last_editor => '',
        :edited_date => ''
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def create
    created_by = ''
    created_date = ''
    on AdminComments do |page|
      page.new_comment_field.send_keys @text
      if @hyperlinked_text != nil
        page.new_comment_field.send_keys ' '
        page.new_comment_field.send_keys [:control, 'k']
        page.url_entry.wait_until_present
        page.url_entry.set @hyperlinked_text
        page.url_entry_save.click
      end
      if @bold_text != nil
        page.new_comment_field.send_keys [:control, 'b']
        page.new_comment_field.send_keys @bold_text
        page.new_comment_field.send_keys [:control, 'b']
      end
      page.add_comment
    end
    on AdminComments do |page| #synch to page again
      comment_index = page.comment_index_by_text(@text)
      created_by = page.comment_created_by(comment_index)
      created_date = page.comment_created_date(comment_index)
    end

    @creator = created_by
    @created_date = created_date
  end

  def edit opts={}
    defaults = {
        :do_navigation => true,
        :cancel_edit => false,
        :close_comments_dialog => true
    }
    options = defaults.merge(opts)

    if options[:do_navigation]
      @parent_obj.manage_comments
    end

    comment_index = -1
    on AdminComments do |page|
      comment_index = page.comment_index_by_text(@text)
      page.edit_comment_element(comment_index).click
      page.comment_text_editor(comment_index).wait_until_present
    end

    if options[:text] != nil
      on AdminComments do |page|
        page.comment_text_editor(comment_index).send_keys [:control, 'a'], :delete
        page.comment_text_editor(comment_index).send_keys options[:text]
      end
    end

    if options[:hyperlinked_text] != nil
      on AdminComments do |page|
        page.comment_text_editor(comment_index).send_keys ' '
        page.comment_text_editor(comment_index).send_keys [:control, 'k']
        page.url_entry.wait_until_present
        page.url_entry.set options[:hyperlinked_text]
        page.url_entry_save.click
      end
    end

    if options[:bold_text] != nil
      on AdminComments do |page|
        page.comment_text_editor(comment_index).send_keys [:control, 'b']
        page.comment_text_editor(comment_index).send_keys options[:bold_text]
        page.comment_text_editor(comment_index).send_keys [:control, 'b']
      end
    end

    if  !options[:cancel_edit]
      edited_by = ''
      edited_date = ''
      on AdminComments do |page|
        page.comment_save_edit(comment_index).click
        page.frm.image(alt: "Loading...").wait_while_present #in this case 'loading' icon is in iframe
        sleep 1
        set_options(options)
      end
      on AdminComments do |page|
        comment_index = page.comment_index_by_text(@text)
        @last_editor = page.comment_edited_by(comment_index)
        @edited_date = page.comment_edited_date(comment_index)
      end
    else
      on(AdminComments).comment_cancel_edit(comment_index).click
      sleep 1 #TODO: add proper synch
    end
    on(AdminComments).close if options[:close_comments_dialog]
  end

  def delete opts={}
    defaults = {
        :do_navigation => false,
        :confirm_delete => true,
        :close_comments_dialog => true
    }
    options = defaults.merge(opts)

    if options[:do_navigation]
      @parent_obj.manage_comments
    end

    on AdminComments do |page| #synch to page again
      page.delete_comment(@text, options[:confirm_delete])
      page.close if options[:close_comments_dialog]
    end
    @parent_obj.admin_comments_list.delete(self) if options[:confirm_delete]
  end

end

class AdminCommentCollection < CollectionsFactory
  contains AdminCommentObject

end