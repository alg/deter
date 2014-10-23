# Application form
class ApplicationForm
  constructor: ->
    $("form#new-application").on "submit", (e) -> e.preventDefault()

    @initInfoFields()
    @initUserFields()
    @initProjectFields()
    @initCourseFields()
    @initErrors()

    @initInfoPage()
    @initUserTypePage()
    @initNewUserPage()
    @initProjectInfoPage()
    @initJoinProjectPage()
    @initCourseInfoPage()

    @initHelpers()

  # Validated field helper that creates two fields
  # @<name> and @<name>_invalid. "_invalid" version is set to true / false
  # depending on the validator function.
  validatedObservable: (name, validator) ->
    @[name]                 = ko.observable()
    @["#{name}_invalid"]    = ko.computed =>
      v = @[name]()
      if validator?
        !validator(v)
      else
        res = if typeof v == "string" then filled(v) else v
        !res



  # Form fields

  initInfoFields: ->
    @infoFields = [ "apply", "accept" ]
    @validatedObservable(field) for field in @infoFields

  initUserFields: ->
    @validatedObservable("userType")
    @userFields = [ "full_name", "email", "phone", "position", "affiliate", "abbrev", "website", "address_1", "address_2", "city", "state", "zip", "country" ]
    @validatedObservable(field) for field in @userFields

  initProjectFields: ->
    @projectFields = [ "project_name", "project_plan", "project_website", "project_org_type", "project_research_focus", "project_funding", "project_listing" ]
    @validatedObservable(field) for field in @projectFields

  initCourseFields: ->
    @courseFields = [ "course_name", "course_description", "course_focus" ]
    @validatedObservable(field) for field in @courseFields

  initErrors: ->
    @ipe    = new I18nErrors("page_info.errors")
    @utpe   = new I18nErrors("page_user_type.errors")
    @ufe    = new I18nErrors("user_form.errors")
    @pipple = new I18nErrors("page_project_info.project_leader.errors")
    @pipspe = new I18nErrors("page_project_info.sponsor.errors")
    @cipe   = new I18nErrors("page_course_info.errors")



  # Info page

  initInfoPage: ->
    @iHL = ko.observable(false)
    @infoPageErrors = ko.computed =>
      errors = []
      for field in @infoFields
        errors.push(@ipe.t(field)) if @["#{field}_invalid"]()
      errors

    @infoPageInvalid = ko.computed => @infoPageErrors().length > 0
    new Popover('#page-info .next-btn', @infoPageErrors, @iHL)



  # User type page

  initUserTypePage: ->
    @utHL = ko.observable(false)
    @userTypePageErrors = ko.computed =>
      errors = []
      errors.push(@utpe.t("user_type")) if @userType_invalid()
      errors

    @userTypePageInvalid = ko.computed => @userTypePageErrors().length > 0
    new Popover('#page-user-type .next-btn', @userTypePageErrors, @utHL)


  # New user page

  initNewUserPage: ->
    @nuHL = ko.observable(false)
    @newUserPageErrors = ko.computed =>
      errors = []
      for field in @userFields
        errors.push(@ufe.t(field)) if @["#{field}_invalid"]() 
      errors

    @newUserPageInvalid = ko.computed => @newUserPageErrors().length > 0
    new Popover('#page-new-user .next-btn', @newUserPageErrors, @nuHL)



  # Project info page

  initProjectInfoPage: ->
    @piHL = ko.observable(false)
    @omitProjectId = ko.computed =>
      @userType() == 'project_leader' or
      @userType() == 'sponsor'

    @projectInfoPageErrors = ko.computed =>
      errors = []
      i18ne = if @userType() == 'project_leader' then @pipple else @pipspe
      for field in @projectFields
        errors.push(i18ne.t(field)) if @["#{field}_invalid"]() 
      errors

    @projectInfoPageInvalid = ko.computed => @projectInfoPageErrors().length > 0
    new Popover('#page-project-info .next-btn', @projectInfoPageErrors, @piHL)


  # Join project page

  initJoinProjectPage: ->
    @jpHL = ko.observable(false)
    @joinProjectPageErrors = ko.computed =>
      errors = []
      errors.push(@pipple.t("project_name")) if @project_name_invalid()
      for field in @userFields
        errors.push(@ufe.t(field)) if @["#{field}_invalid"]()
      errors

    @joinProjectPageInvalid = ko.computed => @joinProjectPageErrors().length > 0
    new Popover('#page-join-project .next-btn', @joinProjectPageErrors, @jpHL)


  # Course info page
  
  initCourseInfoPage: ->
    @ciHL = ko.observable(false)
    @courseInfoPageErrors = ko.computed =>
      errors = []
      for field in @courseFields
        errors.push(@cipe.t(field)) if @["#{field}_invalid"]()
      errors

    @courseInfoPageInvalid = ko.computed => @courseInfoPageErrors().length > 0
    new Popover('#page-course-info .next-btn', @courseInfoPageErrors, @ciHL)


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
  
  submitData: =>
    $("form#new-application")[0].submit()


$ ->
  return if $("#new_application").length == 0

  ko.applyBindings new ApplicationForm()
