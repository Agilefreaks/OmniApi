# config valid only for Capistrano 3.2
lock '3.2.1'

set :application, 'OmniApi'
set :repo_url, 'git@github.com:Agilefreaks/OmniApi.git'

set :rvm_ruby_version, 'ruby-2.1.1@omniapi'

role :app, %w(deploy@46.16.191.69)
role :web, %w(deploy@46.16.191.69)

set :puma_workers, 4
set :puma_preload_app, true

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
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