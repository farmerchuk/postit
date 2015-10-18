module ApplicationHelper
  def fix_url(str)
    str.starts_with?("http://") ? str : "http://#{str}"
  end

  def format_date_time(time_obj)
    time_obj.strftime("%m/%d/%Y at %I:%M%p")
  end
end
