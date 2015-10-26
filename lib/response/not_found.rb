module WebServer
  module Response
    # Class to handle 404 errors
    class NotFound < Base
    	attr_accessor :headers, :body_length, :response
      attr_reader :resource, :version, :code, :reason_phrase, :body
      def initialize(resource, options={})
      	@resource = resource

      	set_response_body
      	content_length
      end

      def set_status_line(version, status_codes)
      	@version = version
      	@code = 404.to_s
      	@reason_phrase = status_codes[404]
      end

      def set_headers (default_headers)
      	@headers = Hash.new
      	@headers['Date'] = default_headers['Date']
      	@headers['Server'] = default_headers ['Server']
      	@headers['Content-Length'] = @body_length
      	@headers['Content-Type'] = 'text/html'
      end

      def set_response_body

      	@body = "<!DOCTYPE html><html><head><title>Not Found</title></head>
                 <body><h1> 404</h1>Sorry, the file you requested was not found.</body><html>"

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
