class ProfileFields < Array

  # Fields to show on form in that particular order
  DISPLAY_FIELDS = %w{ name title address city state zip country email URL phone affiliation affiliation_abbrev }

  def initialize(fields)
    super
  end

  # Returns the named profile field
  def [](name)
    idx = self.index { |f| f.name == name }
    idx && self.at(idx)
  end

end
