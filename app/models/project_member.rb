class ProjectMember < Struct.new(:uid, :permissions)

  CREATE_EXPERIMENT = "CREATE_EXPERIMENT"
  CREATE_LIBRARY    = "CREATE_LIBRARY"
  REMOVE_USER       = "REMOVE_USER"
  CREATE_CIRCLE     = "CREATE_CIRCLE"
  ADD_USER          = "ADD_USER"

  # All permissions
  ALL_PERMS         = [ CREATE_EXPERIMENT, CREATE_LIBRARY, CREATE_CIRCLE, ADD_USER, REMOVE_USER ]

  # Default new user permissions
  DEFAULT_NEW_USER_PERMS = [ CREATE_EXPERIMENT, CREATE_LIBRARY, CREATE_CIRCLE ]

  # no permissions. Used to delete records.
  DELETE            = []

end
