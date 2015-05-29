require 'test_helper'

class ExperimentMembersControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"

    @eid = 'Project:Experiment'
    @controller.deter_lab.expects(:get_experiment).returns(Experiment.new(@eid, 'mark', [], [], []))
  end

  test 'should show members list' do
    get :index, experiment_id: @eid
    assert_template :index
    assert_not_nil assigns[:experiment]
  end

  test 'should create a member record with short name' do
    DeterLab.expects(:change_experiment_acl).with do |uid, eid, perms|
      p = perms.first

      uid             == "mark" and
      eid             == @eid and
      perms.size      == 1 and
      p.circle_id     == "bberkley:bberkley" and
      p.permissions   == ExperimentACL::ALL_PERMS
    end.returns({ 'bberkley:bberkley' => true })
    @controller.deter_lab.expects(:invalidate_experiment).with(@eid)

    post :create, experiment_id: @eid, member: { circle_id: "bberkley" }
    assert_redirected_to experiment_members_path(@eid)
  end

  test 'should delete a member record' do
    DeterLab.expects(:change_experiment_acl).with do |uid, eid, perms|
      p = perms.first

      uid             == "mark" and
      eid             == @eid and
      perms.size      == 1 and
      p.circle_id     == "user:user" and
      p.permissions   == ExperimentACL::DELETE
    end.returns({ 'user:user' => true })
    @controller.deter_lab.expects(:invalidate_experiment).with(@eid)

    delete :destroy, experiment_id: @eid, id: "user:user"
    assert_redirected_to experiment_members_path(@eid)
  end

  test 'should disallow deleting themselves' do
    delete :destroy, experiment_id: @eid, id: "mark:mark"
    assert_redirected_to experiment_members_path(@eid)
    assert_equal I18n.t("experiment_members.destroy.deleting_self"), flash.alert
  end

end
