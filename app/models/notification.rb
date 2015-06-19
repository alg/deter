class Notification < Struct.new(:id, :body, :tags, :sent)

  TYPE_NEW_PROJECT  = "New Project"
  TYPE_JOIN_PROJECT = "Join"
  TYPE_OTHER        = "Other"

  URGENT = "URGENT"
  READ   = "READ"

  attr_reader :type
  attr_reader :sender
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

  def formatted_sender(deter_lab = nil)
    unless defined? @formatted_sender
      full_name = deter_lab.nil? ? nil : deter_lab.get_profile(@sender).try(:[], 'name')
      @formatted_sender = full_name.present? ? "#{full_name} (#{@sender})" : @sender
    end
    @formatted_sender
  end

  def formatted_body(deter_lab = nil)
    if @type == TYPE_JOIN_PROJECT
      "#{formatted_sender(deter_lab)} has made a request to join the project #{@project_id} that you manage. To accept or reject join requests, <a href='/join_project_requests/#{self.id}?type=join&challenge=#{@challenge}'>click here</a>."
    elsif @type == TYPE_NEW_PROJECT
      "#{formatted_sender(deter_lab)} has made a request to create a new project #{@project_id}. To accept or reject new projects requests, <a href='/new_project_requests'>click here</a>."
    else
      self.body
    end
  end

  def to_json(deter_lab = nil)
    { id:          self.id,
      body:        formatted_body(deter_lab),
      time:        sent,
      type:        @type,
      read:        read?,
      urgent:      urgent?,
      sender:      formatted_sender(deter_lab),
      project_id:  @project_id,
      challenge:   @challenge }
  end

  private

  def parse_body
    if self.body =~ /\A(.+) has asked to join your project (.+)\..* challenge (.+)\n*\z/m
      @type           = TYPE_JOIN_PROJECT
      @sender         = $1
      @project_id     = $2
      @challenge      = $3.strip
    elsif self.body =~ /\A(.+) has created a new project (.+?)\./
      @type           = TYPE_NEW_PROJECT
      @sender         = $1
      @project_id     = $2
    else
      @type           = TYPE_OTHER
      @sender         = 'Admin'
    end
  end

end
