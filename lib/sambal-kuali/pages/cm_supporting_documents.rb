class CmSupportingDocumentsPage < BasePage

  wrapper_elements
  cm_elements

  element(:supporting_doc_section) { |b| b.div(id: "CM-Proposal-Course-SupportingDocuments-Section") }
  action(:add_supporting_doc) { |b| b.button(id: "CM-Proposal-Course-AddSupportingDocument").click; b.loading_extended_wait }
  element(:document_select) { |document_level,b| b.supporting_doc_section.file_field(name: "document.newMaintainableObject.dataObject.supportingDocs[#{document_level-1}].documentUpload") }
  element(:document_description) { |document_level,b| b.supporting_doc_section.textarea(name: "document.newMaintainableObject.dataObject.supportingDocs[#{document_level-1}].description") }
  action(:delete) { |document_level,b| b.supporting_doc_section.a(id: /line#{document_level-1}/, title: "Delete").click; b.loading_extended_wait }
end