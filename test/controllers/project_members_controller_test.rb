require 'test_helper'

class ProjectMembersControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"

    @pid = 'Project'
    @controller.deter_lab.expects(:get_project).returns(Project.new(@pid, "mark", true, []))
  end

  test 'should add members successfully' do
    ProjectMembers.any_instance.expects(:add_user).with("john").returns(true)
    post :create, project_id: @pid, member: { uid: "john" }
    assert_redirected_to project_members_path(@pid)
    assert_equal I18n.t("project_members.create.success"), flash.notice
  end

  test 'should handle member addition errors' do
    ProjectMembers.any_instance.expects(:add_user).with("john").raises(DeterLab::RequestError.new('error message'))
    post :create, project_id: @pid, member: { uid: "john" }
    assert_redirected_to project_members_path(@pid)
    assert_equal I18n.t("project_members.create.failure", error: "error message"), flash.alert
  end

  test 'should delete members successfully' do
    ProjectMembers.any_instance.expects(:remove_user).with("john").returns(true)
    delete :destroy, project_id: @pid, id: "john"
    assert_redirected_to project_members_path(@pid)
    assert_equal I18n.t("project_members.destroy.success"), flash.notice
  end

  test 'handling of member removal errors' do
    ProjectMembers.any_instance.expects(:remove_user).with("john").raises(DeterLab::RequestError.new("error message"))
    delete :destroy, project_id: @pid, id: "john"
    assert_redirected_to project_members_path(@pid)
    assert_equal I18n.t("project_members.destroy.failure", error: "error message"), flash.alert
  end

end
