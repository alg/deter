class ExperimentACL < Struct.new(:circle_id, :permissions)

  READ_EXPERIMENT          = "READ_EXPERIMENT"
  MODIFY_EXPERIMENT_ACCESS = "MODIFY_EXPERIMENT_ACCESS"
  MODIFY_EXPERIMENT        = "MODIFY_EXPERIMENT"

  # All experiment permissions.
  ALL_PERMS = [ MODIFY_EXPERIMENT_ACCESS, READ_EXPERIMENT, MODIFY_EXPERIMENT ]

  # No permissions. Used to delete ACL records.
  DELETE    = []

end
