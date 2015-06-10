class ProjectMember < Struct.new(:uid, :permissions)

  CREATE_EXPERIMENT = "CREATE_EXPERIMENT"
  CREATE_LIBRARY    = "CREATE_LIBRARY"
  REMOVE_USER       = "REMOVE_USER"
  CREATE_CIRCLE     = "CREATE_CIRCLE"
  ADD_USER          = "ADD_USER"

  # All permissions
  ALL_PERMS         = [ CREATE_EXPERIMENT, CREATE_LIBRARY, CREATE_CIRCLE, ADD_USER, REMOVE_USER ]

  # no permissions. Used to delete records.
  DELETE            = []

end
