# class Dashboard::RequestsController < BaseDashboardController
#   before_action :load_member
#   before_action :load_club, only: :update

#   def update
#     if params[:status].blank?
#       respond_to do |format|
#         member = @member.update_attributes is_manager: params[:is_manager]
#         send_email_manager_club @member, @club
#         if member
#           flash = t("success_process")
#         else
#           flash = t("error_process")
#         end
#         format.json{render json: {flash: flash, status: 200}}
#       end
#     else
#       member = @member.update_attributes status: params[:status].to_i
#       if params[:status].to_i == UserClub.statuses[:joined]
#         send_email_join_club @member, @club
#       end
#       if member
#         flash[:success] = t("success_process")
#         redirect_to :back
#       else
#         flash[:danger] = t("error_process")
#         redirect_to :back
#       end
#     end
#   end

#   private
#   def load_member
#     @member = UserClub.find_by id: params[:id]
#     unless @member
#       flash[:danger] = t "club_manager.cant_fount"
#       redirect_to dashboard_path
#     end
#   end

#   def send_email_manager_club user, club
#     ClubMailer.mail_to_user_manager_club(user, club).deliver_later
#   end

#   def send_email_join_club user, club
#     ClubMailer.mail_to_user_join_club(user, club).deliver_later
#   end
# end
