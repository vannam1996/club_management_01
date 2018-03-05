module SponsorsHelper
  def check_experience experience
    experience[:event].blank? && experience[:time_and_place].blank? &&
      experience[:member].blank? && experience[:communication].blank?
  end
end
