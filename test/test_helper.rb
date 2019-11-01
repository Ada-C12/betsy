require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec
  add_filter '/test/' # for minitest
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/autorun'
require 'minitest/reporters'
require 'pry'


Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(user)
    return {
      provider: user.provider,
      uid: user.uid,
      info: {
        email: user.email,
        nickname: user.name
        # You can add more fields from
        # The omniauth hash here
      }
    }
  end
  
  def perform_login(user = User.first)
    
    OmniAuth.config.mock_auth[:github] = 
    OmniAuth::AuthHash.new(mock_auth_hash(user))
    
    get auth_callback_path(:github)
    
    return user
  end
  
  def create_order(order = Order.first)
    create_session(:order_id)
    session[:order_id] = order.id
    return order
  end
end
