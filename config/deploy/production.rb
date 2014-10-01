set :deploy_to, '/var/www/omniapi'
set :branch, 'production'

set :rails_env, 'production'

role :app, %w(deploy@178.62.222.16 deploy@178.62.222.22)
role :web, %w(deploy@178.62.222.16 deploy@178.62.222.22)
