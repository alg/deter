class ProjectSummaryLoader

  # Loads the summary of projects for the given user.
  def self.load(uid)
    cache = DeterCache.new(uid)
    cache.fetch "projects_summary", 30.minutes do
      perform_load(uid, cache)
    end
  end

  def self.perform_load(uid, cache)
    DeterLab.view_projects(uid).inject([]) do |m, project|
      # owner
      user_profile = cache.fetch_global "profile:#{project.owner}", 30.minutes do
        DeterLab.get_user_profile(uid, project.owner)
      end
      owner = { uid: project.owner, name: user_profile["name"] }

      # experiments
      experiments_count = cache.fetch_global "experiments_count:#{project.project_id}", 30.minutes do
        DeterLab.view_experiments(uid, project_id: project.project_id).size
      end

      m << {
        project_id:   project.project_id,
        approved:     project.approved,
        leader:       owner,
        members:      project.members.size,
        experiments:  experiments_count }

      m
    end
  end

end
