require 'spec_helper'

describe "#GetCountRemaining", ssws: true, component: true do
  let(:credentials) { load_credentials(@endpoint) }
  let(:ssws_client) { Ssws::MtmlLink.new(credentials[:default_ssmtml_endpoint]) }
  let(:buyer) { credentials[:default_buyer] }
  let(:inactive_buyer) { credentials[:inactive_buyer] }

  describe 'valid tradenet account' do
    let(:response) { ssws_client.get_count_remaining(tnid: buyer[:tnid], username: buyer[:username], password: buyer[:password], integration: 'STD') }

    specify 'sets the correct content type' do
      response.http.headers["content-type"].should =~ /(text|application)\/xml; charset=utf-8/
    end

    specify 'returns well-formed XML' do
      Nokogiri::XML.parse(response.to_xml) { |config| config.strict }
    end

    describe 'with well-formed XML' do
      let(:response_info) { response.body }

      specify 'has get_count_remaining_response as a root element' do
        response_info.keys.first == 'get_count_remaining_response'
      end

      specify 'has a get_count_remaining_result element' do
        response_info[:get_count_remaining_response].has_key?(:get_count_remaining_result).should == true
      end

      specify 'contains valid number in the get_count_remaining_result element' do
        response_info[:get_count_remaining_response][:get_count_remaining_result].should =~ /\d+/
      end
    end
  end

  describe 'invalid credentials:' do
    specify 'incorrect tnid should return error code -21' do
      response = ssws_client.get_count_remaining(tnid: 'INCORRECT', username: buyer[:username], password: buyer[:password], integration: 'STD')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should == "-21"
    end

    specify 'inactive user should return error code -30' do
      response = ssws_client.get_count_remaining(tnid: inactive_buyer[:tnid], username: inactive_buyer[:username], password: inactive_buyer[:password], integration: 'STD')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should == "-30"
    end

    specify 'incorrect username should return error code -23' do
      response = ssws_client.get_count_remaining(tnid: buyer[:tnid], username: 'INCORRECT', password: buyer[:password], integration: 'STD')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should == "-23"
    end

    specify 'incorrect password should return error code -22' do
      response = ssws_client.get_count_remaining(tnid: buyer[:tnid], username: buyer[:username], password: 'INCORRECT', integration: 'STD')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should == "-22"
    end

    specify 'incorrect integration type should still return CORRECT COUNT' do
      response = ssws_client.get_count_remaining(tnid: buyer[:tnid], username: buyer[:username], password: buyer[:password], integration: 'INCORRECT')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should =~ /\d+/
    end

    specify 'empty tnid should return error code -44' do
      response = ssws_client.get_count_remaining(tnid: "", username: buyer[:username], password: buyer[:password], integration: 'STD')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should == "-44"
    end

    specify 'empty username should return error code -44' do
      response = ssws_client.get_count_remaining(tnid: buyer[:tnid], username: "", password: buyer[:password], integration: 'STD')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should == "-44"
    end

    specify 'empty password should return error code -44' do
      response = ssws_client.get_count_remaining(tnid: buyer[:tnid], username: buyer[:username], password: "", integration: 'STD')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should == "-44"
    end

    specify 'empty integration type should still return CORRECT COUNT' do
      response = ssws_client.get_count_remaining(tnid: buyer[:tnid], username: buyer[:username], password: buyer[:password], integration: 'INCORRECT')
      response.body[:get_count_remaining_response][:get_count_remaining_result].should =~ /\d+/
    end
  end
end

#Code|Explanation
#-97 |General error
#-96 |MTML, File System, DXP  Count Remaining Error
#-44 |Incomplete Account Information
#-42 |MTML Link Error
#-21 |Check Credentials, Invalid TNID
#-22 |Check Credentials, Invalid Password
#-23 |Check Credentials, Error on UserName
#-15 |Invalid Document
#-11 |Document Conversion Error
#-28 |Check Credentials function of SSXLatClient (unable to open oracle connection)
