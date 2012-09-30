require 'rubygems'
require 'savon'
require 'base64'
require 'nokogiri'

module Ssws
  class MtmlLink
    attr_reader :endpoint

    def initialize(endpoint)
      @@client = Savon::Client.new do
        wsdl.endpoint = "#{endpoint}/MTMLLink.asmx"
        wsdl.namespace = "urn:shipserv.mtml"
      end
    end

    def acknowledge_document(params={})
      @@client.request(:AcknowledgeDocument, soap_action: 'urn:shipserv.mtml/AcknowledgeDocument') do
        soap.input = ["AcknowledgeDocument", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations],
            strDocType: params[:doctype],
            strAckID: params[:ackid].to_s
        }
      end
    end

    def check_encoding_type(encoding_type_code)
      begin
        @@client.request(:CheckEncodingType, soap_action: 'urn:shipserv.mtml/CheckEncodingType') do
          soap.input = ["CheckEncodingType", {xmlns: "urn:shipserv.mtml"}]
          soap.body = {
              'EncodingTypeCode' => encoding_type_code
          }
        end
      rescue Savon::Error => error
        raise error.to_s
      end
    end

    def get_count_remaining(params={})
      @@client.request(:GetCountRemaining, 'urn:shipserv.mtml/GetCountRemaining') do
        soap.input = ["GetCountRemaining", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations]
        }
      end
    end

    def get_document_types
      @@client.request(:GetDocumentTypes, soap_action: 'urn:shipserv.mtml/GetDocumentTypes')
    end

    def get_encoding_type_codes
      @@client.request(:GetEncodingTypeCodes, soap_action: 'urn:shipserv.mtml/GetEncodingTypeCodes')
    end

    def get_exchange_rates(datetime)
      @@client.request(:GetExchangeRates, soap_action: 'urn:shipserv.mtml/GetExchangeRates') do
        soap.input = ["GetExchangeRates", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            dUpdatedOnOrAfter: datetime
        }
      end
    end

    def get_integration_codes
      @@client.request(:GetIntegrationCodes, soap_action: 'urn:shipserv.mtml/GetIntegrationCodes')
    end

    def get_integration_settings(integration)
      @@client.request(:GetIntegrationSettings, soap_action: 'urn:shipserv.mtml/GetIntegrationSettings') do
        soap.input = ["GetIntegrationSettings", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strIntegration: integration
        }
      end
    end

    def ping
      @@client.request(:ping, soap_action: 'urn:shipserv.mtml/Ping')
    end

    def search_suppliers_by_name(name, callers_tnid)
      @@client.request(:SearchSuppliersByName, soap_action: 'urn:shipserv.mtml/SearchSuppliersByName') do
        soap.input = ["SearchSuppliersByName", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            sName: name,
            sCallersTNID: callers_tnid
        }
      end
    end

    def get_customer_doc(params={})
      @@client.request(:GetCustomerDoc, soap_action: 'urn:shipserv.mtml/GetCustomerDoc') do
        soap.input = ["GetCustomerDoc", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations]
        }
      end
    end

    def get_customer_doc_bytes(params={})
      @@client.request(:GetCustomerDocBytes, soap_action: 'urn:shipserv.mtml/GetCustomerDocBytes') do
        soap.input = ["GetCustomerDocBytes", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations]
        }
      end
    end

    def send_customer_document(params={})
      @@client.request(:SendCustomerDoc, soap_action: 'urn:shipserv.mtml/SendCustomerDoc') do
        soap.input = ["SendCustomerDoc", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations],
            strFileContents: params[:file_contents],
            byteFileContents: Base64.encode64(params[:file_contents])
        }
      end
    end

    def get_document(params={})
      @@client.request(:GetDocument, soap_action: 'urn:shipserv.mtml/GetDocument') do
        soap.input = ["GetDocument", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations]
        }
      end
    end

    def send_document(params={})
      @@client.request(:SendDocument, soap_action: 'urn:shipserv.mtml/SendDocument') do
        soap.input = ["SendDocument", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations],
            #strFileContents: params[:file_contents],
            byteFileContentsAsBytes: Base64.encode64(params[:file_contents]),
            strClientFileName: params[:clientfname],
            strDocumentType: params[:doctype]
        }
      end
    end

    def get_encoded_document(params={})
      @@client.request(:GetEncodedDocument, soap_action: 'urn:shipserv.mtml/GetEncodedDocument') do
        soap.input = ["GetEncodedDocument", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            "UserIntegrationDoc" => {
                "AppDetails" => {
                    "Name" => params[:name] || "Fitnesse",
                    "Version" => params[:version] || "1.0.0"
                },
                "IntegrationDetails" => {
                    "TradeNetID" => params[:tnid],
                    "UserID" => params[:username],
                    "UserPassword" => params[:password],
                    "IntegrationCode" => params[:integrations],
                    "InvoiceIntegrationCode" => (params[:inv_integrations] if !params[:inv_integrations].nil?)
                },
                "DocumentDetails" => {
                    "EncodingTypeCode" => params[:encoding_type_code] || "UTF-8"
                }
            }
        }
      end
    end

    def send_encoded_document(params={})
      @@client.request(:SendEncodedDocument, soap_action: 'urn:shipserv.mtml/SendEncodedDocument') do
        soap.input = ["SendEncodedDocument", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            "UserIntegrationDoc" => {
                "AppDetails" => {
                    "Name" => params[:name] || "Fitnesse",
                    "Version" => params[:version] || "1.0.0"
                },
                "IntegrationDetails" => {
                    "TradeNetID" => params[:tnid],
                    "UserID" => params[:username],
                    "UserPassword" => params[:password],
                    "IntegrationCode" => params[:integrations]
                    #"InvoiceIntegrationCode" => (params[:inv_integrations] if !params[:inv_integrations].nil?)
                },
                "DocumentDetails" => {
                    "DocumentType" => params[:doctype],
                    "ClientFileName" => params[:clientfname] || "Shipserv Auto",
                    "FileContentsAsBytes" => Base64.encode64(params[:file_contents]).gsub("\n", ''),
                    "EncodingTypeCode" => params[:encoding_type_code] || "UTF-8"
                }
            }
        }
      end
    end

    def send_encoded_doc_w_attachment(params={})
      @@client.request(:SendEncodedDocument, soap_action: 'urn:shipserv.mtml/SendEncodedDocument') do
        soap.input = ["SendEncodedDocument", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            "UserIntegrationDoc" => {
                "AppDetails" => {
                    "Name" => params[:name] || "Fitnesse",
                    "Version" => params[:version] || "1.0.0"
                },
                "IntegrationDetails" => {
                    "TradeNetID" => params[:tnid],
                    "UserID" => params[:username],
                    "UserPassword" => params[:password],
                    "IntegrationCode" => params[:integrations]
                },
                "DocumentDetails" => {
                    "DocumentType" => params[:doctype],
                    "ClientFileName" => params[:clientfname] || "Shipserv Auto",
                    "FileContentsAsBytes" => Base64.encode64(params[:file_contents]).gsub("\n", ''),
                    "EncodingTypeCode" => params[:encoding_type_code] || "UTF-8"
                },
                "DocumentAttachments" => {
                    "DocumentAttachment" => {
                        "FileName" => params[:att_filename],
                        "FileContentsAsBytes" => file_content_as_bytes(att_filename: params[:att_filename])
                    }

                }
            }
        }
      end
    end

    def forward_document(params={})
      @@client.request(:ForwardDocument, soap_action: 'urn:shipserv.mtml/ForwardDocument') do
        soap.input = ["ForwardDocument", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            "UserIntegrationDoc" => {
                "AppDetails" => {
                    "Name" => params[:name] || "Fitnesse",
                    "Version" => params[:version] || "1.0.0"
                },
                "IntegrationDetails" => {
                    "TradeNetID" => params[:tnid],
                    "UserID" => params[:username],
                    "UserPassword" => params[:password],
                    "IntegrationCode" => params[:integrations],
                    "InvoiceIntegrationCode" => params[:inv_integration_code]
                },
                "DocumentDetails" => {
                    "DocumentType" => params[:doctype],
                    "DocumentID" => params[:document_id],
                    "DocumentSubject" => params[:document_subject],
                    "ForwardToTradeNetID" => params[:fwd_to_tradenet_id],
                    "EncodingTypeCode" => params[:encoding_type_code] || "UTF-8"
                }
            }
        }
      end
    end

    def get_mtml_doc(params={})
      @@client.request(:GetMTMLDoc, soap_action: 'urn:shipserv.mtml/GetMTMLDoc') do
        soap.input = ["GetMTMLDoc", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strIntegration: params[:integrations]
        }
      end
    end

    def send_mtml_doc(params={})
      @@client.request(:SendMTMLDoc, soap_action: 'urn:shipserv.mtml/SendMTMLDoc') do
        soap.input = ["SendMTMLDoc", {xmlns: "urn:shipserv.mtml"}]
        soap.body = {
            strTradeNetID: params[:tnid],
            strUserID: params[:username],
            strPassword: params[:password],
            strMTML: params[:mtml_server],
            strIntegration: params[:integrations]
        }
      end
    end

    def file_content_as_bytes(params={})
      path = File.join(File.dirname(__FILE__), "../integrations/data/attachment", params[:path], params[:att_filename])
      puts "File to open :: #{path}"
      File.open(path, 'r') do |image_file|
        Base64.encode64(image_file.read)
      end
    end
  end
end