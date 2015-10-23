module ApplicationHelper
  def fix_url(str)
    str.starts_with?("http://") ? str : "http://#{str}"
  end

  def format_date_time(time_obj)
    time_obj.strftime("%m/%d/%Y at %I:%M%p")
  end

  def sort_posts_by_total_votes(posts)
    posts.sort_by { |post| post.total_votes }.reverse
  end

  def sort_comments_by_total_votes(comments)
    comments.sort_by { |comment| comment.total_votes }.reverse
  end
end
