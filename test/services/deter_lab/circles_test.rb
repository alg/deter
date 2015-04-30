require 'services/deter_lab/abstract_test'

class DeterLab::CirclesTest < DeterLab::AbstractTest

  test "getting admin circle details" do
    VCR.use_cassette "deterlab/circles/view-circles-admin" do
      login 'admin_user'
      circles = DeterLab.view_circles(@username, "admin:admin")

      assert_equal 1, circles.size

      c = circles.first
      assert_equal "admin:admin", c.name
      assert_equal @username, c.owner
      assert_equal [
        CircleMember.new("deterboss", Circle::ALL_PERMS),
        CircleMember.new("spiuidev", Circle::ALL_PERMS),
        CircleMember.new("faber", Circle::ALL_PERMS)
      ], c.members
    end
  end

end
