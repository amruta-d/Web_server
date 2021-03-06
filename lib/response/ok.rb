#require Response

module WebServer
  module Response
    # Class to handle 200 responses
    class Ok < Base
      attr_accessor :headers, :body_length, :mime_type, :response
      attr_reader :resource, :version, :code, :reason_phrase, :body
      def initialize(resource, options={})
        @resource = resource
        @body = @resource.response_body

        content_length
        content_type
      
      end

      def set_status_line(version, status_codes)
      	@version = version
      	@code = 200.to_s
      	@reason_phrase = status_codes[200]
      end

      def set_headers (default_headers)
      	@headers = Hash.new
      	@headers['Date'] = default_headers['Date']
      	@headers['Server'] = default_headers ['Server']
        @headers['Content-Type'] = @mime_type
      	@headers['Content-Length'] = @body_length
      end

      def content_length
      	@body_length = @body.length

      end

      def content_type
      	if @resource.resolve.include? "/cgi-bin/"
          file_extension = "html"
        else
          uri_arr = @resource.resolve.split(".")
          file_extension = uri_arr[-1]
          
        end
        @mime_type = @resource.mimes.for_extension(file_extension)  

      end

      def create_response
        if @resource.resolve.include? "/cgi-bin/" 
          @response = "#{@version} #{@code} #{@reason_phrase}\n"
          @response += @body
        else
          @response = "#{@version} #{@code} #{@reason_phrase}\n"
          @headers.each {|header_type,header_value| @response += "#{header_type}: #{header_value}\r\n"}
      	  if @resource.request.http_method == "GET" || "POST"
            @response += "\r\n"
      	    @response += @body
          end
        end
        #puts @response

      	@response

      end	

    end
  end
end
