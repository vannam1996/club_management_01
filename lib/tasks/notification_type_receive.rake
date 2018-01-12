namespace :db do
  desc "Seeding data"
  task init_type_receive: :environment do
    %w[db:migrate].each do |task|
      Rake::Task[task].invoke
    end
    Activity.all.each do |activity|
      activity.update_attribute :type_receive, 1 unless activity.type_receive
    end
  end
end
