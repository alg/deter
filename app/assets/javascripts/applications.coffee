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
    @initProjectInfoPage()

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

    @infoPageInvalid = ko.computed => @infoPageErrors().length > 0

    new Popover('#page-info .next-btn', @infoPageErrors)



  # User type page

  initUserTypePage: ->
    @userType = ko.observable(null)

    @utr = new I18nErrors("page_user_type.errors")
    @userTypePageErrors = ko.computed =>
      errors = []
      errors.push(@utr.t("user_type")) if !@userType()
      errors

    @userTypePageInvalid = ko.computed => @userTypePageErrors().length > 0

    new Popover('#page-user-type .next-btn', @userTypePageErrors)


  # New user page

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

    @nur = new I18nErrors("page_new_user.project_leader.errors")
    @newUserPageErrors = ko.computed =>
      errors = []
      if !filled(@full_name()) or !filled(@email()) or !filled(@phone()) or !filled(@position()) or !filled(@affiliate()) or !filled(@abbrev()) or !filled(@website()) or
         !filled(@username()) or !filled(@password()) or !filled(@password_confirmation()) or @password() != @password_confirmation() or
         !filled(@address_1()) or !filled(@address_2()) or !filled(@city()) or !filled(@state()) or !filled(@zip) or !filled(@country)
        errors.push(@nur.t("all_fields"))
      errors

    @newUserPageInvalid = ko.computed => @newUserPageErrors().length > 0

    new Popover('#page-new-user .next-btn', @newUserPageErrors)


  # Project info page

  initProjectInfoPage: ->
    @project_name           = ko.observable()
    @project_plan           = ko.observable()
    @project_id             = ko.observable()
    @project_website        = ko.observable()
    @project_org_type       = ko.observable()
    @project_research_focus = ko.observable()
    @project_funding        = ko.observable()
    @project_listing        = ko.observable()

    @pir = new I18nErrors("page_project_info.errors")
    @projectInfoPageErrors = ko.computed =>
      errors = []
      if !filled(@project_name()) or !filled(@project_plan()) or !filled(@project_id()) or
         !filled(@project_website()) or !filled(@project_org_type()) or !filled(@project_research_focus()) or
         !filled(@project_funding()) or !filled(@project_listing())
        errors.push(@pir.t("all_fields"))
      errors

    @projectInfoPageInvalid = ko.computed => @projectInfoPageErrors().length > 0
    new Popover('#page-project-info .next-btn', @projectInfoPageErrors)


  # Navigation
  #
  # Info -> User Type -> New User     -> Project Info -> (submit) -> Thanks
  #                                   -> Course Info  ->
  #                   -> Join Project ----------------->

  showInfoPage: (e) => @showPage "page-info", e
  showUserTypePage: (e) => @showPage "page-user-type", e
  nextFromUserTypePage: (e) =>
    page = switch @userType()
      when 'project_leader', 'sponsor', 'educator'
        "page-new-user"
      else
        "page-join"

    @showPage page, e
        

  showProjectInfoPage: (e) => @showPage "page-project-info", e
  backFromProjectInfoPage: (e) => @showPage "page-new-user", e

  showPage: (page_id, e) ->
    return if e && $(e.target).hasClass('disabled')
    $(".page").hide()
    $("##{page_id}").show()

  

  # Submission
  
  submitData: (e) =>
    console.log "Submission"

$ ->
  return if $("#new_application").length == 0

  ko.applyBindings new ApplicationForm()
