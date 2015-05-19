require 'test_helper'

class ExperimentAspectTest < ActiveSupport::TestCase

  setup do
    @a = ExperimentAspect.new("p:e", "layout000", "layout", "", "some data", "ref")
  end

  test 'formatting xml' do
    @a.raw_data = Base64.encode64("<a><b>test</b></a>")
    assert_equal "<a>\n  <b>test</b>\n</a>", @a.data
  end

  test 'not formatting non-xml' do
    @a.raw_data = Base64.encode64("test")
    assert_equal "test", @a.data
  end

  test 'extended attributes' do
    assert_equal   "p:e:layout000", @a.xa_key
    assert_not_nil @a.xa
  end

  test "setting xa" do
    @a.xa['key'] = '123'
    assert_not_nil '123', @a.xa['key']
  end

  test "#root?" do
    { "" => true, " " => true, nil => true, "full" => false }.each do |sub_type, root|
      assert_equal root, ExperimentAspect.new("p:e", "layout000", "layout", sub_type, "data", "ref").root?
    end
  end

  test "#last_updated_at" do
    assert_nil aspect_with_lua(nil)
    assert_nil aspect_with_lua("")

    now = Time.now
    assert_equal now.to_f, aspect_with_lua(now).to_f
    assert_equal now.to_f, aspect_with_lua(now.to_f).to_f
  end

  private

  def aspect_with_lua(v)
    a = ExperimentAspect.new("p:e", "layout000", "layout", "", "data", "ref")
    a.last_updated_at = v
    a.last_updated_at
  end
end
