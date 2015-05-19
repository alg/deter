# Validates that pulled data has correct format and is safe to be
# inserted into the editor. Sanity check.
isValidData = (data) ->
  true

$ ->
  creatingAspect = $("#experiment_aspects_new, #experiment_aspects_create").length > 0
  updatingAspect = $("#experiment_aspects_edit, #experiment_aspects_update").length > 0
  return if !creatingAspect && !updatingAspect

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

  pulledOn = null

  hasChanged = =>
    initial.data != editor.getValue() or
    initial.enabled != ccEnabledControl.is(":checked") or
    initial.url != ccUrlField.val()

  generateStatus = (template, name, time) ->
    template = template.replace("%name", name) if name
    template = template.replace("%time", moment(time).format('MMMM Do YYYY, h:mm a')) if time
    template

  statusLastUpdated    = generateStatus(I18n.t("experiment_aspects.edit.last_updated"), gon.updated_by, gon.updated_at)
  statusEdited         = generateStatus(I18n.t("experiment_aspects.edit.edited"), gon.user_name, null)
  statusEditedNotSaved = I18n.t("experiment_aspects.edit.edited_not_saved")
  statusPulledNotSaved = I18n.t("experiment_aspects.edit.pulled_not_saved")
  statusPulled         = null

  updateStatus = =>
    status = null
    notSaved = null

    if hasChanged()
      if ccEnabledControl.is(":checked") and pulledOn
        status   = statusPulled
        notSaved = statusPulledNotSaved
      else
        status   = statusEdited
        notSaved = statusEditedNotSaved
    else
      status   = statusLastUpdated
      notSaved = null

    $("p.status").html(status)
    $("p.not-saved").html(notSaved)

  # update controls state
  updateControls = =>
    ccEnabled = ccEnabledControl.is(":checked")
    editor.setReadOnly(ccEnabled)
    ccUrlField.attr('readonly', !ccEnabled).attr('disabled', !ccEnabled)
    ccPullButton.attr('disabled', !ccEnabled)
    if ccEnabled
      ccPanel.removeClass('hide')
      ccEditor.addClass('read-only')
      ccEditor.addClass('hide') if creatingAspect
    else
      ccEditor.removeClass('hide') if creatingAspect
      ccPanel.addClass('hide')
      ccEditor.removeClass('read-only')
      $("#data_editor").css("background-color", "#fff")
    ccState.text(if ccEnabled then "(view)" else "(edit)")

    updateStatus()

  updateControls()
  ccEnabledControl.on "change", updateControls
  editor.on "change", updateStatus

  submitForm = ->
    $("input#aspect_data").val(editor.getValue())

    if updatingAspect && !hasChanged()
      alert("The aspect is unchanged")

    form[0].submit()

  # submitting form
  form = $("form.aspect_form")
  form.on "submit", (e) ->
    e.preventDefault()
    if creatingAspect && ccEnabledControl.is(":checked")
      pull
        success: ->
          submitForm()
    else
      submitForm()

  pull = (options = {}) ->
    $.ajax
      url: gon.pull_url
      method: "post"
      data:
        url: ccUrlField.val()
      success: (data) =>
        if isValidData(data)
          pulledOn = new Date()
          statusPulled = generateStatus(I18n.t("experiment_aspects.edit.last_pulled"), gon.user_name, pulledOn)
          editor.setValue(data)
          updateStatus()
          options.success() if options.success
        else
          alert "Pulled data has invalid format"
      error: (xhr, status, error) ->
        alert "There was a problem pulling data:\n#{xhr.responseText}"

  # on pull, update editor
  ccPullButton.on "click", (e) ->
    e.preventDefault()
    pull()
