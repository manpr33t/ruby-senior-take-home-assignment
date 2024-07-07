require 'rack/test'
require 'rspec'
require 'sinatra'
require 'json'
require 'webmock/rspec'

ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.expand_path '../../server.rb', __FILE__

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    def app
      RESTServer
    end
  end
end
