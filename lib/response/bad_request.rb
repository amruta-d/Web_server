module WebServer
  module Response
    # Class to handle 400 responses
    class BadRequest < Base
      attr_accessor :headers, :body_length, :response
      attr_reader :resource, :version, :code, :reason_phrase, :body
      def initialize(resource, options={})
      	@resource = resource

        set_response_body
        content_length
      end

      #set the status line for the response
      def set_status_line(version, status_codes)
      	@version = version
      	@code = 400.to_s
      	@reason_phrase = status_codes[400]
      end

      #set the response headers
      def set_headers (default_headers)
      	@headers = Hash.new
      	@headers['Date'] = default_headers['Date']
      	@headers['Server'] = default_headers ['Server']
      	@headers['Content-Length'] = @body_length
      	@headers['Content-Type'] = 'text/html'
      end

      #set the body of the response
      def set_response_body

      	@body = "<!DOCTYPE html><html><head><title>Bad Request</title></head>
                 <body><h1>400</h1><br> Sorry, your browser sent a request the server could not understand</body>
                 <html>"

      end

      #calculate the length of the body content
      def content_length
      	
      	@body_length = @body.length

      end

      #create the entire response string
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
