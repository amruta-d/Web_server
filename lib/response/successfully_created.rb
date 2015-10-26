module WebServer
  module Response
    # Class to handle 201 responses
    class SuccessfullyCreated < Base
attr_accessor :headers, :mime_type, :response, :document_path
      attr_reader :resource, :version, :code, :reason_phrase
      def initialize(resource, options={})
        @resource = resource
        content_type
        content_length
      end

      def set_status_line(version, status_codes)
      	@version = version
      	@code = 201.to_s
      	@reason_phrase = status_codes[201]
      end

      def set_headers (default_headers)
      	@headers = Hash.new
      	@headers['Date'] = default_headers['Date']
      	@headers['Server'] = default_headers ['Server']
        @headers['Content-Type'] = @mime_type
        @headers['Content-Length'] = 0
        @headers['Location'] = @document_path
      end

      def content_length
        @body_length = 0
      end

      def content_type

         @document_path = @resource.resolve
         uri_arr = @resource.resolve.split(".")
         file_extension = uri_arr[-1]

        @mime_type = @resource.mimes.for_extension(file_extension)  

      end

      def create_response
      	@response = "#{@version} #{@code} #{@reason_phrase}\n"
      	@headers.each {|header_type,header_value| @response += "#{header_type}: #{header_value}\r\n"}

      	@response

      end	
    end
  end
end
