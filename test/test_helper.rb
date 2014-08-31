
require 'simplecov'
require 'codeclimate-test-reporter'
if ENV['GUARD_NOTIFY'] == nil
  if ENV['CODECLIMATE'] != nil
    ENV['CODECLIMATE_REPO_TOKEN'] = Rails.application.secrets.codeclimate_repo_token
    SimpleCov.start 'rails' do
      formatter SimpleCov::Formatter::MultiFormatter[
        SimpleCov::Formatter::HTMLFormatter,
        CodeClimate::TestReporter::Formatter
      ]
    end
  else
    SimpleCov.start 'rails'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'pry-rescue/minitest' unless ENV['GUARD_NOTIFY']
require 'minitest/rails/capybara'
require 'shoulda/matchers'

DatabaseCleaner.strategy = :truncation

Faker::Config.locale = 'en-US'

module MiniTest
  # clean database around tests
  class Spec
    include FactoryGirl::Syntax::Methods

    before :each do
      DatabaseCleaner.start
    end

    after :each do
      DatabaseCleaner.clean
    end
  end
end

module ActionController
  # add factory girl short syntax
  class TestCase
    include FactoryGirl::Syntax::Methods
    include Sorcery::TestHelpers::Rails::Controller

    before :each do
      DatabaseCleaner.start
    end

    after :each do
      DatabaseCleaner.clean
    end
  end
end
