require 'tradenet_spec_helper'

describe "#Check Encoding Type", ssws: true, component: true do
  let(:credentials) { load_credentials(@endpoint) }
  let(:ssws_client) { Ssws::MtmlLink.new(credentials[:default_ssmtml_endpoint]) }

  describe 'valid encoding type' do
    let(:response) { ssws_client.check_encoding_type('UTF-8') }

    specify 'sets the correct content type' do
      response.http.headers["content-type"].should =~ /(text|application)\/xml; charset=utf-8/
    end

    specify 'returns well-formed XML' do
      Nokogiri::XML.parse(response.to_xml) { |config| config.strict }
    end

    describe 'with well-formed XML' do
      let(:response_info) { response.body }

      specify 'has check_encoding_type_response as a root element' do
        response_info.keys.first == 'check_encoding_type_response'
      end

      specify 'has a check_encoding_type_result element' do
        response_info[:check_encoding_type_response].has_key?(:check_encoding_type_result).should == true
      end

      %w{UNICODE UNICODEFFFE ISO-8859-1 ISO-8859-2 UTF-7 UTF-8 ASCII UTF-32 UTF-16 UTF-16LE}.each do |encoding_type|
        specify "should return true if encoding type is #{encoding_type}" do
          response = ssws_client.check_encoding_type(encoding_type)
          response_info = response.body
          response_info[:check_encoding_type_response][:check_encoding_type_result].should == true
        end
      end
    end
  end
end