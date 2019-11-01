
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
# require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec
  add_filter '/test/' # for minitest
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def add_to_cart(product = products(:p_1), quantity = 1)
    order_item_params = { order_item: { quantity: quantity } }
    post add_to_cart_path(product), params: order_item_params
    find_cart
    return product
  end
  
  def find_cart
    @cart ||= Order.find_by(id: session[:order_id])
  end
  
  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(user)
    return {
      provider: user.provider,
      uid: user.uid,
      info: {
        email: user.email,
        nickname: user.username
      }
    }
  end
  
  def perform_login(user = nil)
    user ||= User.first
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get auth_callback_path(:github)
    return user
  end
end
