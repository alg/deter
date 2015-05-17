require 'test_helper'

class ExperimentAspectsControllerTest < ActionController::TestCase

  setup do
    @controller.app_session.logged_in_as "mark"

    @eid = 'Project:Experiment'
    @aspects = [
      ExperimentAspect.new(@ied, "layout000", "layout", nil, "layout", "ref"),
      ExperimentAspect.new(@ied, "layout000/namemap/R", "layout", "namemap", "names", "ref-2")
    ]
    @controller.deter_lab.expects(:get_experiment).returns(Experiment.new(@eid, 'mark', [], @aspects))
    SummaryLoader.stubs(:member_profile).returns({ "name" => "Mark" })
  end

  test 'deleting aspects successfully' do
    DeterLab.expects(:remove_experiment_aspects).with('mark', @eid, [ { name: "layout000", type: "type" } ]).returns({ "layout000" => true })
    delete :destroy, experiment_id: @eid, id: "layout000", type: 'type'
    assert_redirected_to experiment_path(@eid)
    assert_equal I18n.t("experiment_aspects.destroy.success"), flash.notice
  end

  test 'deleting aspects failure' do
    DeterLab.expects(:remove_experiment_aspects).with('mark', @eid, [ { name: "layout000", type: "type" } ]).returns({ "layout000" => false })
    delete :destroy, experiment_id: @eid, id: "layout000", type: 'type'
    assert_redirected_to experiment_path(@eid)
    assert_equal I18n.t("experiment_aspects.destroy.failure"), flash.alert
  end

  test 'successful updating aspects' do
    # DeterLab.expects(:change_experiment_aspects).with('mark', @eid, @aspects).returns({ "layout000" => { success: true }, "layout000/namemap/R" => { success: true } })
    put :update, experiment_id: @eid, id: 'layout000', change_control_enabled: true, change_control_url: "http://cc_url", aspect: { data: "new data" }
    assert_redirected_to experiment_path(@eid)
    assert_equal I18n.t("experiment_aspects.update.success"), flash.notice
  end

  test 'handling missing aspect on update' do
    put :update, experiment_id: @eid, id: 'missing'
    assert_redirected_to experiment_path(@eid)
    assert_equal I18n.t("experiment_aspects.not_found"), flash.alert
  end

  test 'not changing data on update' do
    DeterLab.expects(:change_experiment_aspects).never
    put :update, experiment_id: @eid, id: 'layout000', change_control_enabled: true, change_control_url: "http://cc_url", aspect: { data: "layout" }
    assert_redirected_to experiment_path(@eid)
  end

  # test 'handling failure on update' do
  #   DeterLab.expects(:change_experiment_aspects).with('mark', @eid, @aspects).returns({ "layout000" => { success: false, error: "error reason" }, "layout000/namemap/R" => { success: true } })
  #   put :update, experiment_id: @eid, id: 'layout000', change_control_enabled: true, change_control_url: "http://cc_url", aspect: { data: "new data" }
  #   assert_template :edit
  #   assert_equal "error reason", assigns(:error)
  # end

  test 'should add experiment aspect' do
    DeterLab.expects(:add_experiment_aspects).with('mark', @eid, [ { name: "name", type: "layout", data: "<xml/>" } ]).returns(true)
    post :create, experiment_id: @eid, aspect: { name: "name", type: "layout", data: "<xml/>" }
    assert_redirected_to experiment_path(@eid)
    assert_equal I18n.t("experiment_aspects.create.success"), flash.notice
  end

end
