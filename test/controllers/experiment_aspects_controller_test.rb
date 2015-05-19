require 'test_helper'

class ExperimentAspectsControllerTest < ActionController::TestCase

  setup do
    @controller.app_session.logged_in_as "mark"

    @eid = 'Project:Experiment'
    @aspects = [
      ExperimentAspect.new(@ied, "layout000", "layout", nil, "layout", "ref"),
      ExperimentAspect.new(@ied, "layout000/namemap/R", "layout", "namemap", "names", "ref-2")
    ]
    @controller.deter_lab.stubs(:get_experiment).returns(Experiment.new(@eid, 'mark', [], @aspects))
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
    DeterLab.expects(:add_experiment_aspects).with('mark', @eid, [ { name: "name", type: "layout", data: Base64.encode64("<xml/>") } ]).returns({ "name" => { success: true, reason: nil } })
    post :create, experiment_id: @eid, aspect: { name: "name", type: "layout", data: "<xml/>" }
    assert_redirected_to experiment_path(@eid)
    assert_equal I18n.t("experiment_aspects.create.success"), flash.notice
  end

  test 'should handle errors when adding aspects to experiments' do
    reason = "Cannot read layout!?:Invalid byte 2 of 3-byte UTF-8 sequence."
    @controller.expects(:current_user_name).returns('mark')
    DeterLab.expects(:add_experiment_aspects).raises(DeterLab::Error.new(reason))
    post :create, experiment_id: @eid, aspect: {}
    assert_template :new
    assert_equal reason, flash.now[:alert]
  end

  test 'should handle specific aspect error when adding' do
    reason = 'duplicate'
    @controller.expects(:current_user_name).returns('mark')
    DeterLab.expects(:add_experiment_aspects).returns({ "name" => { success: false, reason: reason } })
    post :create, experiment_id: @eid, aspect: { name: "name" }
    assert_template :new
    assert_equal reason, flash.now[:alert]
  end

  test 'aspect object should pass valid URLs' do
    VCR.use_cassette 'aspects/valid-url' do
      a = ExperimentAspectsController::Aspect.new(data: 'http://google.com')
      assert a.valid_url?
    end
  end

  test 'aspect object should catch badly formed URLs' do
    a = ExperimentAspectsController::Aspect.new(data: 'htt://google.com')
    assert !a.valid_url?
  end

  test 'aspect object should catch invalid URLs' do
    VCR.use_cassette 'aspects/invalid-url', record: :all do
      a = ExperimentAspectsController::Aspect.new(data: 'http://google.coma')
      assert !a.valid_url?
    end
  end

  test 'aspect handling invalid visualization data' do
    a = ExperimentAspectsController::Aspect.new(data: 'invalid_url', type: 'visualization')
    a.stubs(:valid_url?).returns(false)
    assert !a.valid_aspect?
    assert_equal [ "Invalid URL. Please verify." ], a.aspect_errors
  end

  test 'aspect handling non-URL data for layouts' do
    a = ExperimentAspectsController::Aspect.new(data: 'invalid_url', type: 'layout')
    assert a.valid_aspect?
  end
end
