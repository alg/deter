require 'test_helper'

class ProjectSummaryLoaderTest < ActiveSupport::TestCase

  test "loading details" do
    VCR.use_cassette "project_summary_loader-details" do
      assert DeterLab.valid_credentials?("aadams16", "Abigail")

      res = ProjectSummaryLoader.load("aadams16")
      assert_equal [
        { project_id:   "Alfa-Romeo",
          approved:     true,
          leader:       { uid: "aadams16", name: "Abigail Adams" },
          members:      3,
          experiments:  2 },
        { project_id:   "Beta-Test",
          approved:     true,
          leader:       { uid: "bberkley16", name: "Buzzby Berkley" },
          members:      4,
          experiments:  2 },
        { project_id:   "Gamma-Ray",
          approved:     true,
          leader:       { uid: "ggrein16", name: "Gerta Grein" },
          members:      3,
          experiments:  1 },
        { project_id:   "xyz",
          approved:     false,
          leader:       { uid: "aadams16", name: "Abigail Adams" },
          members:      1,
          experiments:  2 }
      ], res
    end
  end

end
