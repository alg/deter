class Project < Struct.new(:project_id, :owner, :approved, :members)

  PROFILE_FIELDS = %w{ description funding listing org_type website research_focus }

  def admin?
    self.project_id.try(:downcase) == 'admin'
  end

end
