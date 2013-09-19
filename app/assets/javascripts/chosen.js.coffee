$(document).ready ->
  # enable chosen js

  options =
    max_selected_options: 2
    no_results_text: 'No results matched'
    allow_single_deselect: true

  $('#company_category_ids, #review_category_ids').chosen
    width: '333px'
    options

  $("#review_search_ids").chosen
    placeholder_text_multiple: "Search Address Books"
    options

  $("#company_category_ids, #review_category_ids, #review_search_ids").bind "chosen:maxselected", ->
    alert "Enter up to 2 things. For example, 'plasterer' and 'paver', for someone who might do both."
