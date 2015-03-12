require 'services/deter_lab/abstract_test'

class DeterLab::ExperimentsTest < DeterLab::AbstractTest

  test "getting experiments" do
    VCR.use_cassette "deterlab/experiments/view-experiments" do
      login

      create_experiment
      list = view_experiments
      remove_experiment

      assert_equal [
        Experiment.new("SPIdev:Test", @username, [
          ExperimentACL.new("SPIdev:SPIdev", [ "MODIFY_EXPERIMENT_ACCESS", "READ_EXPERIMENT", "MODIFY_EXPERIMENT" ]),
          ExperimentACL.new("bfdh:bfdh", [ "MODIFY_EXPERIMENT_ACCESS", "READ_EXPERIMENT", "MODIFY_EXPERIMENT" ])
        ])
      ], list
    end
  end

  test "experiment profile" do
    VCR.use_cassette "deterlab/experiments/experiment-profile" do
      login

      create_experiment
      profile = DeterLab.get_experiment_profile(@username, "SPIdev:Test")
      remove_experiment

      assert_equal [
        ProfileField.new("description", "string", false, "READ_WRITE", "Description", nil, nil, "0", "Custom description")
      ], profile
    end
  end

  # test "getting experiments for a certain project" do
  #   VCR.use_cassette "deterlab/experiments/view-experiments-for-project" do
  #     login 'user_with_multiple_projects'
  #     list = view_experiments("Bravo")
  #     assert_equal [ 'Bravo:BCone' ], list.map(&:id), "No filtering by experiment name"
  #   end
  # end

  # test "getting experiment with aspects" do
  #   VCR.use_cassette "deterlab/experiments/view-experiment-aspects" do
  #     login 'user_with_aspects'
  #   end
  # end

  test "creating experiments" do
    VCR.use_cassette "deterlab/experiments/create-experiment" do
      login

      pid   = "SPIdev"
      ename = "Test"
      eid   = "#{pid}:#{ename}"

      assert create_experiment(pid, ename), "Could not create an experiment"
      experiment = view_experiments(pid).find { |e| e.id == eid }
      assert remove_experiment(pid, ename), "Could not delete the experiment"
      assert experiment, "Experiment was added, but was not found"
    end
  end

  test "getting experiments profile description" do
    VCR.use_cassette "deterlab/experiments/get-profile-description" do
      fields = DeterLab.get_experiment_profile_description
      assert_equal [ ProfileField.new("description", "string", false, "READ_WRITE", "Description", nil, nil, "0", nil) ], fields
    end
  end

  private

  def create_experiment(pid = "SPIdev", eid = "Test")
    DeterLab.create_experiment(@username, pid, eid, { description: "Custom description" })
  end

  def remove_experiment(pid = "SPIdev", eid = "Test")
    DeterLab.remove_experiment(@username, "#{pid}:#{eid}")
  end

  def view_experiments(pid = "SPIdev")
    DeterLab.view_experiments(@username, project_id: "SPIdev")
  end

end
