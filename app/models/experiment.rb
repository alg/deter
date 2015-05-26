class Experiment < Struct.new(:id, :owner, :acl, :aspects)

  def belongs_to_library?
    id =~ /^[a-z]/
  end

  def belongs_to_project?
    !belongs_to_library?
  end

end
