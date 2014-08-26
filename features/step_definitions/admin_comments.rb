And(/^I add a comment to an activity offering$/) do
  @course_offering = (make CourseOffering, :course=>"PHYS272").copy
  @course_offering.initialize_with_actual_values
  @course_offering.get_ao_obj_by_code('A').add_admin_comment :comment_obj => (make AdminCommentObject)
end

And(/^I add a comment to a course offering$/) do
  @course_offering = (make CourseOffering, :course=>"CHEM481").copy
  @course_offering.add_admin_comment :comment_obj => (make AdminCommentObject)
end

Then(/^the activity offering comment.*can be viewed successfully$/) do
  @course_offering.get_ao_obj_by_code('A').manage_comments
  comment = @course_offering.get_ao_obj_by_code('A').admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_created_by(comment_index).should == comment.creator
    page.comment_created_date(comment_index).should == comment.created_date
    page.header_text_comments_count.should == @course_offering.get_ao_obj_by_code('A').admin_comments_list.length
    page.close
  end
  on(ManageCourseOfferings).ao_comments_link_count('A').should == @course_offering.get_ao_obj_by_code('A').admin_comments_list.length
end

And(/^I manage comments for an activity offering with existing comments$/) do
  @course_offering = (make CourseOffering, :course=>"PHYS272").copy
  @course_offering.initialize_with_actual_values
  @course_offering.get_ao_obj_by_code('A').add_admin_comment :comment_obj => (make AdminCommentObject)
end

When(/^I delete an existing comment for the activity offering$/) do
  @course_offering.get_ao_obj_by_code('A').admin_comments_list[0].delete
end

Then(/^the activity offering comment is successfully deleted$/) do
  @course_offering.get_ao_obj_by_code('A').manage_comments
  on AdminComments do |page|
    page.comments_list.length.should == 0
    page.header_text_comments_count.should == 0
    page.close
  end
  on(ManageCourseOfferings).ao_comments_link_count('A').should == 0
end

When(/^I select the delete option for an existing activity offering comment but choose not to confirm the deletion$/) do
  @course_offering.get_ao_obj_by_code('A').admin_comments_list[0].delete :confirm_delete => false
end

When(/^I delete an existing comment for the course offering$/) do
  @course_offering.admin_comments_list[0].delete
end

Then(/^the course offering comment is successfully deleted$/) do
  @course_offering.manage_comments
  on AdminComments do |page|
    page.comments_list.length.should == 0
    page.header_text_comments_count.should == 0
    page.close
  end
  on(ManageCourseOfferings).co_comments_link_count.should == 0
end

When(/^I select the delete option for an existing course offering comment but choose not to confirm the deletion$/) do
  @course_offering.admin_comments_list[0].delete :confirm_delete => false
end


When(/^I edit an existing activity offering comment and save$/) do
  @course_offering.get_ao_obj_by_code('A').admin_comments_list[0].edit :text => "edited text #{random_alphanums(3)}"
end

When(/^I edit an existing course offering comment and save$/) do
  @course_offering.admin_comments_list[0].edit :text => "edited text #{random_alphanums(3)}"
end

When(/^I edit an existing activity offering comment and cancel$/) do
  @course_offering.get_ao_obj_by_code('A').admin_comments_list[0].edit :text => "edited text #{random_alphanums(3)}", :cancel_edit => true
end

When(/^I edit an existing course offering comment and cancel$/) do
  @course_offering.admin_comments_list[0].edit :text => "edited text #{random_alphanums(3)}", :cancel_edit => true
end

Then(/^the course offering comment.*can be viewed successfully$/) do
  @course_offering.manage_comments
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_created_by(comment_index).should == comment.creator
    page.comment_created_date(comment_index).should == comment.created_date
    page.header_text_comments_count.should == @course_offering.admin_comments_list.length
    page.close
  end
  on(ManageCourseOfferings).co_comments_link_count.should == @course_offering.admin_comments_list.length
end

Then(/^the activity offering comment is updated successfully$/) do
  @course_offering.get_ao_obj_by_code('A').manage_comments
  comment = @course_offering.get_ao_obj_by_code('A').admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_edited_by(comment_index).should == comment.last_editor
    page.comment_edited_date(comment_index).should == comment.edited_date
    page.header_text_comments_count.should == @course_offering.get_ao_obj_by_code('A').admin_comments_list.length
    page.close
  end
end

Then(/^the activity offering comment is not updated$/) do
  @course_offering.get_ao_obj_by_code('A').manage_comments
  comment = @course_offering.get_ao_obj_by_code('A').admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_edited_by(comment_index).should == comment.last_editor
    page.comment_edited_date(comment_index).should == comment.edited_date
    page.header_text_comments_count.should == @course_offering.get_ao_obj_by_code('A').admin_comments_list.length
    page.close
  end
end

Then(/^the course offering comment is updated successfully$/) do
  @course_offering.manage_comments
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_edited_by(comment_index).should == comment.last_editor
    page.comment_edited_date(comment_index).should == comment.edited_date
    page.header_text_comments_count.should == @course_offering.admin_comments_list.length
    page.close
  end
end

Then(/^the course offering comment is not updated$/) do
  @course_offering.manage_comments
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_edited_by(comment_index).should == comment.last_editor
    page.comment_edited_date(comment_index).should == comment.edited_date
    page.header_text_comments_count.should == @course_offering.admin_comments_list.length
    page.close
  end
end


And(/^I manage comments for a course offering with existing comments$/) do
  @course_offering = (make CourseOffering, :course=>'CHEM481').copy
  @course_offering.add_admin_comment :comment_obj => (make AdminCommentObject)
end

And(/^I manage comments for an? (?:course|activity) offering in my admin org$/) do
  @course_offering = (make CourseOffering, :course=>'ENGL302').copy
end

Then(/^I am able to add new comments for the activity offering$/) do
  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.get_ao_obj_by_code('A')
  @activity_offering.add_admin_comment :comment_obj => (make AdminCommentObject)

  @activity_offering.manage_comments
  comment = @activity_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_created_by(comment_index).should == comment.creator
    page.comment_created_date(comment_index).should == comment.created_date
    page.header_text_comments_count.should == @activity_offering.admin_comments_list.length
    page.close
  end
end

And(/^I am able to edit comments for the activity offering$/) do
  @activity_offering.admin_comments_list[0].edit :text => "edited text #{random_alphanums(3)}"

  @activity_offering.manage_comments
  comment = @activity_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_edited_by(comment_index).should == comment.last_editor
    page.comment_edited_date(comment_index).should == comment.edited_date
    page.header_text_comments_count.should == @activity_offering.admin_comments_list.length
    page.close
  end
end

And(/^I am able to delete comments for the activity offering$/) do
  @activity_offering.admin_comments_list[0].delete :do_navigation=>true

  @activity_offering.manage_comments
  on AdminComments do |page|
    page.comments_list.length.should == 0
    page.header_text_comments_count.should == 0
    page.close
  end
end

Then(/^I am able to add new admin comments for the course offering$/) do
  @course_offering.add_admin_comment :comment_obj => (make AdminCommentObject)

  @course_offering.manage_comments
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_created_by(comment_index).should == comment.creator
    page.comment_created_date(comment_index).should == comment.created_date
    page.header_text_comments_count.should == @course_offering.admin_comments_list.length
    page.close
  end

end

And(/^I am able to edit comments for the course offering$/) do
  @course_offering.admin_comments_list[0].edit :text => "edited text #{random_alphanums(3)}"

  @course_offering.manage_comments
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_edited_by(comment_index).should == comment.last_editor
    page.comment_edited_date(comment_index).should == comment.edited_date
    page.header_text_comments_count.should == @course_offering.admin_comments_list.length
    page.close
  end
end

And(/^I am able to delete comments for the course offering$/) do
  @course_offering.admin_comments_list[0].delete :do_navigation=>true

  @course_offering.manage_comments
  on AdminComments do |page|
    page.comments_list.length.should == 0
    page.header_text_comments_count.should == 0
    page.close
  end
end

Given(/^there is a course offering with existing comments$/) do
  step "I am logged in as a Schedule Coordinator"
  @course_offering = (make CourseOffering, :course=>'CHEM481').copy
  @course_offering.add_admin_comment :comment_obj => (make AdminCommentObject)
end

Then(/^I am able to view the comments for the course offering$/) do
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_created_by(comment_index).should == comment.creator
    page.comment_created_date(comment_index).should == comment.created_date
    page.header_text_comments_count.should == @course_offering.admin_comments_list.length
  end
end

But(/^I am not able to edit the comments for the course offering$/) do
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.edit_comment_element(comment_index).present?.should be_false
  end
end

And(/^I am not able to delete the comments for the course offering$/) do
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.delete_comment_element(comment_index).present?.should be_false
  end
end

And(/^I am not able to create new comments for the course offering$/) do
  on AdminComments do |page|
    page.add_comment_element.present?.should be_false
    page.close
  end
end

And(/^I manage existing comments for a course offering outside my admin org$/) do
  @course_offering.manage_comments
end

Given(/^there is an activity offering with existing comments$/) do
  step "I am logged in as a Schedule Coordinator"
  @course_offering = (make CourseOffering, :course=>'CHEM481').copy
  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.get_ao_obj_by_code('A')
  @activity_offering.add_admin_comment :comment_obj => (make AdminCommentObject)
end

Then(/^I am able to view the comments for the activity offering$/) do
  comment = @activity_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_text(comment_index).should == comment.text
    page.comment_created_by(comment_index).should == comment.creator
    page.comment_created_date(comment_index).should == comment.created_date
    page.header_text_comments_count.should == @activity_offering.admin_comments_list.length
  end
end

But(/^I am not able to edit the comments for the activity offering$/) do
  comment = @activity_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.edit_comment_element(comment_index).present?.should be_false
  end
end

And(/^I am not able to delete the comments for the activity offering$/) do
  comment = @activity_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.delete_comment_element(comment_index).present?.should be_false
  end
end

And(/^I am not able to create new comments for the activity offering$/) do
  on AdminComments do |page|
    page.add_comment_element.present?.should be_false
    page.close
  end
end

And(/^I manage existing comments for an activity offering outside my admin org$/) do
  @activity_offering.manage_comments
end

When(/^I add a new comment which includes a url hyperlink to a course offering$/) do
  @course_offering = (make CourseOffering, :course=>"CHEM481").copy
  @course_offering.add_admin_comment :comment_obj => (make AdminCommentObject, :hyperlinked_text => 'http://en.wikipedia.org/wiki/Kuali')
end

Then(/^the course offering comment is saved with a working hyperlink$/) do
  @course_offering.manage_comments
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_hyperlink(comment_index).text.should == comment.hyperlinked_text
    page.comment_hyperlink(comment_index).href.should == comment.hyperlinked_text
    page.close
  end
end

Then(/^the activity offering comment is saved with a working hyperlink$/) do
  @course_offering.get_ao_obj_by_code('A').manage_comments
  comment = @course_offering.get_ao_obj_by_code('A').admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_hyperlink(comment_index).text.should == comment.hyperlinked_text
    page.comment_hyperlink(comment_index).href.should == comment.hyperlinked_text
    page.close
  end
  on(ManageCourseOfferings).co_comments_link_count.should == @course_offering.admin_comments_list.length
end

When(/^I edit a comment and add a url hyperlink$/) do
  @course_offering.get_ao_obj_by_code('A').admin_comments_list[0].edit :hyperlinked_text => 'http://accounting.ucdavis.edu/projects/ucdkuali/'
end

When(/^I add a new comment with formatted \(bold\) text to a course offering$/) do
  @course_offering = (make CourseOffering, :course=>"CHEM481").copy
  @course_offering.add_admin_comment :comment_obj => (make AdminCommentObject, :bold_text => 'to boldly go')
end

Then(/^the course offering comment is saved with the typography elements displayed$/) do
  @course_offering.manage_comments
  comment = @course_offering.admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_element(comment_index).p.strong.text.should == comment.bold_text #strong = bold
    page.close
  end
end

When(/^I edit a comment and format \(bold\) some of the text$/) do
  @course_offering.get_ao_obj_by_code('A').admin_comments_list[0].edit :bold_text => 'to go boldly'
end

Then(/^the activity offering comment is saved with the typography elements displayed$/) do
  @course_offering.get_ao_obj_by_code('A').manage_comments
  comment = @course_offering.get_ao_obj_by_code('A').admin_comments_list[0]
  on AdminComments do |page|
    comment_index = page.comment_index_by_text(comment.text)
    page.comment_element(comment_index).p.strong.text.should == comment.bold_text #strong = bold
    page.close
  end
end