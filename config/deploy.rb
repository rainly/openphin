require 'vendor/plugins/thinking-sphinx/lib/thinking_sphinx/deploy/capistrano'

set :application, "openphin"
set :repository,  "git://github.com/talho/openphin.git"
set :rails_env, 'production'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
 set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
RAILS_ENV="production"

role :app, "openphin.texashan.org"
role :web, "openphin.texashan.org"
role :db,  "openphin.texashan.org", :primary => true
set :scm, :git
set :branch, 'master'
set :use_sudo, false
set :user, 'apache'
set :git_enable_submodules, true
set :ssh_options, {:forward_agent => true}
set :deploy_via, :remote_cache
 
desc "mod_rails restart"
  namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
 
after 'deploy:update_code', 'deploy:symlink_configs'
after 'deploy:update_code', 'deploy:install_gems'
after 'deploy:install_gems', 'deploy:restart_backgroundrb'
after "deploy", "deploy:cleanup"

namespace :deploy do
  desc "we need a database. this helps with that."
  task :symlink_configs do
    rails_env = fetch(:rails_env, RAILS_ENV)
    #run "mv #{release_path}/config/database.yml.example #{release_path}/config/database.yml"
    run "ln -fs #{shared_path}/#{RAILS_ENV}.sqlite3 #{release_path}/db/#{RAILS_ENV}.sqlite3"
    run "ln -fs #{shared_path}/smtp.rb #{release_path}/config/initializers/smtp.rb"
    run "ln -fs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -fs #{shared_path}/sphinx #{release_path}/db/sphinx"
    run "ln -fs #{shared_path}/backgroundrb.yml #{release_path}/config/backgroundrb.yml"
    run "ln -fs #{shared_path}/swn.yml #{release_path}/config/swn.yml"
    run "ln -fs #{shared_path}/system.yml #{release_path}/config/system.yml"
    run "ln -fs #{shared_path}/phone.yml #{release_path}/config/phone.yml"
    run "ln -fs #{shared_path}/phin_ms_queues #{release_path}/tmp/phin_ms_queues"
    if rails_env == 'test'|| rails_env == 'development'
      FileUtils.cp("config/backgroundrb.yml.example", "config/backgroundrb.yml") unless File.exist?("config/backgroundrb.yml")
      FileUtils.cp("config/system.yml.example", "config/system.yml") unless File.exist?("config/backgroundrb.yml")
#      FileUtils.cp("config/phone.yml.example", "config/phone.yml") unless File.exist?("config/phone.yml")
#      FileUtils.cp("config/swn.yml.example", "config/swn.yml") unless File.exist?("config/swn.yml")
    end

  end

  desc "install any gem dependencies"
  task :install_gems, :role => :app do 
    rails_env = fetch(:rails_env, RAILS_ENV)
    run "cd #{release_path}; rake gems:install RAILS_ENV=#{rails_env}"
  end

  desc "restart backgroundrb"
  task :restart_backgroundrb, :role => :app do
    rails_env = fetch(:rails_env, RAILS_ENV)
    run "cd #{release_path}; script/backgroundrb restart -e production"
  end
end

after 'deploy:migrations', :seed
desc "seed. for seed-fu"
task :seed, :roles => :db, :only => {:primary => true} do 
  rails_env = fetch(:rails_env, RAILS_ENV)
  run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
end

set :pivotal_tracker_project_id, 19881
set :pivotal_tracker_token, '55a509fe5dfcd133b30ee38367acebfa'

after :deploy, 'pivotal_tracker:deliver_stories'

after "deploy:stop",    "delayed_job:stop"
after "deploy:stop",    "thinking_sphinx:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:start",   "thinking_sphinx:start"
after "deploy:restart", "delayed_job:restart"
after "deploy:restart", "thinking_sphinx:restart"
