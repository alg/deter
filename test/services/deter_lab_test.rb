require 'test_helper'

class DeterLabTest < ActiveSupport::TestCase

  test "version returns version" do
    VCR.use_cassette "deterlab-version" do
      assert_equal "0.2/0.0", DeterLab.version
    end
  end

  test "it should return false for bad login" do
    VCR.use_cassette "deterlab-login-bad" do
      assert !DeterLab.valid_credentials?("unk", "badpass")
    end
  end

  test "it should return true for good login" do
    username = TestsConfig['username']
    password = TestsConfig['password']
    skip("Valid test user is missing from tests-config.yml") if username.blank? or password.blank?

    VCR.use_cassette "deterlab-login-good" do
      assert DeterLab.valid_credentials?(username, password)
      assert_not_nil SslKeyStorage.get(username)
    end
  end

end
