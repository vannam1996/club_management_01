require "rails_helper"

RSpec.describe StatisticReport, type: :model do
  context "associations" do
    it {is_expected.to belong_to :club}
    it {is_expected.to belong_to :user}
  end
  context "validates" do
    it {is_expected.to validate_presence_of :style}
    it {is_expected.to validate_presence_of :item_report}
    it {is_expected.to validate_presence_of :detail_report}
    it {is_expected.to validate_presence_of :plan_next_month}
  end
end
