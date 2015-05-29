class Experiment < Struct.new(:id, :owner, :acl, :aspects, :perms)

  def belongs_to_library?
    id =~ /^[a-z]/
  end

  def belongs_to_project?
    !belongs_to_library?
  end

  # True if the user fetching experiment data can modify the experiment access
  def can_modify_experiment_access?
    normalized_perms.include?(ExperimentACL::MODIFY_EXPERIMENT_ACCESS)
  end

  # True if the user fetching experiment data can modify the experiment
  def can_modify_experiment?
    normalized_perms.include?(ExperimentACL::MODIFY_EXPERIMENT)
  end

  # True if the user fetching experiment data can read the experiment
  def can_read_experiment?
    normalized_perms.include?(ExperimentACL::READ_EXPERIMENT)
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
