class CmSupportingDocuments < BasePage

  wrapper_elements
  cm_elements

  element(:supporting_doc_section) { |b| b.div(id: "KS-SupportingDocuments-Section") }
  action(:add_supporting_doc) { |b| b.div(id: "KS-SupportingDocuments-Section").button(id:"document-addline").click; b.loading_wait }
  element(:document_select) { |document_level,b| b.supporting_doc_section.file_field(name: "document.newMaintainableObject.dataObject.documentsToAdd[#{document_level-1}].documentUpload") }
  element(:document_description) { |document_level,b| b.supporting_doc_section.text_field(name: "document.newMaintainableObject.dataObject.documentsToAdd[#{document_level-1}].description") }

end