require 'test_helper'

class ExperimentMembersControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test '#index should show members list' do
    @controller.deter_lab.expects(:get_experiment).returns(Experiment.new(1, 'mark', [], []))
    get :index, experiment_id: 'Project:Experiment'
    assert_template :index
    assert_not_nil assigns[:experiment]
  end

end
