require 'test_helper'

class ExperimentAspectsControllerTest < ActionController::TestCase

  setup do
    @controller.app_session.logged_in_as "mark"

    @eid = 'Project:Experiment'
    @controller.deter_lab.expects(:get_experiment).returns(Experiment.new(@eid, 'mark', [], []))
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

end
