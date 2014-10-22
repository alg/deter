require 'test_helper'

class DeterLabTest < ActiveSupport::TestCase

  test "version returns version" do
    VCR.use_cassette "deterlab-version" do
      assert_equal "0.2/0.0", DeterLab.version
    end
  end

end
