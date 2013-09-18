$(document).ready ->
  # enable chosen js
  $('#company_category_ids, #review_category_ids').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '333px'
    max_selected_options: 2

  $("#review_search_ids").chosen
    placeholder_text_multiple: "Search Address Books"
    max_selected_options: 2
    no_results_text: 'No results matched'
    allow_single_deselect: true

  $("#company_category_ids, #review_category_ids, #review_search_ids").bind "chosen:maxselected", ->
    alert "Enter up to 2 things. For example, 'plasterer' and 'paver', for someone who might do both."
