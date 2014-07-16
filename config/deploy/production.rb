set :deploy_to, '/var/www/omniapi'
set :branch, 'production'

role :app, %w(deploy@5.10.81.84)
role :web, %w(deploy@5.10.81.84)
