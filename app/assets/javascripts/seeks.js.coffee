$(document).ready ()->

  ## 当用户点击 检索输入框上方的nav时，设置对应的隐藏参数value和激活相应的css；
  $('.seek-categories').on 'click', 'a', (e)->
    e.preventDefault()
    $(this).parent('.seek-category').addClass('active').siblings('.seek-category').removeClass('active')
    $('#seek_content_category').val $(this).data('link2')

  $('.seeks-list').on 'mouseenter', '.one-seek', ()->
    $(this).find('.seek-del').css("display", "block")
  $('.seeks-list').on 'mouseleave', '.one-seek', ()->
    $(this).find('.seek-del').css("display", "none")

  $('.seek-tips-link2-person').hide()
  $(".seek-category-link2-company").click ()->
    $(".seek-tips-link2-person").hide()
    $(".seek-tips-link2-company").show()

  $(".seek-category-link2-person").click ()->
    $(".seek-tips-link2-person").show()
    $(".seek-tips-link2-company").hide()