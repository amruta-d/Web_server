module WebServer
  module Response
    # Class to handle 500 errors
    class ServerError < Base
      attr_accessor :headers, :body_length, :response, :error_object
      attr_reader :resource, :version, :code, :reason_phrase, :body
      def initialize(resource=nil, error_object)
      	@resource = resource
      	@error_object = error_object

      	set_response_body

      	content_length
      end

      def set_status_line(version, status_codes)
      	
        @version = version
      	@code = 500.to_s
      	@reason_phrase = status_codes[500]

      end

      def set_headers (default_headers)
      	
      	@headers = Hash.new
      	@headers['Date'] = default_headers['Date']
      	@headers['Server'] = default_headers ['Server']
      	@headers['Content-Length'] = @body_length
      	@headers['Content-Type'] = 'text/html'

      end

      def set_response_body
      	@body = "<!DOCTYPE html><html><head><title>Server Error</title></head>
                 <body><h1>500</h1><br><h3>#{@error_object[:exception]}</h3>
                 Sorry!The server encountered an internal error and was unable to complete your request
                 Please try again later.</body><html>"

      end

      def content_length
      	
      	@body_length = @body.length

      end

      def create_response
      	@response = "#{@version} #{@code} #{@reason_phrase}\n"
      	@headers.each {|header_type,header_value| @response += "#{header_type}: #{header_value}\r\n"}
      	@response += "\r\n"
      	@response += @body

      	@response

      end
    end
  end
end
