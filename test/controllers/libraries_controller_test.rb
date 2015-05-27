require 'test_helper'

class LibrariesControllerTest < ActionController::TestCase

  setup do
    AppSession.new(@controller.session).logged_in_as "mark"
    @controller.deter_lab.stubs(:get_library_profile_description).returns([])
  end

  test "new" do
    get :new
    assert_template :new
    assert_not_nil  assigns(:profile_descr)
  end

  test "creating" do
    DeterLab.expects(:create_library).with("mark", "mark:name", { 'description' => 'desc' }).returns(true)
    post :create, library: { name: "name", description: "desc" }
    assert_redirected_to :my_libraries
    assert_equal I18n.t("libraries.create.success"), flash.notice
  end

  test "failed creating" do
    DeterLab.expects(:create_library).returns(false)
    post :create, library: { name: "name", description: "desc" }
    assert_template :new
    assert_not_nil  assigns(:profile_descr)
    assert_equal I18n.t("libraries.create.failure", error: I18n.t("libraries.errors.unknown")), flash.now[:alert]
  end

  test "show" do
    lib = Library.new("Lib", "mark", nil, [], [])
    @controller.stubs(:load_library).returns(lib)
    @controller.stubs(:get_project_experiments).returns([])
    get :show, id: lib.id
    assert_template :show
    assert_equal    lib, assigns(:library)
    assert_not_nil  assigns(:project_experiments)
  end

  test "successful copy of experiment" do
    lib = Library.new("Lib", "mark", nil, [], [])
    @controller.stubs(:load_library).returns(lib)
    @controller.expects(:do_copy_experiment)
    post :copy_experiment, id: lib.id, experiment_id: "exid"
    assert_redirected_to library_path(lib.id)
    assert_equal I18n.t("libraries.copy_experiment.success"), flash.notice
  end

  test "failed copy of experiment" do
    lib = Library.new("Lib", "mark", nil, [], [])
    @controller.stubs(:load_library).returns(lib)
    @controller.expects(:do_copy_experiment).raises(DeterLab::RequestError.new("error message"))
    post :copy_experiment, id: lib.id, experiment_id: "exid"
    assert_redirected_to library_path(lib.id)
    assert_equal I18n.t("libraries.copy_experiment.failure", error: "error message"), flash.alert
  end

end
