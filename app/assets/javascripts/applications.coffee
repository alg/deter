class ApplicationForm
  constructor: ->
    @initInfoPage()
    @initUserTypePage()
    @initUserDetailsPage()

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
    @userType = ko.observable(null)

    @userTypePageErrors = ko.computed =>
      errors = []
      errors.push(I18n.t("page_user_type.errors.user_type")) if !@userType()
      errors

    @userTypePageInvalid = ko.computed =>
      @userTypePageErrors().length > 0

    new Popover('#page-user-type .next-btn', @userTypePageErrors)


  # User details page

  initUserDetailsPage: ->
    @userDetailsPageErrors = ko.computed =>
      errors = []
      errors

    @userDetailsPageInvalid = ko.computed =>
      @userDetailsPageErrors().length > 0

    new Popover('#page-user-details .next-btn', @userDetailsPageErrors)



  # Navigation

  showInfoPage:        (e) => @showPage "page-info", e
  showUserTypePage:    (e) => @showPage "page-user-type", e
  showUserDetailsPage: (e) => @showPage "page-user-details", e
  showProjectInfoPage: (e) => @showPage "page-project-info", e

  showPage: (page_id, e) ->
    return if e && $(e.target).hasClass('disabled')
    $(".page").hide()
    $("##{page_id}").show()

$ ->
  return if $("#new_application").length == 0

  ko.applyBindings new ApplicationForm()
