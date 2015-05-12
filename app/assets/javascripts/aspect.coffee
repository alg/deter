# Validates that pulled data has correct format and is safe to be
# inserted into the editor. Sanity check.
isValidData = (data) ->
  true

$ ->
  return if $("#experiment_aspects_edit, #experiment_aspects_update").length == 0

  editor = ace.edit("data-editor")
  editor.setTheme("ace/theme/xcode")
  editor.getSession().setMode("ace/mode/xml")
  editor.setShowPrintMargin(false)

  ccEnabledControl  = $("#js-change-control")
  ccUrlField        = $("#change_control_url")
  ccPullButton      = $("#change_control_pull")
  ccPanel           = $(".change-control")
  ccState           = $("#js-state")
  ccEditor          = $("#data-editor")

  ccEditor.show()

  initial =
    data:    editor.getValue()
    enabled: ccEnabledControl.is(":checked")
    url:     ccUrlField.val()

  hasChanged = =>
    initial.data != editor.getValue() or
    initial.enabled != ccEnabledControl.is(":checked") or
    initial.url != ccUrlField.val()

  # update controls state
  updateControls = =>
    ccEnabled = ccEnabledControl.is(":checked")
    editor.setReadOnly(ccEnabled)
    ccUrlField.attr('readonly', !ccEnabled).attr('disabled', !ccEnabled)
    ccPullButton.attr('disabled', !ccEnabled)
    if ccEnabled
      ccPanel.removeClass('hide')
      ccEditor.addClass('read-only')
    else
      ccPanel.addClass('hide')
      ccEditor.removeClass('read-only')
      $("#data_editor").css("background-color", "#fff")
    ccState.text(if ccEnabled then "(view)" else "(edit)")
    
  updateControls()
  ccEnabledControl.on "change", updateControls

  # submitting form
  form = $("form.aspect_form")
  form.on "submit", (e) ->
    e.preventDefault()
    $("input#aspect_data").val(editor.getValue())

    if !hasChanged()
      alert("The aspect is unchanged")

    form[0].submit()

  # on pull, update editor
  ccPullButton.on "click", (e) ->
    e.preventDefault()
    $.ajax
      url: ccUrlField.val()
      success: (data) ->
        if isValidData(data)
          editor.setValue(data)
        else
          alert "Pulled data has invalid format"
      error: (xhr, status, error) ->
        alert "There was a problem pulling data:\n#{error}"
        # console.log error
        # alert 'error'
