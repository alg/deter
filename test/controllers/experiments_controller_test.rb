require 'test_helper'

class ExperimentsControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
  end

  test "index" do
    DeterLab.expects(:view_experiments).returns([])
    get :index
    assert_not_nil assigns(:experiments)
    assert_template :index
  end

  test "sorting of experiments in index" do
    CachedDeterLab.any_instance.stubs(:get_experiments).returns([
      Experiment.new("member-b", "john", []),
      Experiment.new("owner-b", "mark", []),
      Experiment.new("owner-a", "mark", []),
      Experiment.new("member-a", "john", [])
    ])
    get :index
    es = assigns[:experiments]
    assert_equal %w( owner-a owner-b member-a member-b ), es.map(&:id)
  end

  test "show" do
    ex1 = Experiment.new("id1", "owner", [])
    ex2 = Experiment.new("id2", "owner", [])
    DeterLab.expects(:view_experiments).returns([ ex1, ex2 ])
    DeterLab.expects(:get_experiment_profile).with("mark", ex1.id).returns({})
    get :show, id: ex1.id
    assert_equal ex1, assigns(:experiment)
    assert_equal({}, assigns(:profile))
    assert_template :show
  end

  test "show missing experiment" do
    DeterLab.expects(:view_experiments).returns([])
    get :show, id: 'missing'
    assert_equal I18n.t("experiments.show.not_found"), flash.alert
    assert_redirected_to :experiments
  end

  test "new" do
    DeterLab.expects(:get_experiment_profile_description).returns([])
    DeterLab.expects(:view_projects).twice.returns([])
    get :new
    assert_equal [], assigns[:profile_descr]
    assert_equal [], assigns[:projects]
    assert_template :new
  end

  test "creating" do
    DeterLab.expects(:create_experiment).with("mark", "pid", "Test", { "description" => "Descr" }).returns(true)
    DeterCache.any_instance.expects(:delete).with("experiments")
    post :create, project_id: "pid", experiment: { name: "Test", description: "Descr" }
    assert_redirected_to :experiments
    assert_equal I18n.t("experiments.create.success"), flash.notice
  end

  test "failed creating" do
    DeterLab.expects(:create_experiment).raises(DeterLab::RequestError.new("error message"))
    DeterLab.expects(:get_experiment_profile_description).returns([])
    DeterLab.expects(:view_projects).twice.returns([])
    post :create, project_id: "pid", experiment: { }
    assert_template :new
    assert_equal I18n.t("experiments.create.failure", error: "error message"), flash.now[:alert]
  end

  test "deleting" do
    DeterLab.expects(:remove_experiment).with("mark", "eid").returns(true)
    delete :destroy, id: "eid"
    assert_redirected_to :experiments
    assert_equal I18n.t("experiments.destroy.success"), flash.notice
  end

  test "failed deleting" do
    error = "some error"
    DeterLab.expects(:remove_experiment).raises(DeterLab::RequestError.new(error))
    delete :destroy, id: "eid"
    assert_redirected_to :experiments
    assert_equal I18n.t("experiments.destroy.failure", error: error), flash.alert
  end

  test "successful run" do
    DeterLab.expects(:realize_experiment).with("mark", "mark", "eid").returns(true)
    post :run, id: "eid"
    assert_redirected_to :experiments
    assert_equal I18n.t("experiments.run.success"), flash.notice
  end

  test "failed run" do
    error = "some error"
    DeterLab.expects(:realize_experiment).raises(DeterLab::RequestError.new(error))
    post :run, id: "eid"
    assert_redirected_to :experiments
    assert_equal I18n.t("experiments.run.failure", error: error), flash.alert
  end
end
