require "rails_helper"

RSpec.describe NotificationsController, type: :controller do

  let!(:user){create :user}
  let!(:organization){create :organization}
  let!(:club) do
    create :club, organization: organization
  end
  let!(:user_club) do
    create :user_club, user: user, club: club, status: 1
  end
  let!(:event) do
    create :event, club: club, user: user
  end
  let!(:activity) do
    FactoryGirl.create :activity, trackable_type: "Club", container_id: organization.id, owner_type: "User", container_type: "Organization", owner_id: user.id, trackable_id: club.id
  end
  before do
    sign_in user
  end

  describe "GET #index" do
    context "when show all index" do
      before do
        get :index
      end
      it {expect(response).to be_ok}
    end
    context "when not user not joined club" do
      before do
        get :index
      end
      it {expect(flash[:danger]).to eq "Bạn không có thông báo nào"}
    end
  end
end
