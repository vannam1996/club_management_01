FactoryGirl.define do
  factory :statistic_report do
    user_id user
    style 2
    club_id club
    item_report{Faker::Lorem.sentence}
    detail_report{Faker::Lorem.sentence}
    plan_next_month{Faker::Lorem.sentence}
    time 2
    status 2
  end
end
