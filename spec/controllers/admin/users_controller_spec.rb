require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  let!(:admin){create :admin}
  let!(:user){create :user}

  before do
    sign_in admin
  end

  describe "get #index" do
    context "with nil params" do
      it "get with params q nil" do
        get :index, xhr: true
        expect(response).to be_ok
      end
    end
    context "with params present" do
      it "get with params q present" do
        get :index, xhr: true, params: {full_name_or_email_cont: user.full_name}
        expect(response).to be_ok
      end
    end
  end

  describe "get #edit" do
    context "with params present" do
      it "get success with params user_id valid" do
        get :edit, xhr: true, params: {id: user.id}
        expect(response).to be_ok
      end
      it "get errors with params user_id invalid" do
        get :edit, xhr: true, params: {id: user.id + 1}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("can_not_found_user")
      end
    end
  end

  describe "get #show" do
    context "with params present" do
      it "get success with params user_id valid" do
        get :show, xhr: true, params: {id: user.id}
        expect(response).to be_ok
      end
      it "get errors with params user_id invalid" do
        get :show, xhr: true, params: {id: user.id + 1}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("can_not_found_user")
      end
    end
  end

  describe "get #new" do
    context "with params nil" do
      it "get success" do
        get :new, xhr: true
        expect(response).to be_ok
      end
    end
  end

  describe "post #create" do
    context "with params present" do
      it "create success with params user valid" do
        expect do
          post :create, xhr: true, params: {user: {full_name: "name user",
            email: "mail@gmail.com", password: "password", password_confirmation: "password"}}
        end.to change(User, :count).by 1
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("admin_manage.create_success")
      end
      it "create errors with params user invalid" do
        expect do
          post :create, xhr: true, params: {user: {full_name: "",
            email: "", password: "", password_confirmation: "password"}}
        end.to change(User, :count).by 0
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("admin_manage.errors")
      end
    end
  end

  describe "patch #update" do
    context "with params present" do
      it "update success with params user valid" do
        patch :update, xhr: true, params: {id: user.id, user: {full_name: "name user",
          email: "mail@gmail.com", password: "password", password_confirmation: "password"}}
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("admin_manage.update_success")
      end
      it "update errors with params user invalid" do
        patch :update, xhr: true, params: {id: user.id, user: {full_name: "",
          email: "", password: "", password_confirmation: "password"}}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("admin_manage.errors")
      end
    end
  end

  describe "delete #destroy" do
    context "with params present" do
      it "destroy success" do
        expect do
          delete :destroy, xhr: true, params: {id: user.id}
        end.to change(User, :count).by -1
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("admin_manage.destroy_success")
      end
    end
  end
end
