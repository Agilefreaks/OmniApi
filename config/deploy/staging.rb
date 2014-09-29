set :deploy_to, '/var/www/omniapi'
set :branch, 'staging'

set :rails_env, 'staging'

role :app, %w(deploy@apistaging01.omnipasteapp.com)
role :web, %w(deploy@apistaging01.omnipasteapp.com)
