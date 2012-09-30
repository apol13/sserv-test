ENV["ENV"] = 'test'

require 'rspec'
require './lib/tradenet/mtml_link'

Dir["./spec/spec_helpers/*.rb"].each { |f| require f }
Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include AccountSpecHelper, :example_group => {:file_path => /spec\/tradenet_core\/component\//}
  #config.include Haml::Helpers, :type => :helper

  config.before(:each, :example_group => {:file_path => /\bspec\/tradenet_core\//}) do
    #TODO : Fix ENV variable
    @endpoint = ENV['ENV'].nil? ? ENV['ENV'] : 'dev'
    unless %w{dev uat live}.include?(@endpoint)
      raise 'Endpoint must be one of: `dev`, `uat` or `live`'
    end
  end
end
