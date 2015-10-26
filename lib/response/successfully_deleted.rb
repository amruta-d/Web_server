module WebServer
  module Response
    # Class to handle 204 responses
    class SuccessfullyDeleted < Base
      attr_accessor :headers, :response, :document_path
      attr_reader :resource, :version, :code, :reason_phrase
      def initialize(resource, options={})

        @resource = resource
        content_length
        
      end

      def set_status_line(version, status_codes)

      	@version = version
      	@code = 204.to_s
      	@reason_phrase = status_codes[204]

      end

      def set_headers (default_headers)

      	@headers = Hash.new
      	@headers['Date'] = default_headers['Date']
      	@headers['Server'] = default_headers ['Server']
        @headers['Content-Length'] = 0

      end

      def content_length

        @body_length = 0

      end

      def create_response

      	@response = "#{@version} #{@code} #{@reason_phrase}\n"
      	@headers.each {|header_type,header_value| @response += "#{header_type}: #{header_value}\r\n"}

      	@response

      end	
    end
  end
end
