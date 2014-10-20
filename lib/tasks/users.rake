namespace :users do
  class UsersOutput
    def self.puts(string)
      Kernel.puts string
    end
  end

  desc 'Returns the emails of all active users'
  task :active, [:interval] => [:environment] do |_t, args|
    interval = args[:interval] || 1.week.ago
    users = []

    User.all.each do |u|
      events = u.events.where(:created_at.gt => interval)
      clippings = u.clippings.where(:created_at.gt => interval)

      users << u if events.any? || clippings.any?
    end

    UsersOutput.puts(users.map(&:email)) unless users.empty?
  end
end
