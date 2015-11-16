module ApplicationHelper
  def fix_url(str)
    str.starts_with?("http://") ? str : "http://#{str}"
  end

  def format_date_time(time_obj)
    if logged_in? && !current_user.time_zone.blank?
      time_obj = time_obj.in_time_zone(current_user.time_zone)
    end
    time_obj.strftime("%m/%d/%Y at %I:%M%p %Z")
  end

  def format_phone_number(string)
    "(#{string[0,3]}) #{string[3,3]}-#{string[6,4]}"
  end

  def sort_by_total_votes(obj)
    obj.sort_by { |obj| obj.total_votes }.reverse
  end

  def sort_by_total_votes(obj)
    obj.sort_by { |obj| obj.total_votes }.reverse
  end
end
