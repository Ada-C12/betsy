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

  def currency_format(num)
    
  end

  def fruit_image(code, fruit)
    category = Category.find_by(name: fruit)
    if category
      image = image_tag "https://live.staticflickr.com/65535/#{code}_o.png", alt:"#{fruit} vector image", class:"fruit-img"
      return link_to image, category_products_path(category.id)
    end
  end

  def cart_empty_img_link
    image = image_tag "https://live.staticflickr.com/65535/48971625503_83d9d1c039_o.png pcc", alt:"cart fruit basket empty image", class:"basket-img"
    return link_to image, cart_path
  end

  def cart_full_img_link
    image = image_tag "https://live.staticflickr.com/65535/48971625483_e04b973cc8_o.png", alt:"cart fruit basket full image", class:"basket-img"
    return link_to image, cart_path
  end

  def product_img_link(product: product, img_url: img_url, product_class: product_class)
    image = image_tag (product.img_url), class: product_class, alt:"#{product.name} product image"
    return link_to image, product_path(product.id)
  end
  
  def rating_img
    rating_img = "https://live.staticflickr.com/65535/48965531738_c70c61c848_o.png"
    return image_tag (rating_img), alt:"pineapple rating image", class: "rating-img"
  end
end
