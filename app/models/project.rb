class Project < Struct.new(:project_id, :owner, :approved, :members)

  PROFILE_FIELDS = %w{ description funding listing org_type website research_focus }

  def admin?
    self.project_id.try(:downcase) == 'admin'
  end

  # True if can modify ACL
  def can_modify_access?(uid)
    owner == uid || (members.find { |m| m.uid == uid && m.permissions.include?("ADD_USER") && m.permissions.include?("REMOVE_USER") }.present?)
  end

  # True if the user can modify the project
  def can_modify?(uid)
    owner == uid
  end

  private

  # normalized permissions list which is always an array without blanks
  def normalized_perms
    unless defined? @normalized_perms
      @normalized_perms = [ self.perms ].flatten.reject(&:blank?)
    end
    @normalized_perms
  end
end
