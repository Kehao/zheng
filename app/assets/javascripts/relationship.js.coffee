window.Relationship = Relationship =
  options:
    addToggle:                 ".add-relationship-container .add-relationship-toggle"
    relationshipFormContainer: ".add-relationship"
    errorContainer:            ".add-relationship .errors"
    cancelBtn:                 ".add-relationship .cancel"
    holdPercent:               ".hold-percent-wrapper"
    relationshipDate:          ".relationship-date"

  showError: (errors) ->
    error_htmls = ("<p>" + error + "</p>" for error in errors)
    @errorContainer.html error_htmls.join ""

  clearError: ->
    @errorContainer.empty()

  hideRelationshipFormContainer: ->
    @relationshipFormContainer.slideUp(350)

  appendData: (data) ->
    $("#company-relationship table").append data.html

  successCallback: (data)->
    if data.result is "success"
      @clearError()
      # @hideRelationshipFormContainer()
      @appendData(data)
    else
      @showError(data.error)

  errorCallback: ->
    alert "系统出错"

  init: ->
    @addToggle                 = $(@options.addToggle)
    @relationshipFormContainer = $(@options.relationshipFormContainer)
    @errorContainer            = $(@options.errorContainer)
    @cancelBtn                 = $(@options.cancelBtn)

    # 初始<添加>按钮事件
    @addToggle.click (e) =>
      @relationshipFormContainer.slideToggle(350)

    # 初始<取消>按钮事件
    @cancelBtn.click (e) =>
      @hideRelationshipFormContainer()

    # 初始"relate_type"改变事件
    @relationshipFormContainer.find("form .relate_type_input").change (e) =>
      $this = $(e.target)
      $form = $this.closest("form")
      if $this.val() is "shareholder"
        $form.find(@options.holdPercent).show()
      else
        $form.find(@options.holdPercent).hide()

    @relationshipFormContainer.find("form .relate_type_input").change (e) =>
      $this = $(e.target)
      $form = $this.closest("form")
      relationships = ["guarantee","guarantor","debtor","creditor"] 
      selected = $this.children("option:selected").val() 
      if selected in relationships
        $form.find(@options.relationshipDate).show()
      else  
        $form.find(@options.relationshipDate).hide()

    # 初始relationshi添加表单提交事件
    @relationshipFormContainer.find("form").submit (e) =>
      e.preventDefault()

      $form = $(e.target)

      url = $form.attr "action"

      $.ajax
        type:     "POST"
        url:      url
        data:     $form.serialize()
        success:  (data) =>
          @successCallback data
        error:    (data) =>
          @errorCallback data
        dataType: "json"

    # 初始relationship table中的<删除>事件
    $("#company-relationship table tr").deletable({toggle: ".operate a", delegateTo: "#company-relationship table", deleteItem: "tr"});
