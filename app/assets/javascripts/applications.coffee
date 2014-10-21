# Localized errors
class I18nErrors
  constructor: (base) -> @base = base
  t: (key) -> I18n.t("#{@base}.#{key}")

# Application form
class ApplicationForm
  constructor: ->
    @initInfoPage()
    @initUserTypePage()
    @initNewUserPage()

  # Info page

  initInfoPage: ->
    @infoApply  = ko.observable(false)
    @infoAccept = ko.observable(false)

    @ipe = new I18nErrors("page_info.errors")
    @infoPageErrors = ko.computed =>
      errors = []
      errors.push(@ipe.t("apply")) if !@infoApply()
      errors.push(@ipe.t("accept")) if !@infoAccept()
      errors

    @infoPageInvalid = ko.computed =>
      @infoPageErrors().length > 0

    new Popover('#page-info .next-btn', @infoPageErrors)



  # User type page

  initUserTypePage: ->
    @userType = ko.observable(null)

    @utr = new I18nErrors("page_user_type.errors")
    @userTypePageErrors = ko.computed =>
      errors = []
      errors.push(@utr.t("user_type")) if !@userType()
      errors

    @userTypePageInvalid = ko.computed =>
      @userTypePageErrors().length > 0

    new Popover('#page-user-type .next-btn', @userTypePageErrors)


  # User details page

  initNewUserPage: ->
    @full_name = ko.observable()
    @email     = ko.observable()
    @phone     = ko.observable()
    @position  = ko.observable()
    @affiliate = ko.observable()
    @abbrev    = ko.observable()
    @website   = ko.observable()
    @username  = ko.observable()
    @password  = ko.observable()
    @password_confirmation = ko.observable()

    @address_1 = ko.observable()
    @address_2 = ko.observable()
    @city      = ko.observable()
    @state     = ko.observable()
    @zip       = ko.observable()
    @country   = ko.observable()

    @udr = new I18nErrors("page_new_user.project_leader.errors")
    @newUserPageErrors = ko.computed =>
      errors = []
      errors.push(@udr.t("full_name")) if !filled(@full_name())
      errors.push(@udr.t("email")) if !filled(@email())
      errors.push(@udr.t("phone")) if !filled(@phone())
      errors.push(@udr.t("position")) if !filled(@position())
      errors.push(@udr.t("affiliate")) if !filled(@affiliate())
      errors.push(@udr.t("abbrev")) if !filled(@abbrev())
      errors.push(@udr.t("website")) if !filled(@website())
      errors.push(@udr.t("username")) if !filled(@username())
      errors.push(@udr.t("password")) if !filled(@password())
      errors.push(@udr.t("password_confirmation")) if !filled(@password_confirmation()) or @password() != @password_confirmation()
      errors.push(@udr.t("postal_address")) if !filled(@address_1()) or !filled(@address_2()) or !filled(@city()) or !filled(@state()) or !filled(@zip) or !filled(@country)
      errors

    @newUserPageInvalid = ko.computed =>
      @newUserPageErrors().length > 0

    new Popover('#page-new-user .next-btn', @newUserPageErrors)



  # Navigation

  showInfoPage:        (e) => @showPage "page-info", e
  showUserTypePage:    (e) => @showPage "page-user-type", e
  showNewUserPage:     (e) => @showPage "page-new-user", e
  showProjectInfoPage: (e) => @showPage "page-project-info", e

  showPage: (page_id, e) ->
    return if e && $(e.target).hasClass('disabled')
    $(".page").hide()
    $("##{page_id}").show()

$ ->
  return if $("#new_application").length == 0

  ko.applyBindings new ApplicationForm()
