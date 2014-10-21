# Localized errors
class I18nErrors
  constructor: (base) -> @base = base
  t: (key) -> I18n.t("#{@base}.#{key}")

# Application form
class ApplicationForm
  constructor: ->
    @initUserFields()
    @initProjectFields()
    @initCourseFields()

    @initInfoPage()
    @initUserTypePage()
    @initNewUserPage()
    @initProjectInfoPage()
    @initJoinProjectPage()
    @initCourseInfoPage()

    @initHelpers()


  # Form fields

  initUserFields: ->
    @userType               = ko.observable()
    @full_name              = ko.observable()
    @email                  = ko.observable()
    @phone                  = ko.observable()
    @position               = ko.observable()
    @affiliate              = ko.observable()
    @abbrev                 = ko.observable()
    @website                = ko.observable()
    @username               = ko.observable()
    @password               = ko.observable()
    @password_confirmation  = ko.observable()
    @address_1              = ko.observable()
    @address_2              = ko.observable()
    @city                   = ko.observable()
    @state                  = ko.observable()
    @zip                    = ko.observable()
    @country                = ko.observable()

  initProjectFields: ->
    @project_name           = ko.observable()
    @project_plan           = ko.observable()
    @project_id             = ko.observable()
    @project_website        = ko.observable()
    @project_org_type       = ko.observable()
    @project_research_focus = ko.observable()
    @project_funding        = ko.observable()
    @project_listing        = ko.observable()

  initCourseFields: ->
    @course_name            = ko.observable()
    @course_description     = ko.observable()
    @course_focus           = ko.observable()

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
    @utr = new I18nErrors("page_user_type.errors")
    @userTypePageErrors = ko.computed =>
      errors = []
      errors.push(@utr.t("user_type")) if !@userType()
      errors

    @userTypePageInvalid = ko.computed => @userTypePageErrors().length > 0

    new Popover('#page-user-type .next-btn', @userTypePageErrors)


  # New user page

  initNewUserPage: ->
    @nur = new I18nErrors("page_new_user.errors")
    @newUserPageErrors = ko.computed =>
      errors = []
      if !filled(@full_name()) or !filled(@email()) or !filled(@phone()) or !filled(@position()) or !filled(@affiliate()) or !filled(@abbrev()) or !filled(@website()) or
         !filled(@username()) or !filled(@password()) or !filled(@password_confirmation()) or @password() != @password_confirmation() or
         !filled(@address_1()) or !filled(@address_2()) or !filled(@city()) or !filled(@state()) or !filled(@zip()) or !filled(@country())
        errors.push(@nur.t("all_fields"))
      errors

    @newUserPageInvalid = ko.computed => @newUserPageErrors().length > 0

    new Popover('#page-new-user .next-btn', @newUserPageErrors)


  # Project info page

  initProjectInfoPage: ->
    @omitProjectId = ko.computed =>
      @userType() == 'project_leader' or
      @userType() == 'sponsor'

    @pir = new I18nErrors("page_project_info.errors")
    @projectInfoPageErrors = ko.computed =>
      errors = []
      if !filled(@project_name()) or !filled(@project_plan()) or
         (!@omitProjectId() and !filled(@project_id())) or
         !filled(@project_website()) or !filled(@project_org_type()) or !filled(@project_research_focus()) or
         !filled(@project_funding()) or !filled(@project_listing())
        errors.push(@pir.t("all_fields"))
      errors

    @projectInfoPageInvalid = ko.computed => @projectInfoPageErrors().length > 0
    new Popover('#page-project-info .next-btn', @projectInfoPageErrors)


  # Join project page

  initJoinProjectPage: ->
    @jpp = new I18nErrors("page_join_project.errors")
    @joinProjectPageErrors = ko.computed =>
      errors = []
      if !filled(@project_name()) or
         !filled(@full_name()) or !filled(@email()) or !filled(@phone()) or !filled(@position()) or !filled(@affiliate()) or !filled(@abbrev()) or !filled(@website()) or
         !filled(@username()) or !filled(@password()) or !filled(@password_confirmation()) or @password() != @password_confirmation() or
         !filled(@address_1()) or !filled(@address_2()) or !filled(@city()) or !filled(@state()) or !filled(@zip()) or !filled(@country())
        errors.push(@jpp.t("all_fields"))
      errors

    @joinProjectPageInvalid = ko.computed => @joinProjectPageErrors().length > 0

    new Popover('#page-join-project .next-btn', @joinProjectPageErrors)


  # Course info page
  
  initCourseInfoPage: ->
    @cip = new I18nErrors("page_course_info.errors")
    @courseInfoPageErrors = ko.computed =>
      errors = []
      errors.push(@cip.t("all_fields")) if !filled(@course_name()) || !filled(@course_description()) || !filled(@course_focus())
      errors

    @courseInfoPageInvalid = ko.computed => @courseInfoPageErrors().length > 0
    new Popover('#page-course-info .next-btn', @courseInfoPageErrors)


  # Helpers

  initHelpers: ->
    @creatingProject = ko.computed =>
      @userType() == 'project_leader' or
      @userType() == 'sponsor'

    @creatingCourse = ko.computed =>
      @userType() == 'educator'

    @creatingNewUser = ko.computed =>
      @userType() == 'project_leader' or
      @userType() == 'sponsor' or
      @userType() == 'educator'

    @joiningProject = ko.computed =>
      !@creatingProject() and
      !@creatingCourse()

  # Navigation
  #
  # Info -> User Type -> New User     -> Project Info -> (submit) -> Thanks
  #                                   -> Course Info  ->
  #                   -> Join Project ----------------->

  showInfoPage: (e) => @showPage "page-info", e
  showUserTypePage: (e) => @showPage "page-user-type", e
  nextFromUserTypePage: (e) =>
    page = if @creatingNewUser() then "page-new-user" else "page-join-project"
    @showPage page, e

  nextFromNewUserPage: (e) =>
    page = if @creatingProject() then "page-project-info" else "page-course-info"
    @showPage page, e

  backFromProjectInfoPage: (e) => @showPage "page-new-user", e

  backFromJoinProjectPage: (e) => @showPage "page-user-type", e
  backFromCourseInfoPage:  (e) => @showPage "page-new-user", e

  showPage: (page_id, e) ->
    return if e && $(e.target).hasClass('disabled')
    $(".page").hide()
    $("##{page_id}").show 0, ->
      window.scrollTo(0, 0)

  

  # Submission
  
  submitData: (e) =>
    alert("Submission goes here")

$ ->
  return if $("#new_application").length == 0

  ko.applyBindings new ApplicationForm()
