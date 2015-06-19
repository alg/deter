class Notification < Struct.new(:id, :body, :tags, :sent)

  TYPE_NEW_PROJECT  = :new_project
  TYPE_JOIN_PROJECT = :join_project
  TYPE_OTHER        = :other

  URGENT = "URGENT"
  READ   = "READ"

  attr_reader :type
  attr_reader :user
  attr_reader :project_id
  attr_reader :challenge

  def initialize(id, body, tags, sent)
    super(id, body, tags, sent)
    parse_body
  end

  def urgent?
    self.tags.find { |e| e[:tag] == URGENT }.try(:[], :is_set)
  end

  def read?
    self.tags.find { |e| e[:tag] == READ }.try(:[], :is_set)
  end

  def sent_on_formatted
    Time.parse(sent).strftime("%Y-%m-%d%l:%M%P")
  end

  def join_project_request?
    @type == TYPE_JOIN_PROJECT
  end

  def new_project_request?
    @type == TYPE_NEW_PROJECT
  end

  private

  def parse_body
    if self.body =~ /\A(.+) has asked to join your project (.+)\. .* challenge (.+)\z/
      @type           = TYPE_JOIN_PROJECT
      @user           = $1
      @project_id     = $2
      @challenge      = $3
    elsif self.body =~ /\A(.+) has created a new project (.+?)\./
      @type           = TYPE_NEW_PROJECT
      @user           = $1
      @project_id     = $2
    else
      @type           = TYPE_OTHER
    end
  end

end
