require "rails_helper"

RSpec.describe PostGallery, type: :model do
  context "associations" do
    it{is_expected.to belong_to :post}
  end
end
