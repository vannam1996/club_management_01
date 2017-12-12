require "rails_helper"

RSpec.describe  SetActiveClubsController, type: :controller do

  let!(:user){create :user}
  let!(:organization){create :organization}
  let(:club) do
    create :club, organization: organization
  end

  before do
    sign_in user
  end

  describe "GET #edit" do
    it "update club true" do
      request_params = FactoryGirl.attributes_for(:club)
      expect do
        get :edit, params: {id: club, active: 0}
      end.to change(Club, :count).by 1
    end
    it "update club true" do
      request_params = FactoryGirl.attributes_for(:club)
      expect do
        get :edit, params: {id: club, active: 1}
      end.to change(Club, :count).by 1
    end
    it "update club failed" do
      request_params = FactoryGirl.attributes_for(:club)
      expect do
        get :edit, params: {id: club, active:nil}
      end.to change(Club, :count).by 1
    end
    context "when params not present" do
      before {get :edit, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("not_found")}
    end
  end
end
