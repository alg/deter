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

end
