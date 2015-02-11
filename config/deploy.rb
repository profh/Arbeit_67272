require 'bundler/capistrano'

server 'mousedata.link', :web, :app, :db, primary: true

set :application, 'arbeit'
set :user, 'deploy'
set :group, 'admin'
set :deploy_to, "/home/#{user}/apps/#{application}"

set :scm, 'git'
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :repository, "git@github.com:profh/Arbeit_2014.git"
set :branch, 'deploy'

set :use_sudo, false


# share public/uploads
set :shared_children, shared_children + %w{public/uploads}

# allow password prompt
default_run_options[:pty] = true

# turn on key forwarding
ssh_options[:forward_agent] = true

# keep only the last 5 releases
after 'deploy', 'deploy:cleanup'
after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared do
    # full path needs to be set up; use for security purposes in later deploys
    run "ln -s /home/deploy/apps/arbeit/shared/settings.yml /home/deploy/apps/arbeit/releases/#{release_name}/config/"
  end
end

before "deploy:assets:precompile", "deploy:symlink_shared"
after "deploy:symlink_shared", "deploy:migrations"