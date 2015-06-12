# Top level helpers
module ApplicationHelper
  def bootstrap_icon_link_to(text, url, icon, html_options = {})
    link_to url, html_options do
      "<i class=\"#{icon}\"></i> #{text}".html_safe
    end
  end

  def bootstrap_dropdown_button(text, icon, links)
    result = "<div class=\"btn-group\">
    <a class=\"btn dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">
    <i class=\"#{icon}\"></i> #{text}<span class=\"caret\"></span></a>
    <ul class=\"dropdown-menu\">"
    links.each do |l|
      result += "<li>#{l}</li>"
    end
    result += '</ul></div>'
    result.html_safe
  end

  def show_flash
    f = ''
    f += "<div class=\"alert alert-success\">#{notice}</div>" if notice
    f += "<div class=\"alert alert-error\">#{alert}</div>" if alert
    f.html_safe
  end

  def ticket_status_label(status)
    label = status.eql?('Open') ? 'important' : 'success'
    "<span class=\"label label-#{label}\">#{status}</span>".html_safe
  end

  def admin?
    current_user && current_user.is_admin?
  end

  def moderator?
    current_user && current_user.is_moderator?
  end

  def user?
    !moderator? && !admin?
  end
end
