module SponsorsHelper
  def check_experience_detail? experience
    experience[:event].blank? && experience[:time_and_place].blank? &&
      experience[:member].blank? && experience[:communication].blank?
  end

  def status_show sponsor
    if sponsor.rejected?
      t"#{sponsor.status}"
    else
      t"#{sponsor.status}"
    end
  end
end
