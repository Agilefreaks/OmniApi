set :deploy_to, '/var/www/omniapi'
set :branch, 'staging'

set :rack_env, 'staging'

role :app, %w(deploy@46.16.191.69)
role :web, %w(deploy@46.16.191.69)
