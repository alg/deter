require 'test_helper'

class SummaryLoaderTest < ActiveSupport::TestCase

  test "loading projects summary" do
    VCR.use_cassette "summary_loader/user_projects" do
      login
      res = SummaryLoader.user_projects("aadams")
      assert_equal [
        { project_id:   "Alfa-Romeo",
          approved:     true,
          leader:       { uid: "aadams", name: "Abigail Adams" },
          members:      3,
          experiments:  2 },
        { project_id:   "Beta-Test",
          approved:     true,
          leader:       { uid: "bberkley", name: "Buzzby Berkley" },
          members:      4,
          experiments:  2 },
        { project_id:   "Gamma-Ray",
          approved:     true,
          leader:       { uid: "ggrein", name: "Gerta Grein" },
          members:      3,
          experiments:  1 }
      ], res
    end
  end

  test "loading experiments summary" do
    VCR.use_cassette "summary_loader/user_experiments" do
      login
      res = SummaryLoader.user_experiments("aadams")
      assert_equal [
        { id:           "Alfa-Romeo:HelloWorld",
          owner:        { uid: "aadams", name: "Abigail Adams" },
          description:  "Custom experiment" },
        { id:           "Alfa-Romeo:ExperimentOne",
          owner:        { uid: "abierce", name: "Ambrose Bierce" },
          description:  "Custom experiment" },
        { id:           "Beta-Test:Beta-Dyne",
          owner:        { uid: "bberkley", name: "Buzzby Berkley" },
          description:  "Custom experiment" },
        { id:           "Beta-Test:Beta-Zed",
          owner:        { uid: "bberkley", name: "Buzzby Berkley" },
          description:  "Custom experiment" },
        { id:           "Gamma-Ray:Gamma-Exp",
          owner:        { uid: "bgreer", name: "Britt Greer" },
          description:  "Custom experiment" }
      ], res
    end
  end

  def login
    assert DeterLab.valid_credentials?("aadams", "Abigail")
  end

end
