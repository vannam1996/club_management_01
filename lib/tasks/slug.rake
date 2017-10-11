namespace :db do
  desc "add_slug"
  task init_slug: :environment do
    puts "Create slug"
    Club.find_each(&:save)
    Organization.find_each(&:save)
  end
end
