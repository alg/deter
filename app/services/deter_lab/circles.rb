module DeterLab
  module Circles

    # returns all #Circle objects belonging to the owner
    def view_circles(uid, regex = nil)
      cl = client("Circles", uid)

      message = { uid: uid }
      message[:regex] = regex unless regex.nil?

      response = cl.call(:view_circles, message: message)

      return [ response.to_hash[:view_circles_response][:return] || [] ].flatten.map do |i|
        members = i[:members].map do |m|
          CircleMember.new(m[:uid], m[:permissions])
        end

        Circle.new(i[:circle_id], i[:owner], members)
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
