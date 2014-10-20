class ApplicationForm
  constructor: ->
    @initInfoPage()
    @initUserTypePage()

  # Info page

  initInfoPage: ->
    @infoApply  = ko.observable(false)
    @infoAccept = ko.observable(false)

    @infoPageErrors = ko.computed =>
      errors = []
      errors.push(I18n.t("page_info.errors.apply")) if !@infoApply()
      errors.push(I18n.t("page_info.errors.accept")) if !@infoAccept()
      errors

    @infoPageInvalid = ko.computed =>
      @infoPageErrors().length > 0

    new Popover('#page-info .next-btn', @infoPageErrors)



  # User type page

  initUserTypePage: ->
    console.log "utp"

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