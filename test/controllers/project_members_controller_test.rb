require 'test_helper'

class ProjectMembersControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"

    @pid = 'Project'
    @controller.deter_lab.expects(:get_project).returns(Project.new(@pid, "mark", true, []))
  end

  test 'should add members successfully' do
    AddUserToProject.any_instance.expects(:perform).with(@pid, "john").returns(true)
    post :create, project_id: @pid, member: { uid: "john" }
    assert_redirected_to project_members_path(@pid)
    assert_equal I18n.t("project_members.create.success"), flash.notice
  end

  test 'should handle member addition errors' do
    AddUserToProject.any_instance.expects(:perform).with(@pid, "john").raises(DeterLab::RequestError.new('error message'))
    post :create, project_id: @pid, member: { uid: "john" }
    assert_redirected_to project_members_path(@pid)
    assert_equal I18n.t("project_members.create.failure", error: "error message"), flash.alert
  end

end
