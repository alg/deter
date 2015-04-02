# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'deter'
set :repo_url, 'git@github.com:alg/deter.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/alg/sites/deter.noizeramp.com'

# Default value for :pty is false
# set :pty, true

set :format, :pretty
set :log_level, :info

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
set :default_env, { path: "~/.rbenv/shims:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :deter do

  task :seed do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          puts "Seeding database. Please wait..."
          c = capture :rake, 'deter:seed', "ADMIN=\"#{ENV['admin']}\" PASS=\"#{ENV['pass']}\""
          puts c.gsub(/^D,.*net_http\)$\n/, '')
        end
      end
    end
  end

end
