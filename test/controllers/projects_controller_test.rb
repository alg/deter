require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "index" do
    DeterLab.expects(:view_projects).returns([])
    get :index
    assert_not_nil assigns[:projects]
    assert_template :index
  end

  test "sorting of projects in index" do
    ProjectsController.any_instance.stubs(:get_projects).returns([
      Project.new("member-b", "john", true, [ ProjectMember.new("john", []), ProjectMember.new("mark", []) ]),
      Project.new("owner-b", "mark", true, []),
      Project.new("owner-a", "mark", true, []),
      Project.new("member-a", "john", true, [ ProjectMember.new("john", []), ProjectMember.new("mark", []) ])
    ])
    get :index
    ps = assigns[:projects]
    assert_equal ps[0].project_id, "owner-a"
    assert_equal ps[1].project_id, "owner-b"
    assert_equal ps[2].project_id, "member-a"
    assert_equal ps[3].project_id, "member-b"
  end

  test "show" do
    pid = "project_id"
    pr = Project.new(pid, "mark", true, [])
    DeterLab.expects(:view_projects).returns([ pr ])
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
