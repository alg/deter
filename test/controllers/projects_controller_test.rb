require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "index" do
    DeterLab.expects(:get_user_projects).returns([])
    get :index
    assert_not_nil assigns[:projects]
    assert_template :index
  end

  test "new" do
    DeterLab.expects(:get_project_profile_description).returns([])
    get :new
    assert_not_nil assigns[:profile_descr]
    assert_template :new
  end

  test "successful create" do
    DeterLab.expects(:create_project).with("mark", "test", { 'description' => "descr" }).returns(true)
    post :create, project: { name: "test", description: "descr" }
    assert_redirected_to :projects
    assert_equal I18n.t("projects.create.success"), flash.notice
  end

  test "failed create" do
    DeterLab.expects(:create_project).with("mark", "test", { 'description' => "" }).raises(DeterLab::RequestError.new("error message"))
    post :create, project: { name: "test", description: "" }
    assert_template :new
    assert_equal I18n.t("projects.create.failure", error: "error message"), flash.now[:alert]
  end

  test "no name" do
    post :create, project: { name: "" }
    assert_template :new
    assert_equal I18n.t("projects.create.failure", error: I18n.t("projects.create.name_required")), flash.now[:alert]
  end
end
