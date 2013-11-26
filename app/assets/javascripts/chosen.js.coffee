$(document).ready ->
  # enable chosen js

  # when using options limit to 2 options do not work
  # options =
  #   max_selected_options: 2
  #   no_results_text: 'No results matched'
  #   allow_single_deselect: true

  $('#company_category_ids, #review_category_ids').chosen
    placeholder_text_multiple: "Click here to pick a category"
    width: '352px'
    max_selected_options: 2
    no_results_text: 'No results matched'
    allow_single_deselect: true
    enable_split_word_search: true
    search_contains: true



  $("#review_search_ids").chosen
    placeholder_text_multiple: "Search Address Books"
    max_selected_options: 2
    no_results_text: 'No results matchedjyaaa'
    allow_single_deselect: true
    enable_split_word_search: true
    search_contains: true


  $("#company_category_ids, #review_category_ids, #review_search_ids").bind "chosen:maxselected", ->
    alert "Enter up to 2 things. For example, 'plasterer' and 'paver', for someone who might do both."

  # $("#company_category_ids, #review_category_ids, #review_search_ids").bind "chosen:maxselected", ->
  #   alert "Enter up to 2 things. For example, 'plasterer' and 'paver', for someone who might do both."
