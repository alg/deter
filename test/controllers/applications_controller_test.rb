require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  tests ApplicationsController

  test "thanks page for project leader" do
    assert_page_for 'project_leader', /Thank you for your application for access to DeterLab/
  end

  test "thanks page for member" do
    assert_page_for 'member', /Thank you for submitting your application for sponsored access to DeterLab/
  end

  test "thanks page for sponsor" do
    assert_page_for 'sponsor', /Thank you for submitting your application for sponsored access to DeterLab/
  end

  test "thanks page for sponsored student" do
    assert_page_for 'sponsored_student', /Thank you for submitting your application for sponsored access to DeterLab/
  end

  test "thanks page for educator" do
    assert_page_for 'educator', /Thank you for your application for educational use of DeterLab/
  end

  private

  def assert_page_for(user_type, match)
    ApplyForAccount.expects(:perform).returns(true)
    post :create, user_type: user_type
    assert_response :success
    assert_select 'p', match
  end
end
