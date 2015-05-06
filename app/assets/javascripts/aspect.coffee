$ ->
  return if $("#experiment_aspects_edit").length == 0

  editor = ace.edit("data_editor")
  editor.setTheme("ace/theme/xcode")
  editor.getSession().setMode("ace/mode/xml")

  form = $("form.aspect_form")
  form.on "submit", (e) ->
    e.preventDefault()

    $("input#aspect_data").val(editor.getValue())
    form[0].submit()
