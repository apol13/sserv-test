require 'tradenet_spec_helper'

describe "#Ping", ssws: true, component: true do
  let(:credentials) { load_credentials(@endpoint) }
  let(:ssws_client) { Ssws::MtmlLink.new(credentials[:default_ssmtml_endpoint]) }

  describe 'connection' do
    let(:response) { ssws_client.ping() }
    
    specify 'sets the correct content type' do
      response.http.headers["content-type"].should =~ /(text|application)\/xml; charset=utf-8/
    end

    specify 'returns well-formed XML' do
      Nokogiri::XML.parse(response.to_xml) { |config| config.strict }
    end

    describe 'with well-formed XML' do
      let(:response_info) { response.body }

      specify 'has ping_response as a root element' do
        response_info.keys.first == 'ping_response'
      end

      specify 'has a ping_result element' do
        response_info[:ping_response].has_key?(:ping_result).should == true
      end

      specify 'contains true in the ping_result element' do
        response_info[:ping_response][:ping_result].should == true
      end
    end
  end
end