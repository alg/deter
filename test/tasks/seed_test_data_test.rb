require 'test_helper'

class SeedTestDataTest < ActiveSupport::TestCase

  setup do
    VCR.use_cassette "seeding" do
      load_user 'admin_user'
      @res = SeedTestData.new(@username, @password).perform
    end
  end

  test 'users should be added' do
    VCR.use_cassette "seeding-testing-users" do
      user = @res[:user_ids].first
      login = user[1]
      pass = user[0].split(' ').first
      assert DeterLab.valid_credentials?(login, pass)
    end
  end

  # test 'user should own a project'
  # test 'user should be added to a project'

  private

  def load_user(name)
    user = TestsConfig[name]
    @username = user['username']
    @password = user['password']
  end
end
