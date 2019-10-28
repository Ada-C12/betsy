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

  def cart_empty_img_link
    image = image_tag "https://live.staticflickr.com/65535/48971455911_44134084cc_o.png", alt:"cart fruit basket empty image", class:"basket-img"
    return link_to image, cart_path
  end

  def cart_full_img_link
    image = image_tag "https://live.staticflickr.com/65535/48970902838_3acd5e8086_o.png", alt:"cart fruit basket full image", class:"basket-img"
    return link_to image, cart_path
  end
  

  


end
