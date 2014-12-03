require 'services/deter_lab/abstract_test'

class DeterLab::ExperimentsTest < DeterLab::AbstractTest

  test "getting experiments" do
    VCR.use_cassette "deterlab/experiments/view-experiments" do
      login
      list = DeterLab.get_user_experiments(@username)
      assert_equal [
        Experiment.new("Megaproj:One", "bfdh", [
          ExperimentACL.new("Megaproj:Megaproj", [ "MODIFY_EXPERIMENT_ACCESS", "MODIFY_EXPERIMENT", "READ_EXPERIMENT" ]),
          ExperimentACL.new("bfdh:bfdh", [ "MODIFY_EXPERIMENT_ACCESS", "MODIFY_EXPERIMENT", "READ_EXPERIMENT" ])
        ])
      ], list
    end
  end

  test "getting experiment with aspects" do
    VCR.use_cassette "deterlab/experiments/view-experiment-aspects" do
      login 'user_with_aspects'
    end
  end

  test "creating experiments" do
    VCR.use_cassette "deterlab/experiments/create-experiment" do
      login

      pid   = "Megaproj"
      ename = "Test"
      eid   = "#{pid}:#{ename}"

      assert DeterLab.create_experiment(@username, pid, ename, { description: "Custom description" }), "Could not create an experiment"
      experiment = DeterLab.get_user_experiments(@username).find { |e| e.name == eid }
      assert DeterLab.remove_experiment(@username, eid), "Could not delete the experiment"
      assert experiment, "Experiment was added, but was not found"
    end
  end

  test "getting experiments profile description" do
    VCR.use_cassette "deterlab/experiments/get-profile-description" do
      fields = DeterLab.get_experiment_profile_description
      assert_equal [ ProfileField.new("description", "string", false, "READ_WRITE", "Description", nil, nil, "0", nil) ], fields
    end
  end

end
