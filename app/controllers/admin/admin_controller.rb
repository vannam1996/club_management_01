class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_layout"

  private

  def namespace
    controller_name_segments = params[:controller].split("/")
    controller_name_segments.pop
    controller_name_segments.join("/").camelize
  end

  def current_ability
    @current_ability ||= Ability.new current_admin, namespace
  end
end
