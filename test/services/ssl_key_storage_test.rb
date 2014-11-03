require 'test_helper'

class SslKeyStorageTest < ActiveSupport::TestCase

  test "should return nil for missing keys" do
    assert_nil SslKeyStorage.get("unknown")
  end

  test "should store the certs" do
    SslKeyStorage.put("user_id", "cert", "cert_key")
    assert_equal [ "cert", "cert_key" ], SslKeyStorage.get("user_id")
  end

  test "deleting the key" do
    SslKeyStorage.put("user_id", "cert", "cert_key")
    SslKeyStorage.delete("user_id")
    assert_nil SslKeyStorage.get("user_id")
  end

end
