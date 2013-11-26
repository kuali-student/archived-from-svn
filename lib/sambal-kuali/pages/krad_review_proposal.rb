class KradReviewProposal < BasePage

  wrapper_elements
  krad_elements

  action(:submit) { |b| b.button(text: 'Submit').click; b.loading_wait }

end