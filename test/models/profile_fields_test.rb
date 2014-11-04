require 'test_helper'

class ProfileFieldsTest < ActiveSupport::TestCase

  test "finding a field" do
    f = ProfileField.new("URL", "string", true, "READ_WRITE", "d", "f", "fd", 0, nil)
    fs = ProfileFields.new([ f ])

    assert_equal fs["URL"], f
    assert_nil   fs["missing"]
  end

end
