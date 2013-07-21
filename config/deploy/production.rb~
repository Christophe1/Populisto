require 'rvm/capistrano'

server '92.51.243.6', :app, :web, :db, :bg, :primary => true

set :rvm_type, :user
set :rvm_ruby_string, 'ree-1.8.7-2012.02'

set :user, 'app'
set :password, "populisto@"
set :use_sudo, false

set :ssh_options, { :forward_agent => true }

set :branch, 'production'
set :rails_env, 'production'
set :deploy_to, '/var/www/apps/populisto/'
set :keep_releases, 10
