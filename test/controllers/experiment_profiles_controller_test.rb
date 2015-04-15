require 'test_helper'

class ExperimentProfilesControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test '#edit should show the form' do
    @controller.deter_lab.expects(:get_experiment_profile_description).returns(:ok)
    @controller.deter_lab.expects(:get_experiment_profile).returns(:ok)
    get :edit, id: 'Project:Experiment'
    assert_template :edit
    assert_not_nil assigns[:profile]
    assert_not_nil assigns[:profile_description]
  end

end
