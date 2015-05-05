class Notification < Struct.new(:id, :body, :tags, :sent)

  URGENT = "URGENT"
  READ   = "READ"

  def urgent?
    self.tags.find { |e| e[:tag] == URGENT }.try(:[], :is_set)
  end

  def read?
    self.tags.find { |e| e[:tag] == READ }.try(:[], :is_set)
  end

  def sent_on_formatted
    Time.parse(sent).strftime("%Y-%m-%d%l:%M%P")
  end

end
