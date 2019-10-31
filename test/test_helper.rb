require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/db/'
  add_filter '/test/' # for minitest
  
  # stuff we don't need to test
  add_filter '/app/channels'
  add_filter '/app/jobs'
  add_filter '/app/mailers'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(wizard)
    return {
      provider: wizard.provider,
      uid: wizard.uid,
      info: {
        email: wizard.email,
        nickname: wizard.username
      }
    }
  end

  def perform_login(wizard = nil)
    wizard ||= Wizard.first

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(wizard))
    get auth_callback_path(:github)

    return wizard
  end
end
