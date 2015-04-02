namespace :deter do

  task :seed => :environment do
    puts "user=#{ENV['admin']} pass=#{ENV['pass']}"
  end

end
