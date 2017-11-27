FactoryGirl.define do
  factory :event do
    name{Faker::Name.name}
    club_id club
    user_id user
  end
end
