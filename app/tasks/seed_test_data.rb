class SeedTestData

  PROJECT_DEFAULTS = {
    website: 'http://uso.edu/research',
    org_type: 'Academic',
    research_focus: 'Malware',
    funding: 'Academic Institution Support',
    listing: true
  }

  PROJECTS = {
    'Alfa-Romeo' => { description: 'Study the speed of malware spread in a closed environment.' },
    'Beta-Test'  => { description: 'Measure the effectiveness bot-net C&C surveillance.' },
    'Gamma-Ray'  => { description: 'Experiment with new methods of network based malware detection.' }
  }

  USER_DEFAULTS = {
    phone: '301/123-4567',
    title: 'Research Staff',
    affiliation: 'University of South Otago',
    affiliation_abbrev: 'USO',
    URL: 'http://uso.edu',
    address1: '123 Main St.',
    address2: '',
    city: 'South Ontago',
    state: 'Farallon',
    zip: '12345',
    country: 'US'
  }

  USERS = [
    { name: 'Abigail Adams', email: 'aadams@uso.edu', password: 'Abigail', owns_projects: [ 'Alfa-Romeo' ]  },
    { name: 'Arthur Ashe', email: 'aashe@uso.edu', password: 'Arthur', owns_projects: [] },
    { name: 'Ambrose Bierce', email: 'abierce@uso.edu', password: 'Ambrose', owns_projects: [] },
    { name: 'Buzzby Berkley', email: 'bberkley@uso.edu', password: 'Buzzby', owns_projects: [ 'Beta-Test' ] },
    { name: 'Britt Greer', email: 'bgreer@uso.edu', password: 'Britt', owns_projects: [] },
    { name: 'Gerta Grein', email: 'ggrein@uso.edu', password: 'Gerta', owns_projects: [ 'Gamma-Ray' ] }
  ]

  PROJECT_USERS = {
    'Alfa-Romeo' => [ 'Arthur Ashe', 'Ambrose Bierce' ],
    'Beta-Test'  => [ 'Abigail Adams', 'Ambrose Bierce', 'Britt Greer' ],
    'Gamma-Ray'  => [ 'Abigail Adams', 'Britt Greer' ]
  }

  PROJECT_PROFILE_ATTRS = [
    { name: "website", type: "STRING", optional: true, access: "READ_WRITE", description: "Project Web Site", sequence: 100, value: 0 },
    { name: "org_type", type: "STRING", optional: true, access: "READ_WRITE", description: "Project Organization Type", sequence: 200, value: 0 },
    { name: "research_focus", type: "STRING", optional: true, access: "READ_WRITE", description: "Project Research Focus", sequence: 300, value: 0 },
    { name: "funding", type: "STRING", optional: true, access: "READ_WRITE", description: "Project Funding or Support", sequence: 400, value: 0 },
    { name: "listing", type: "STRING", optional: true, access: "READ_WRITE", description: "Project Listing", sequence: 500, value: 0 }
  ]

  def initialize(admin_user, admin_pass)
    @admin_user = admin_user
    @admin_pass = admin_pass
    @user_ids = {}
  end

  def perform
    unless login
      raise "Invalid admin credentials. Set ADMIN_USERNAME and ADMIN_PASSWORD env variables."
    end

    ensure_project_profile_attributes

    USERS.each { |u| create_user(u) }
    PROJECT_USERS.each { |project_id, users| join_project(project_id, users) }

    return {
      user_ids: @user_ids
    }
  end

  def ensure_project_profile_attributes
    puts "Checking project profile attributes"
    attrs = DeterLab.get_project_profile_description
    present_attrs = attrs.map(&:name)

    PROJECT_PROFILE_ATTRS.each do |attr|
      next if present_attrs.include?(attr[:name])

      puts "  Creating project attribute: #{attr.inspect}"
      DeterLab.create_project_attribute(@admin_user, attr[:name], attr[:type], attr[:optional], attr[:access], attr[:description], attr[:sequence])
    end
  end

  private

  # attempts to login and returns true / false
  def login
    puts "Logging in as #{@admin_user}"
    DeterLab.valid_credentials?(@admin_user, @admin_pass)
  end

  def create_user(up)
    puts "Creating user #{up[:name]}"
    user_id = DeterLab.create_user_no_confirm(@admin_user, up[:password], USER_DEFAULTS.merge(name: up[:name], email: up[:email]))
    @user_ids[up[:name]] = user_id

    up[:owns_projects].each do |project_id|
      pp = PROJECTS[project_id] or raise("Project attributes for #{project_id} not found")
      puts "Creating project #{project_id} for #{user_id}"
      begin
        create_project(user_id, project_id, pp)
      rescue DeterLab::RequestError => e
        if e.message =~ /name conflict/
          puts "  ... exists. Recreating for our new user"
          DeterLab.remove_project(@admin_user, project_id)
          create_project(user_id, project_id, pp)
        else
          raise e
        end
      end
    end
  end

  def create_project(user_id, project_id, pp)
    DeterLab.create_project(@admin_user, project_id, user_id, PROJECT_DEFAULTS.merge(description: pp[:description]))
    DeterLab.approve_project(@admin_user, project_id)
  end

  def join_project(project_id, users)
    uids = users.map { |name| @user_ids[name] }
    DeterLab.add_users_no_confirm(@admin_user, project_id, uids)
  end

end
