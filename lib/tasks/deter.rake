namespace :deter do

  task :seed => :environment do
    user = ENV['ADMIN']
    pass = ENV['PASS']

    if user.blank? || pass.blank?
      puts "Please provide admin user and pass in ADMIN and PASS env vars"
      exit 1
    end

    SeedTestData.new(user, pass).perform
  end

end
