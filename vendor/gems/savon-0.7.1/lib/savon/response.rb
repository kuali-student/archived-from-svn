module Savon

  # == Savon::Response
  #
  # Represents the HTTP and SOAP response.
  class Response

    # The global setting of whether to raise errors.
    @@raise_errors = true

    # Sets the global setting of whether to raise errors.
    def self.raise_errors=(raise_errors)
      @@raise_errors = raise_errors
    end

    # Returns the global setting of whether to raise errors.
    def self.raise_errors?
      @@raise_errors
    end

    # Expects a Net::HTTPResponse and handles errors.
    def initialize(response)
      @response = response

      handle_soap_fault
      handle_http_error
    end

    # Returns whether there was a SOAP fault.
    def soap_fault?
      @soap_fault ? true : false
    end

    # Returns the SOAP fault message.
    attr_reader :soap_fault

    # Returns whether there was an HTTP error.
    def http_error?
      @http_error ? true : false
    end

    # Returns the HTTP error message.
    attr_reader :http_error

    # Returns the SOAP response body as a Hash.
    def to_hash
      @body ||= Crack::XML.parse(@response.body).find_soap_body
    end

    # Returns the SOAP response XML.
    def to_xml
      @response.body
    end

    alias :to_s :to_xml

  private

    # Handles SOAP faults. Raises a Savon::SOAPFault unless the default
    # behavior of raising errors was turned off.
    def handle_soap_fault
      if soap_fault_message
        @soap_fault = soap_fault_message
        raise Savon::SOAPFault, @soap_fault if self.class.raise_errors?
      end
    end

    # Returns a SOAP fault message in case a SOAP fault was found.
    def soap_fault_message
      @soap_fault_message ||= soap_fault_message_by_version to_hash[:fault]
    end

    # Expects a Hash that might contain information about a SOAP fault.
    # Returns the SOAP fault message in case one was found.
    def soap_fault_message_by_version(soap_fault)
      return unless soap_fault

      if soap_fault.keys.include? :faultcode
        "(#{soap_fault[:faultcode]}) #{soap_fault[:faultstring]}"
      elsif soap_fault.keys.include? :code
        "(#{soap_fault[:code][:value]}) #{soap_fault[:reason][:text]}"
      end
    end

    # Handles HTTP errors. Raises a Savon::HTTPError unless the default
    # behavior of raising errors was turned off.
    def handle_http_error
      if @response.code.to_i >= 300
        @http_error = "#{@response.message} (#{@response.code})"
        @http_error << ": #{@response.body}" unless @response.body.empty?
        raise Savon::HTTPError, http_error if self.class.raise_errors?
      end
    end

  end
end
