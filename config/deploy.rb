require "bundler/capistrano"
require "sidekiq/capistrano"
 
server "192.241.228.196", :web, :app, :db, primary: true
 
set :application, "conic"
set :user, "joseph"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :port, "22"
 
set :scm, "git"
set :repository, "git@github.com:jalquisola/#{application}.git"
set :branch, "master"
 
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
 

desc "Run tasks in production enviroment"
#task :production do
#  #ec2_servers(:env => "production", :role => "app", :type => "primary").each do |server|
#  #  server server.dns_name, :web, :app, :db, :primary => true
#  #end
#
#  #ec2_servers(:env => "production", :role => "app", :type => "secondary").each do |server|
#  #  server server.dns_name, :web, :app, :db, :primary => false
#  #end
#
#  set :domain, "ikonikmo.com"
#  set :rails_env, :production
#  set :stage, :production
#  set :application, "conic"
#  set :deploy_to, "/home/#{user}/#{rails_env}/#{application}"
#  set :unicorn_config_path, "#{shared_path}/config/unicorn.rb"
#  set :unicorn_pid_path, "#{shared_path}/pids/unicorn.pid"
#  set :unicorn_socket, "#{shared_path}/sockets/unicorn.sock"
#  set :rainbows_config_path, "#{shared_path}/config/rainbows.rb"
#  set :rainbows_pid_path, "#{shared_path}/pids/rainbows.pid"
#  set :rainbows_socket, "#{shared_path}/sockets/rainbows.sock"
#
#  if find_servers(:roles => :app, :except => {:primary => true}).count > 0
#    after "deploy:assets:precompile", "deploy:assets:sync_from_primary"
#    after "sitemap:refresh", "sitemap:sync_from_primary"
#  end
#
#  after "deploy", "sitemap:refresh"
#  after "deploy:update", "newrelic:notice_deployment"
#end
 
after "deploy", "deploy:cleanup" # keep only the last 5 releases
namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
 
  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    put File.read("config/dailymile.yml.example"), "#{shared_path}/config/dailymile.yml"
    put File.read("config/redis.yml.example"), "#{shared_path}/config/redis.yml"
    put File.read("config/sidekiq.yml.example"), "#{shared_path}/config/sidekiq.yml"
    put File.read("config/twitter.yml.example"), "#{shared_path}/config/twitter.yml"
    put File.read("config/globe_labs.yml.example"), "#{shared_path}/config/globe_labs.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"
 
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/dailymile.yml #{release_path}/config/dailymile.yml"
    run "ln -nfs #{shared_path}/config/redis.yml #{release_path}/config/redis.yml"
    run "ln -nfs #{shared_path}/config/sidekiq.yml #{release_path}/config/sidekiq.yml"
    run "ln -nfs #{shared_path}/config/twitter.yml #{release_path}/config/twitter.yml"
    run "ln -nfs #{shared_path}/config/globe_labs.yml #{release_path}/config/globe_labs.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
 
  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

