module WebServer
  module Response
    # Class to handle 403 responses
    class Forbidden < Base

      attr_accessor :headers, :body_length, :response
      attr_reader :resource, :version, :code, :reason_phrase, :body
      def initialize(resource, options={})
        @resource = resource

        set_response_body
        content_length
      end

      def set_status_line(version, status_codes)
        @version = version
        @code = 403.to_s
        @reason_phrase = status_codes[403]
      end

      def set_headers (default_headers)
        @headers = Hash.new
        @headers['Date'] = default_headers['Date']
        @headers['Server'] = default_headers ['Server']
        @headers['Content-Length'] = @body_length
        @headers['Content-Type'] = 'text/html'
      end

      def set_response_body

        @body = "<!DOCTYPE html><html><head><title>Forbidden</title></head><body><h1>403</h1><br>
                  Sorry,the credentials entered are not correct. <br/> You cannot access this file</body><html>"

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
