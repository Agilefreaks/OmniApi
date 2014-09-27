set :deploy_to, '/var/www/omniapi'
set :branch, 'staging'

set :rails_env, 'staging'

role :app, %w(deploy@178.62.224.235)
role :web, %w(deploy@178.62.224.235)
