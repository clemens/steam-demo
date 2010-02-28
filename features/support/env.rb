ENV["RAILS_ENV"] ||= "cucumber"

root = File.expand_path('../../..', __FILE__)

require "#{root}/config/environment"
require 'steam'
require 'test/unit'
# require 'rspec'

Steam.config[:html_unit][:java_path] = "#{root}/vendor/htmlunit-2.6"

browser = Steam::Browser.create
World do
  Steam::Session::Rails.new(browser)
end

at_exit { browser.close }

Before do
  ActiveRecord::Base.send(:subclasses).each do |model|
    model.connection.execute("DELETE FROM #{model.table_name}")
  end
end

