$(document).ready ()->
  $('.add-cr-prompt').click ()->
    $('.add-cr-box').toggle()
    $('.add-pr-box').hide()
  $('.add-pr-prompt').click ()->
    $('.add-pr-box').toggle()
    $('.add-cr-box').hide()

  $('.add-cr-box form').validate()

  # =======================================================
  # 使companyclient-show页面中的法务信息,能根据用户点击表头,执行情况和归属者来筛选
  $('.show-co-all-crimes-link').removeClass "gray-link"
  $('.show-ci-all-crimes-link').removeClass "gray-link"

  $('.show-company-crimes-link').click ()->
    $(this).removeClass "gray-link"
    $('.show-owner-crimes-link').addClass "gray-link"
    $('.show-co-all-crimes-link').addClass "gray-link"
    $(".crime").each (index)->
      if $(this).data("belongs") isnt "company"
        $(this).addClass "invisible-co-filter"
      else
        $(this).removeClass "invisible-co-filter"

  $('.show-owner-crimes-link').click ()->
    $(this).removeClass "gray-link"
    $('.show-company-crimes-link').addClass "gray-link"
    $('.show-co-all-crimes-link').addClass "gray-link"
    $(".crime").each (index)->
      if $(this).data("belongs") isnt "owner"
        $(this).addClass "invisible-co-filter"
      else
        $(this).removeClass "invisible-co-filter"

  $('.show-co-all-crimes-link').click ()->
    $('.show-owner-crimes-link').addClass "gray-link"
    $('.show-company-crimes-link').addClass "gray-link"
    $(this).removeClass "gray-link"
    $(".crime").each (index)->
      $(this).removeClass "invisible-co-filter"
  # ====================================================
  $('.show-closed-crimes-link').click ()->
    $(this).removeClass "gray-link"
    $('.show-ing-crimes-link').addClass "gray-link"
    $('.show-ci-all-crimes-link').addClass "gray-link"
    $(".crime").each (index)->
      if $(this).data("state") isnt "closed"
        $(this).addClass "invisible-ci-filter"
      else
        $(this).removeClass "invisible-ci-filter"

  $('.show-ing-crimes-link').click ()->
    $(this).removeClass "gray-link"
    $('.show-closed-crimes-link').addClass "gray-link"
    $('.show-ci-all-crimes-link').addClass "gray-link"
    $(".crime").each (index)->
      if $(this).data("state") isnt "processing"
        $(this).addClass "invisible-ci-filter"
      else
        $(this).removeClass "invisible-ci-filter"

  $('.show-ci-all-crimes-link').click ()->
    $(this).removeClass "gray-link"
    $('.show-ing-crimes-link').addClass "gray-link"
    $('.show-closed-crimes-link').addClass "gray-link"
    $(".crime").each (index)->
      $(this).removeClass "invisible-ci-filter"
  # =======================================================
  # =======================================================

  $('.badge-link').each (i)->
    href = $(this).closest('tr').find('.compay-name-in-list > a').attr('href')
    $(this).attr('href', href)