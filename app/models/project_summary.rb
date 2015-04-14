class ProjectSummary < Struct.new(:project_id, :approved, :description, :owner, :members, :experiments)
end
