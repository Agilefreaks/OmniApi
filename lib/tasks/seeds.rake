require_relative '../../lib/jobs/seed_scopes_job'

namespace :seed do
  desc 'Seed Scopes'
  task scopes: [:environment] do
    SeedScopesJob.new.perform
  end
end
