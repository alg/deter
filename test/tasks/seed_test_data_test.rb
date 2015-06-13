require 'test_helper'

class SeedTestDataTest < ActiveSupport::TestCase

  test "when joining projects user don't have ADD_USER and REMOVE_USER perms" do
    VCR.use_cassette "seeding/joining-project-perms" do
      user_id = 'abierce'
      assert DeterLab.valid_credentials?(user_id, 'Ambrose')

      project = DeterLab.view_projects(user_id).select { |p| p.project_id == 'Beta-Test' }.first
      member  = project.members.find { |m| m.uid == user_id }
      assert_not member.permissions.include?(ProjectMember::ADD_USER)
      assert_not member.permissions.include?(ProjectMember::REMOVE_USER)
    end
  end

  test 'user should own a project' do
    VCR.use_cassette "seeding/owning-project" do
      user_id = 'aadams'
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

  test "orchestration should be added to ExperimentOne" do
    VCR.use_cassette "seeding/aspect-orchestration" do
      assert DeterLab.valid_credentials?("abierce", "Ambrose")

      eid = "Alfa-Romeo:ExperimentOne"
      exp = DeterLab.view_experiments("abierce", list_only: false, regex: eid, query_aspects: { }).first
      assert_not_nil exp

      aspect = exp.aspects.find { |a| a.type == 'orchestration' }
      assert_not_nil aspect
      assert_equal "AAL TBD", aspect.data
    end
  end

  test "visualization should be added to ExperimentOne" do
    VCR.use_cassette "seeding/aspect-visualization" do
      assert DeterLab.valid_credentials?("abierce", "Ambrose")

      eid = "Alfa-Romeo:ExperimentOne"
      exp = DeterLab.view_experiments("abierce", list_only: false, regex: eid, query_aspects: { }).first
      assert_not_nil exp

      aspect = exp.aspects.find { |a| a.type == 'visualization' }
      assert_not_nil aspect
      assert_equal "http://tau.isi.edu/magi-viz/smartamerica/CA/", aspect.data
    end
  end

  private

  def load_user(name)
    user = TestsConfig[name]
    @username = user['username']
    @password = user['password']
  end
end
