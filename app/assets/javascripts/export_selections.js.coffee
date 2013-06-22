$(document).ready ()->
  $export_options_name_input = $("input#exporter_options_target_object_region_name")
  $export_options_code_input = $("input#exporter_options_target_object_region_code")
  $(".target_object_region #dropdown-of-region-selections").on 'click', "a", ()->
    $export_options_name_input.val $(this).data("name")
    $export_options_code_input.val $(this).data("code")

$(document).ready ()->
  $export_options_name_input = $("input#exporter_options_region_name")
  $export_options_code_input = $("input#exporter_options_region_code")
  $(".crime_region_name #dropdown-of-region-selections").on 'click', "a", ()->
    $export_options_name_input.val $(this).data("name")
    $export_options_code_input.val $(this).data("code")

$(document).ready ()->
  $export_options_name_input = $("input#exporter_options_associated_object_region_name")
  $export_options_code_input = $("input#exporter_options_associated_object_region_code")
  $(".associated_object_region #dropdown-of-region-selections").on 'click', "a", ()->
    $export_options_name_input.val $(this).data("name")
    $export_options_code_input.val $(this).data("code")
