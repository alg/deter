require 'test_helper'

class SeedTestDataTest < ActiveSupport::TestCase

  # setup do
  #   VCR.use_cassette "seeding/setup" do
  #     load_user 'admin_user'
  #     @res = SeedTestData.new(@username, @password).perform
  #   end
  # end

  test 'users should be added' do
    VCR.use_cassette "seeding/testing-users" do
      user = 'aadams'
      login = user[1]
      pass = user[0].split(' ').first
      assert DeterLab.valid_credentials?(login, pass)
    end
  end

  test 'user should own a project' do
    VCR.use_cassette "seeding/owning-project" do
      user_id = 'aadamss'
      assert DeterLab.valid_credentials?(user_id, 'Abigail')

      project_ids = DeterLab.view_projects(user_id).map(&:project_id)
      assert project_ids.include?('Alfa-Romeo')
    end
  end

  test 'user should be added to a project' do
    VCR.use_cassette "seeding/joining-project" do
      user_id = 'aadams'
      assert DeterLab.valid_credentials?(user_id, 'Abigail')

      project = DeterLab.view_projects(user_id).select { |p| p.project_id == 'Beta-Test' }.first
      assert_not_nil project
      assert_not_equal user_id, project.owner
    end
  end

  # test 'user should create experiments' do
  #   VCR.use_cassette "seeding/create-experiment" do
  #     user_id = @res[:user_ids]['Abigail Adams']
  #     assert DeterLab.valid_credentials?(user_id, 'Abigail')

  #     experiment = DeterLab.view_experiments(user_id, project_id: "Alfa-Romeo").select { |e| e.id == "Alfa-Romeo:HelloWorld" }.first
  #     assert_not_nil experiment
  #     assert_equal user_id, experiment.owner
  #   end
  # end

  private

  def load_user(name)
    user = TestsConfig[name]
    @username = user['username']
    @password = user['password']
  end
end
