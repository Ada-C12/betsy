module ApplicationHelper
  
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

  def fruit_image(code, fruit)
    category = Category.find_by(name: fruit)
    if category
      image = image_tag "https://live.staticflickr.com/65535/#{code}_o.png", alt:"#{fruit} vector image", class:"fruit-img"
      return link_to image, category_products_path(category.id)
  end
  end


end
