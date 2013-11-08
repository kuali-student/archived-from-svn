class KradRice < BasePage

  element(:krad_curriculum_management_element) { |b| b.div(id: 'KS-StudentHome-CurriculumManagementKrad') }
  action(:krad_curriculum_management) { |b| b.krad_curriculum_management_element.click }

end



