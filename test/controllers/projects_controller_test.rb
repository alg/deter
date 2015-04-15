require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "index" do
    DeterLab.expects(:view_projects).twice.returns([])
    get :index
    assert_not_nil assigns[:approved]
    assert_not_nil assigns[:unapproved]
    assert_template :index
  end

  test "separating approved from unapproved" do
    SummaryLoader.stubs(:user_projects).returns([
      { project_id: "member-b", approved: true,  leader: { uid: "john" } },
      { project_id: "owner-b",  approved: false, leader: { uid: "mark" } },
      { project_id: "owner-a",  approved: true,  leader: { uid: "mark" } },
      { project_id: "member-a", approved: false, leader: { uid: "john" } }
    ])

    get :index
    approved = assigns[:approved].map { |p| p[:project_id] }
    assert_equal ["owner-a", "member-b"], approved

    unapproved = assigns[:unapproved].map { |p| p[:project_id] }
    assert_equal ["owner-b"], unapproved
  end

  test "sorting of projects in index" do
    SummaryLoader.stubs(:user_projects).returns([
      { project_id: "member-b", approved: true, leader: { uid: "john" } },
      { project_id: "owner-b",  approved: true, leader: { uid: "mark" } },
      { project_id: "owner-a",  approved: true, leader: { uid: "mark" } },
      { project_id: "member-a", approved: true, leader: { uid: "john" } }
    ])
    get :index
    assert_equal ["owner-a", "owner-b", "member-a", "member-b"], assigns[:approved].map { |p| p[:project_id] }
    assert_equal [], assigns[:unapproved]
  end

  test "show" do
    pid = "project_id"
    pr = Project.new(pid, "mark", true, [])
    DeterLab.expects(:view_projects).twice.returns([ pr ])
    DeterLab.expects(:get_project_profile).with("mark", pid).returns({})
    get :show, id: pid
    assert_not_nil assigns[:project]
    assert_not_nil assigns[:profile]
    assert_template :show
  end

  test "new" do
    DeterLab.expects(:get_project_profile_description).returns([])
    get :new
    assert_not_nil assigns[:profile_descr]
    assert_template :new
  end

  test "successful create" do
    DeterLab.expects(:create_project).with("mark", "test", "mark", { 'description' => "descr" }).returns(true)
    post :create, project: { name: "test", description: "descr" }
    assert_redirected_to :projects
    assert_equal I18n.t("projects.create.success"), flash.notice
  end

  test "failed create" do
    DeterLab.expects(:create_project).with("mark", "test", "mark", { 'description' => "" }).raises(DeterLab::RequestError.new("error message"))
    DeterLab.expects(:get_project_profile_description).returns([])
    post :create, project: { name: "test", description: "" }
    assert_template :new
    assert_equal I18n.t("projects.create.failure", error: "error message"), flash.now[:alert]
  end

  test "creating without name" do
    DeterLab.expects(:get_project_profile_description).returns([])
    post :create, project: { name: "" }
    assert_template :new
    assert_equal I18n.t("projects.create.failure", error: I18n.t("projects.create.name_required")), flash.now[:alert]
  end

  test "deleting" do
    DeterLab.expects(:remove_project).with("mark", "projectid").returns(true)
    delete :destroy, id: "projectid"
    assert_redirected_to :projects
    assert_equal I18n.t("projects.destroy.success"), flash.notice
  end

  test "failed deleting" do
    error = "Invalid projectid"
    DeterLab.expects(:remove_project).with("mark", "projectid").raises(DeterLab::RequestError.new(error))
    delete :destroy, id: "projectid"
    assert_redirected_to :projects
    assert_equal I18n.t("projects.destroy.failure", error: error), flash.alert
  end

end
