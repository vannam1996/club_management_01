require "rails_helper"

RSpec.describe SetUserClubsController, type: :controller do

  let(:user){create :user}
  let(:user2){create :user}
  let(:organization){create :organization}
  let(:club) do
    create :club, organization: organization
  end
  let(:user_club) do
    create :user_club, user: user, club: club, status: "joined"
  end
  let(:user_club2) do
    create :user_club, user: user2, club: club, status: "joined"
  end
  before do
    sign_in user
  end

  describe "PATCH #update" do
    context "when params[:club_id] present" do
      before {get :update, params: {id: club.id}}
      it {expect(flash[:success]).to eq "Bạn đã xử lý thành công"}
    end
    context "when params[:id] not present" do
      before {get :update, params: {id: 0}}
      it {expect(flash[:danger]).to eq "Câu lạc bộ này không tồn tại"}
    end
    context "when params[:club_id] present" do
      before {get :update, params: {id: club.id, roles: ["1","0"]}}
      it {expect(assigns(:user_club)).to eq [user_club, user_club2]}
      it {expect(flash[:success]).to eq "Bạn đã xử lý thành công"}
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new user club" do
        request_params = FactoryGirl.attributes_for(:user_club)
        expect do
          post :create, params: {user_id: [user.id], id: club.id}
        end.to change(UserClub, :count).by 1
        expect(flash[:success]).to be_present
      end

      it "create fail with user_id nil" do
        request_params = FactoryGirl.attributes_for :user_club, user_id: nil
        expect do
          post :create, params: {id: club.id}
        end.to change(UserClub, :count).by 0
        expect(flash[:danger]).to be_present
      end
    end
    context "when params[:id] not present" do
      before {get :update, params: {id: 0}}
      it {expect(flash[:danger]).to eq "Câu lạc bộ này không tồn tại"}
    end
  end
end
