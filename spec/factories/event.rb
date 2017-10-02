FactoryGirl.define do
  factory :event do
    name{Faker::Name.name}
    expense{Faker::Internet.email}
    location{Faker::PhoneNumber.phone_number}
    club_id club
    user_id user
  end
end
