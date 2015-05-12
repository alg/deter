require 'test_helper'

class ExperimentAspectTest < ActiveSupport::TestCase

  setup do
    @a = ExperimentAspect.new("x:a", "layout", "", "some data", "ref")
  end

  test 'extended attributes' do
    assert_equal   "x:a", @a.xa_key
    assert_not_nil @a.xa
  end

  test "setting xa" do
    @a.xa['key'] = '123'
    assert_not_nil '123', @a.xa['key']
  end

  test "#root?" do
    { "" => true, " " => true, nil => true, "full" => false }.each do |sub_type, root|
      assert_equal root, ExperimentAspect.new("x:a", "layout", sub_type, "data", "ref").root?
    end
  end
end
