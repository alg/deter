require 'test_helper'

class ExperimentsControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "index" do
    DeterLab.expects(:get_user_experiments).returns([])
    get :index
    assert_not_nil assigns(:experiments)
    assert_template :index
  end

  test "show" do
    ex1 = Experiment.new("id1", "owner", [])
    ex2 = Experiment.new("id2", "owner", [])
    DeterLab.expects(:get_user_experiments).returns([ ex1, ex2 ])
    get :show, id: ex1.name
    assert_equal ex1, assigns(:experiment)
    assert_template :show
  end

  test "show missing experiment" do
    DeterLab.expects(:get_user_experiments).returns([])
    get :show, id: 'missing'
    assert_equal I18n.t("experiments.show.not_found"), flash.alert
    assert_redirected_to :experiments
  end

end
