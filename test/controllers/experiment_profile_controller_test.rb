require 'test_helper'

class ExperimentProfileControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test 'should show the form' do
    @controller.deter_lab.expects(:get_experiment_profile_description).returns([])
    @controller.deter_lab.expects(:get_experiment_profile).returns([])
    get :show, experiment_id: 'Project:Experiment'
    assert_template :show
    assert_not_nil assigns[:profile]
    assert_not_nil assigns[:profile_description]
  end

end
