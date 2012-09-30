require 'spec_helper'

describe "#GetEncodingTypeCodes", ssws: true, component: true do
  let(:credentials) { load_credentials(@endpoint) }
  let(:ssws_client) { Ssws::MtmlLink.new(credentials[:default_ssmtml_endpoint]) }

  context 'when valid' do
    let(:response) { ssws_client.get_encoding_type_codes() }

    specify 'should set the correct content type' do
      response.http.headers["content-type"].should =~ /(text|application)\/xml; charset=utf-8/
    end

    specify 'should return well-formed XML' do
      Nokogiri::XML.parse(response.to_xml) { |config| config.strict }
    end

    describe 'with well-formed XML' do
      let(:response_info) { response.body }
    
      specify 'has get_encoding_type_codes_response as a root element' do
        response_info.keys.first == 'get_encoding_type_codes_response'
      end
    
      specify 'has a get_encoding_type_codes_result element' do
        response_info[:get_encoding_type_codes_response].has_key?(:get_encoding_type_codes_result).should == true
      end
    
      specify 'has string/s element in get_encoding_type_codes_result element' do
        response_info[:get_encoding_type_codes_response][:get_encoding_type_codes_result].has_key?(:string).should == true
      end
    
      context 'should return all get encoding type codes' do
        let(:encoding_types) { response_info[:get_encoding_type_codes_response][:get_encoding_type_codes_result][:string] }
    
        %w{UNICODE UNICODEFFFE ISO-8859-1 ISO-8859-2 UTF-7 UTF-8 ASCII UTF-32 UTF-16 UTF-16LE}.each_with_index do |encoding_type, index|
          specify "#{encoding_type}" do
            encoding_types[index].should == encoding_type
          end
        end
      end
    end
  end
end