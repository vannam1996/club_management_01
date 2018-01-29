namespace :db do
  desc "add_report_category"
  task add_report_category: :environment do
    organization = Organization.all
    organization.each do |org|
      org.report_categories.create name: "Báo cáo chi tiêu", status: 1, status_active: 1,
        style_event: [1, 2, 0, 4], style: 1
      org.report_categories.create name: "Báo cáo hoạt động", status: 1, status_active: 1,
        style_event: [3], style: 2
    end
  end
end
