require 'stringio'

# The Request class encapsulates the parsing of an HTTP Request
module WebServer
  class Request
    attr_accessor :http_method, :uri, :version, :headers, :body, :params, :full_header, :full_request
    

    # Request creation receives a reference to the socket over which
    # the client has connected
    def initialize(socket)
      # Perform any setup, then parse the request

      @full_request = socket.string
      if @full_request.length == 0
        return nil
      end
      parse
      if @headers.has_key?('CONTENT_LENGTH') && @headers['CONTENT_LENGTH'] != '0'
        parse_body 
      end

    end

    # I've added this as a convenience method, see TODO (This is called from the logger
    # to obtain information during server logging)
    def user_id
      # TODO: This is the userid of the person requesting the document as determined by 
      # HTTP authentication. The same value is typically provided to CGI scripts in the 
      # REMOTE_USER environment variable. If the status code for the request (see below) 
      # is 401, then this value should not be trusted because the user is not yet authenticated.
      '-'
    end

    # Parse the request from the socket - Note that this method takes no
    # parameters
    def parse

      #split the head and body of the request
      @full_header, @body = if @full_request.include?("\r\n\r\n")
                             @full_request.split("\r\n\r\n",2)
                           else
                             @full_request.split("\n\n",2)
                           end

      #split the request line and header string which contains the list of headers
      request_line, header_string = if @full_header.include?("\r\n")
                                    @full_header.split("\r\n", 2)
                                  else
                                    @full_header.split("\n", 2)
                                  end

      @params = Hash.new 
      parse_request_line(request_line)

      headers_array = header_string.split("\n")
      @headers = Hash.new      

      headers_array.each { |header_line| 
        parse_header(header_line)
      }

    end

    # The following lines provide a suggestion for implementation - feel free
    # to erase and create your own...
    def next_line(string_block)
    end

    def parse_request_line(request_line)
      request_line_split_array = request_line.split(" ")
      @http_method = request_line_split_array[0]
      if(request_line_split_array[1].include?("?"))
        @uri, params_string = request_line_split_array[1].split("?", 2)
        parse_params(params_string)
      else
        @uri = request_line_split_array[1]
      end  
      
      @version = request_line_split_array[2]
    end

    def parse_header(header_line)
       header_arr = header_line.split(":")
       header_arr[1] = header_arr[1..-1].join (":")
       @headers[header_arr[0].strip.upcase.gsub('-','_')] = header_arr[1].strip
       ENV[header_arr[0].strip.upcase.gsub('-','_')] = header_arr[1].strip
    end

    def parse_body
      if @http_method == "POST"
        parse_params(@body.chomp)
      end
      return @body.chomp!

    end

    def parse_params(params_string)
      if(params_string.include?("&"))
        params_arr = params_string.split("&")
        #save each param in the params hash
        params_arr.each { |param| 
          param_key, param_value = param.split("=", 2)
          @params[param_key.gsub('+','_')] = param_value.gsub('+',' ')
        }

      else
        param_key, param_value = params_string.split("=", 2)
        @params[param_key.gsub('+','_')] = param_value.gsub('+',' ')

       end 
    end
  end
end
