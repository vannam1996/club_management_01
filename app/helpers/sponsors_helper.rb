module SponsorsHelper
  def check_experience_detail? experience
    experience[:event].blank? && experience[:time_and_place].blank? &&
      experience[:member].blank? && experience[:communication].blank?
  end
end