module DeterLab
  module Notifications

    # returns user notifications
    def get_notifications(uid, options = nil)
      cl = client("Users", uid)

      options ||= {}
      msg = { uid: uid }
      msg[:from]  = options[:from] if options[:from].present?
      msg[:to]    = options[:to] if options[:to].present?
      msg[:flags] = (options[:flags] || {}).map do |n, v|
        { tag: n, is_set: !!v }
      end

      response = cl.call(:get_notifications, message: msg)

      return [ response.to_hash[:get_notifications_response][:return] ].flatten.reject(&:blank?).map do |r|
        Notification.new(r[:id], r[:body], r[:flags], r[:sent])
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

    # marks notifications with specific flags
    def mark_notifications(uid, ids, flags)
      cl = client("Users", uid)

      response = cl.call(:mark_notifications, message: {
        uid: uid,
        ids: ids,
        flags: flags
      })
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
