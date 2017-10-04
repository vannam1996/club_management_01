require "rails_helper"

RSpec.describe Dashboard::RequestsController, type: :controller do

  let(:user){create :user}
  let(:organization){create :organization}
  let!(:user_organization) do
    create :user_organization, user: user, organization: organization, is_admin: true
  end
  let!(:club_request) do
    create :club_request, user: user, organization: organization
  end

  before do
    sign_in user
  end

  describe "PATCH #update" do
    context "when params[:id] and status present" do
      before {get :update, params: {id: club_request.id , status: 1}}
      it {expect(flash[:success]).to eq "Bạn đã xử lý thành công"}
    end
    context "when params[:id] and status present" do
      before {get :update, params: {id: club_request.id , status: 2}}
      it {expect(flash[:success]).to eq "Bạn đã xử lý thành công"}
    end
    context "when params[:id] not present" do
      before {get :update, params: {id: 0 , status: 1}}
      it {expect(flash[:danger]).to eq "Không tìm thấy yêu cầu này"}
    end
  end

  describe "GET #show" do
    context "when params[:id] present" do
      before {get :show, params: {id: club_request.id}}
      it {expect(response).to be_ok}
    end
    context "when params[:id] not present" do
      before {get :show, params: {id: 0 , status: 1}}
      it {expect(flash[:danger]).to eq "Không tìm thấy yêu cầu này"}
    end
  end
end
