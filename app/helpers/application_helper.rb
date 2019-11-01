module ApplicationHelper
  def merchants_dropdown
    "<li class=\"nav-item dropdown\">".html_safe +
    "<a class=\"nav-link dropdown-toggle\" href=\"#\" id=\"navbarDropdown\" role=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"false\">".html_safe +
    "Merchants".html_safe +
    "</a>".html_safe +
    "<div class=\"dropdown-menu\" aria-labelledby=\"navbarDropdown\">".html_safe +
    Merchant.all.map do |merchant|
      if session[:merchant_id] == nil || session[:merchant_id] != merchant.id
        link_to merchant.username, merchant_path(merchant.id), class:"dropdown-item"
      end
    end.join(" ").html_safe +
    "</div>".html_safe +
    "</li>".html_safe
    
  end
  
  def categories_dropdown
    "<li class=\"nav-item dropdown\">".html_safe +
    "<a class=\"nav-link dropdown-toggle\" href=\"#\" id=\"navbarDropdown\" role=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"false\">".html_safe +
    "Categories".html_safe +
    "</a>".html_safe +
    "<div class=\"dropdown-menu\" aria-labelledby=\"navbarDropdown\">".html_safe +
    Category.all.map do |category|
      link_to category.name, category_path(category.id), class:"dropdown-item"
    end.join(" ").html_safe +
    "</div>".html_safe +
    "</li>".html_safe
  end
  
  def readable_date(date)
    return "[unknown]" unless date
    return (
    "<span class='date' title='".html_safe +
    date.to_s +
    "'>".html_safe +
    time_ago_in_words(date) +
    " ago</span>".html_safe
    )
  end
end
