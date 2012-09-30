require 'watir-webdriver'
require 'rspec'

require './lib/net_http'
require './lib/pages/login'
require './lib/pages/registration'

Dir["./lib/pages/*.rb"].each {|f| require f}
#Dir["./spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include AccountSpecHelper, :example_group => { :file_path => /spec\/tradenet_core\/component\//}
  #config.include Haml::Helpers, :type => :helper

  config.before(:each, :example_group => { :file_path => /\bspec\/tradenet_core\//}) do
    @endpoint = ENV['endpoint'].present? ? ENV['endpoint'] : 'dev'
    unless %w{dev uat live}.include?(@endpoint)
      raise 'Endpoint must be one of: `dev`, `uat` or `live`'
    end
  end
end

def nonce
  Time.now.to_f.to_s
end
