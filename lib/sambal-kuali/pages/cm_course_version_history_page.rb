class CmCourseVersionHistoryPage < BasePage

  def frm
    self.iframe(class: "fancybox-iframe")
  end

  action(:loading_wait) {|b| b.frm.image(alt: "Loading...").wait_while_present }

  element(:review_versions_button) {|b|b.frm.button(id: "CM-CourseVersion-Button-ShowVersions") }
  action(:show_versions) { |b| b.review_versions_button.click; b.loading_wait }


  element(:version_history_checkbox) { |row, b| b.frm.checkbox(id: "CM-CourseVersions-resultSet-checkbox_line#{row}_control") }
  element(:version_history_version) { |row, b| b.frm.div(id: "CM-CourseVersions-resultSet-version_line#{row}") }
  element(:version_history_courseStatus) { |row, b| b.frm.div(id: "CM-CourseVersions-resultSet-courseStatus_line#{row}") }
  element(:version_history_startTerm) { |row, b| b.frm.div(id: "CM-CourseVersions-resultSet-startTerm_line#{row}") }
  element(:version_history_endTerm) { |row, b| b.frm.div(id: "CM-CourseVersions-resultSet-endTerm_line#{row}") }
  action(:close_history_view) { |b| b.frm.a(id: 'CM-CourseVersion-Footer-Button-Close').click; b.loading_wait }
  action(:close) { |b| b.frm.a(title: "Close").click }

  def select_version_by_index(index)
    if version_history_checkbox(index).exists?
      version_history_checkbox(index).set
    else
      nil
    end
  end

  def deselect_version_by_index(index)
    if version_history_checkbox(index).exists?
      version_history_checkbox(index).clear
    end
  end

end