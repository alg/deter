namespace :deter do

  desc "Seeding test environment"
  task :seed => :environment do
    user = ENV['ADMIN'] || 'deterboss'
    pass = ENV['PASS']

    if user.blank? || pass.blank?
      puts "Please provide admin user and pass in ADMIN and PASS env vars"
      exit 1
    end

    SeedTestData.new(user, pass).perform
  end

  desc "Adding a user to a project"
  task :add_user_to_project => :environment do
    user = ENV['ADMIN'] || 'deterboss'
    pass = ENV['PASS']
    uid  = ENV['UID']
    pid  = ENV['PID']

    unless DeterLab.valid_credentials?(user, pass)
      puts "Admin user / password are incorrect"
      exit 1
    end

    if DeterLab.add_users_no_confirm(user, pid, [ uid ])
      puts "Added #{uid} to #{pid}"
    end
  end

end
