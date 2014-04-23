role :app, %w(deploy@46.16.191.69)
role :web, %w(deploy@46.16.191.69)

set :deploy_to, '/var/www/omniapi_staging'
set :branch, 'master'

set :puma_workers, 4
