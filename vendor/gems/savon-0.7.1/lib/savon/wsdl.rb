module Savon

  # Savon::WSDL
  #
  # Represents the WSDL document.
  class WSDL

    # Initializer, expects a Savon::Request.
    def initialize(request)
      @request = request
    end

    # Sets whether to use the WSDL.
    attr_writer :enabled

    # Returns whether to use the WSDL. Defaults to +true+.
    def enabled?
      @enabled.nil? ? true : @enabled
    end

    # Returns the namespace URI of the WSDL.
    def namespace_uri
      @namespace_uri ||= stream.namespace_uri
    end

    # Returns an Array of available SOAP actions.
    def soap_actions
      @soap_actions ||= stream.operations.keys
    end

    # Returns a Hash of SOAP operations including their corresponding
    # SOAP actions and inputs.
    def operations
      @operations ||= stream.operations
    end

    # Returns the SOAP endpoint.
    def soap_endpoint
      @soap_endpoint ||= stream.soap_endpoint
    end

    # Returns +true+ for available methods and SOAP actions.
    def respond_to?(method)
      return true if soap_actions.include? method
      super
    end

    # Returns the raw WSDL document.
    def to_s
      @document ||= @request.wsdl.body
    end

  private

    # Returns the Savon::WSDLStream.
    def stream
      unless @stream
        @stream = WSDLStream.new
        REXML::Document.parse_stream to_s, @stream
      end
      @stream
    end

  end

  # Savon::WSDLStream
  #
  # Stream listener for parsing the WSDL document.
  class WSDLStream

    # The main sections of a WSDL document.
    Sections = %w(definitions types message portType binding service)

    def initialize
      @depth, @operations = 0, {}
    end

    # Returns the namespace URI.
    attr_reader :namespace_uri

    # Returns the SOAP operations.
    attr_reader :operations

    # Returns the SOAP endpoint.
    attr_reader :soap_endpoint

    # Hook method called when the stream parser encounters a starting tag.
    def tag_start(tag, attrs)
      @depth += 1
      tag = tag.strip_namespace

      @section = tag.to_sym if @depth <= 2 && Sections.include?(tag)
      @namespace_uri ||= attrs["targetNamespace"] if @section == :definitions
      @soap_endpoint ||= URI(attrs["location"]) if @section == :service && tag == "address"

      operation_from tag, attrs if @section == :binding && tag == "operation"
    end

    # Hook method called when the stream parser encounters a closing tag.
    def tag_end(tag)
      @depth -= 1
    end

    # Stores available operations from a given tag +name+ and +attrs+.
    def operation_from(tag, attrs)
      @input = attrs["name"] if attrs["name"]

      if attrs["soapAction"]
        @action = !attrs["soapAction"].blank? ? attrs["soapAction"] : @input
        @input = @action.split("/").last if !@input || @input.empty?

        @operations[@input.snakecase.to_sym] = { :action => @action, :input => @input }
        @input, @action = nil, nil
      end
    end

    # Catches calls to unimplemented hook methods.
    def method_missing(method, *args)
    end

  end
end
