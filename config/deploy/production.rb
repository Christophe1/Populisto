require 'rvm/capistrano'

server '37.139.17.25', :app, :web, :db, :bg, :primary => true

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-1.8.7-p374'

set :user, 'populisto'
set :password, "populisto3102"
set :use_sudo, false

set :ssh_options, { :forward_agent => true }

set :branch, 'production'
set :rails_env, 'production'
set :deploy_to, '/home/populisto/apps/populisto/'
set :keep_releases, 5
