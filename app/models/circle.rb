class Circle < Struct.new(:name, :owner, :members)

  ALL_PERMS = [ "REALIZE_EXPERIMENT", "REMOVE_USER", "ADD_USER" ]

end
