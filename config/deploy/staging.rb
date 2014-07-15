set :deploy_to, '/var/www/omniapi_staging'
set :branch, 'staging'

role :app, %w(deploy@46.16.191.69)
role :web, %w(deploy@46.16.191.69)
