require 'services/deter_lab/abstract_test'
require 'webmock/minitest'

class DeterLab::NotificationsTest < DeterLab::AbstractTest

  test "it should return false for bad login" do
    VCR.use_cassette "deterlab/notifications/get-notifications" do
      login "aadams"
      ns = DeterLab.get_notifications(@username)

      assert_equal 1, ns.length

      n = ns.first
      assert_equal "aackermann has asked to join your project Alfa-Romeo.\n\nThat change will not take effect until you respond to the project challenge 6391553366249095586\n\n", n.body
      assert       !n.urgent?
      assert       !n.read?
      assert_equal "63", n.id
      assert_equal "2015-05-04 5:47pm", n.sent_on_formatted
    end
  end

end
