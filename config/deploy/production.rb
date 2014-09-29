set :deploy_to, '/var/www/omniapi'
set :branch, 'production'

set :rails_env, 'production'

role :app, %w(deploy@apiproduction01.omnipasteapp.com deploy@apiproduction02.omnipasteapp.com)
role :web, %w(deploy@apiproduction01.omnipasteapp.com deploy@apiproduction02.omnipasteapp.com)
