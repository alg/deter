require 'test_helper'

class ProjectJoinsControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test 'new' do
    get :new
    assert_template :new
  end

  test 'create' do
    DeterLab.expects(:join_project).with("mark", "project_id").returns(true)
    post :create, project_id: 'project_id'
    assert_redirected_to :project_joins
    assert_equal I18n.t("project_joins.create.success"), flash.notice
  end

  test 'create failure' do
    DeterLab.expects(:join_project).with("mark", "unknown_project_id").returns(false)
    post :create, project_id: 'unknown_project_id'
    assert_template :new
    assert_equal I18n.t("project_joins.create.failure"), flash.alert
  end

end
