require "spec_helper"

describe Savon::Request do
  before { @request = Savon::Request.new EndpointHelper.wsdl_endpoint }

  it "contains the ContentType for each supported SOAP version" do
    Savon::SOAPVersions.each do |soap_version|
      Savon::Request::ContentType[soap_version].should be_a(String)
      Savon::Request::ContentType[soap_version].should_not be_empty
    end
  end

  # defaults to log request and response. disabled for spec execution

  it "has both getter and setter for whether to log (global setting)" do
    Savon::Request.log = true
    Savon::Request.log?.should be_true
    Savon::Request.log = false
    Savon::Request.log?.should be_false
  end

  it "defaults to use a Logger instance for logging" do
    Savon::Request.logger.should be_a(Logger)
  end

  it "has both getter and setter for the logger to use (global setting)" do
    Savon::Request.logger = nil
    Savon::Request.logger.should be_nil
    Savon::Request.logger = Logger.new STDOUT
  end

  it "defaults to :debug for logging" do
    Savon::Request.log_level.should == :debug
  end

  it "has both getter and setter for the log level to use (global setting)" do
    Savon::Request.log_level = :info
    Savon::Request.log_level.should == :info
    Savon::Request.log_level = :debug
  end

  it "is initialized with a SOAP endpoint String" do
    Savon::Request.new EndpointHelper.wsdl_endpoint
  end

  it "has a getter for the SOAP endpoint URI" do
    @request.endpoint.should == URI(EndpointHelper.wsdl_endpoint)
  end

  it "should have a getter for the proxy URI" do
    @request.proxy.should == URI("")
  end

  it "should have a getter for the HTTP headers which defaults to an empty Hash" do
    @request.headers.should == {}
  end

  it "should have a setter for the HTTP headers" do
    headers = { "some" => "thing" }

    @request.headers = headers
    @request.headers.should == headers
  end

  it "should return the Net::HTTP object" do
    @request.http.should be_kind_of(Net::HTTP)
  end

  it "should have a method for setting HTTP basic auth credentials" do
    @request.basic_auth "user", "password"
  end

  it "retrieves the WSDL document and returns the Net::HTTP response" do
    wsdl_response = @request.wsdl

    wsdl_response.should be_a(Net::HTTPResponse)
    wsdl_response.body.should == WSDLFixture.authentication
  end

  it "executes a SOAP request and returns the Net::HTTP response" do
    soap = Savon::SOAP.new
    soap.endpoint = URI EndpointHelper.wsdl_endpoint
    soap_response = @request.soap soap

    soap_response.should be_a(Net::HTTPResponse)
    soap_response.body.should == ResponseFixture.authentication
  end

end
