module ApplicationHelper
  
  def readable_date(date)
    return "[unknown]" unless date
    return (
      "<span title='".html_safe +
      date.to_s +
      "'>".html_safe +
       date.strftime("%b %d, %Y")+
      "</span>".html_safe
    )
  end

  def currency_format(num)
    return("$" + sprintf('%.2f', num))
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
    rating_img = "https://live.staticflickr.com/65535/48983817713_d25a3fba98_o.png"
    return image_tag (rating_img), alt:"pineapple rating image", class: "rating-img"
  end

  def fruitstand_img
    stand_img = "https://live.staticflickr.com/65535/48982995833_9783f655fb_o.png"
    return image_tag (stand_img), alt:"fruitstand icon image", class: "fruitstand-img"
  end

  def white_fruit_img
    image = "https://www.iconsdb.com/icons/preview/white/apple-2-xxl.png"
    return image_tag (image), alt:"fruit icon image", class: "white-fruit-img"
  end
end
