module SyllabusFrame
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # The frame object that contains all of the CLE Tests and Quizzes objects
  def frm
    self.frame(:src=>/TBD/)
  end

end

class Syllabus
  include PageObject
  include SyllabusFrame
  include SyllabusMethods
end

class SyllabusEdit
  include PageObject
  include SyllabusFrame
  include SyllabusEditMethods
end

class AddEditSyllabusItem
  include PageObject
  include SyllabusFrame
  include AddEditSyllabusItemMethods
end

class SyllabusPreview
  include PageObject
  include SyllabusFrame
  include SyllabusPreviewMethods
end

class SyllabusRedirect
  include PageObject
  include SyllabusFrame
  include SyllabusRedirectMethods
end

class DeleteSyllabusItems
  include PageObject
  include SyllabusFrame
  include DeleteSyllabusItemsMethods
end

class CreateEditSyllabus
  include PageObject
  include SyllabusFrame
  include CreateEditSyllabusMethods
end