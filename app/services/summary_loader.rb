class SummaryLoader

  # Loads the summary of projects for the given user.
  def self.user_projects(uid)
    cache = DeterCache.new(uid)
    cache.fetch "projects_summary", 30.minutes do
      get_user_projects(uid, cache)
    end
  end

  # Loads the summary of user experiments.
  def self.user_experiments(uid)
    cache = DeterCache.new(uid)
    cache.fetch "experiments_summary", 30.minutes do
      get_user_experiments(uid, cache)
    end
  end

  def self.get_user_experiments(uid, cache)
    DeterLab.view_experiments(uid).inject([]) do |m, ex|
      user_profile = member_profile(cache, uid, ex.owner)
      ex_profile   = DeterLab.get_experiment_profile(uid, ex.id)

      m << {
        id:    ex.id,
        owner: { uid: ex.owner, name: user_profile["name"] },
        description: ex_profile['description'].value
      }

      m
    end
  end

  def self.get_user_projects(uid, cache)
    DeterLab.view_projects(uid).inject([]) do |m, project|
      # owner
      user_profile = member_profile(cache, uid, project.owner)
      owner = { uid: project.owner, name: user_profile["name"] }

      # experiments
      experiments_count = project_experiments(cache, uid, project.project_id).size

      m << {
        project_id:   project.project_id,
        approved:     project.approved,
        leader:       owner,
        members:      project.members.size,
        experiments:  experiments_count }

      m
    end
  end

  def self.member_profile(cache, uid, member_id = uid)
    cache ||= DeterCache.new(uid)
    cache.fetch_global "profile:#{member_id}", 30.minutes do
      DeterLab.get_user_profile(uid, member_id)
    end
  end

  def self.project_experiments(cache, uid, project_id)
    cache.fetch_global "project:#{project_id}:experiments", 30.minutes do
      DeterLab.view_experiments(uid, project_id: project_id)
    end
  end
end
