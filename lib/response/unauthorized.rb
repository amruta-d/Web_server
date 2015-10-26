module WebServer
  module Response
      # Class to handle 401 responses
    class Unauthorized < Base
      attr_accessor :headers, :body_length, :response, :body
      attr_reader :resource, :version, :code, :reason_phrase 
      def initialize(resource, options={})
        @resource = resource

        set_response_body
        content_length
      end


      def set_status_line(version, status_codes)
        @version = version
        @code = 401.to_s
        @reason_phrase = status_codes[401]
      end

      def set_headers (default_headers, auth)
        @headers = Hash.new
        @headers['Date'] = default_headers['Date']
        @headers['Server'] = default_headers ['Server']
        @headers["WWW-Authenticate"] = 'Basic realm="' + auth.htaccess_file.auth_name + '"'
        @headers['Content-Length'] = @body_length
        @headers['Content-Type'] = 'text/html'
        
      end

      def set_response_body

        @body = "<!DOCTYPE html><html><head><title>Unauthorized</title></head><body>
                  <h1>401</h1>Sorry,you are not authorised</body><html>"

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
