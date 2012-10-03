module EmailArchiveFrame

  include PageObject
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

class EmailArchive
  include PageObject
  include EmailArchiveFrame
  include EmailArchiveMethods
end

class EmailArchiveOptions
  include PageObject
  include EmailArchiveFrame
  include EmailArchiveOptionsMethods
end