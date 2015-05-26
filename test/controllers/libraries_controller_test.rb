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

end
