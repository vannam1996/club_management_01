class ActivitiesController < ApplicationController
  before_action :load_activity, only: :create

  def create
    if @activity.user_read.blank?
      arr_read = [current_user.id]
    else
      arr_read = @activity.user_read
      if !arr_read.include?(current_user.id)
        arr_read = arr_read.push(current_user.id)
      end
    end
    @activity.update_attributes user_read: arr_read
  end

  private
  def load_activity
    @activity = Activity.find_by id: params[:id]
    return if @activity
    flash[:danger] = t("not_foud_activity")
    redirect_to root_url
  end
end
