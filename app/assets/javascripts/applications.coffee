class ApplicationForm
  constructor: ->
    @initInfoPage()
    @initUserTypePage()

  # Info page

  initInfoPage: ->
    @infoApply  = ko.observable(false)
    @infoAccept = ko.observable(false)

  infoPageErrors: ->
    errors = []
    errors

  infoPageValid: => @infoPageErrors().length == 0


  # Navigation
  
  showInfoPage:     (e) => @showPage "page-info", e
  showUserTypePage: (e) => @showPage "page-user-type", e

  showPage: (page_id, e) ->
    return if e && $(e.target).hasClass('disabled')
    $(".page").hide()
    $("##{page_id}").show()

$ ->
  return if $("#new_application").length == 0

  ko.applyBindings new ApplicationForm()
