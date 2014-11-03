require 'test_helper'

class DeterLabTest < ActiveSupport::TestCase

  setup do
    @username = TestsConfig['username']
    @password = TestsConfig['password']
  end

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
    skip("Valid test user is missing from tests-config.yml") if @username.blank? or @password.blank?

    VCR.use_cassette "deterlab-confidential-login-good" do
      assert DeterLab.valid_credentials?(@username, @password)
      assert_not_nil SslKeyStorage.get(@username)
    end
  end

  # -------------------------------------------------------------------------------------

  test "getting user profile" do
    skip("Valid test user is missing from tests-config.yml") if @username.blank? or @password.blank?

    VCR.use_cassette "deterlab-confidential-user-profile" do
      DeterLab.valid_credentials?(@username, @password)
      profile = DeterLab.get_user_profile(@username)
      assert_equal profile['zip'], '06405'
    end
  end

end
