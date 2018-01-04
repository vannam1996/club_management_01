# class Manager::ImportUsersController < BaseOrganizationManagerController
#   before_action :load_organization, only: :create

#   def create
#     if params[:file].present?
#       if User.open_spreadsheet(params[:file]) == Settings.error_import
#         flash[:danger] = t("errors_file_format")
#       else
#         if User.import_file(params[:file], @organization) == Settings.error_data
#           flash[:danger] = t("errors_file_user")
#         else
#           flash[:success] = t("import_success")
#         end
#       end
#     else
#       flash[:danger] = t("import_file")
#     end
#     redirect_to :back
#   end
# end
