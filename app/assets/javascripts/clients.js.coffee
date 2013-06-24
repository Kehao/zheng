$(document).ready ()->
  $('.export_btn').on 'click', ()->
    $(this).button("loading")

  $('.company-clients-list table').on 'mouseenter', '.one-company-in-tr', ()->
    $(this).find('.company-operations > a').css("display", "block")
  $('.company-clients-list table').on 'mouseleave', '.one-company-in-tr', ()->
    $(this).find('.company-operations > a').css("display", "none")

