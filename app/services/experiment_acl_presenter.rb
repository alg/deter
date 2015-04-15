class ExperimentAclPresenter

  attr_reader :owner_perms
  attr_reader :other_users_acl
  attr_reader :project_perms
  attr_reader :groups_acl

  def initialize(acls, owner_uid, pid)
    @acls = acls

    @owner_perms      = nil
    @other_users_acl  = []
    @project_perms    = nil
    @groups_acl       = []

    owner_cid = "#{owner_uid}:#{owner_uid}"
    project_cid = "#{pid}:#{pid}"
    @acls.each do |a|
      cid = a.circle_id
      if cid == owner_cid
        @owner_perms = a.permissions
      elsif cid =~ /^[a-z]/
        @other_users_acl << [ a.circle_id.split(':').first, a.permissions ]
      elsif cid == project_cid
        @project_perms = a.permissions
      else
        @groups_acl << a
      end
    end
  end

end
