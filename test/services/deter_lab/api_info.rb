require 'services/deter_lab/abstract_test'

class DeterLab::ApiInfoTest < DeterLab::AbstractTest

  test "version returns version" do
    VCR.use_cassette "deterlab/api_info/version" do
      assert_equal "0.2/0.0", DeterLab.version
    end
  end

end
