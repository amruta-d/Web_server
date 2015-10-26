require_relative 'request'
require_relative 'response'

# This class will be executed in the context of a thread, and
# should instantiate a Request from the client (socket), perform
# any logging, and issue the Response to the client.
module WebServer
  class Worker
    # Takes a reference to the client socket and the logger object
    attr_accessor :request, :server, :response_string
    def initialize(client_socket, server=nil)

      fullRequest = client_socket.recv(2000)
      fullStringio = StringIO.new(fullRequest)
      @request = Request.new(fullStringio)

      if @request == nil
        return nil
      end

      @server = server

      @logger = WebServer::Logger.new(@server.httpd_conf.log_file)

    end

    # Processes the request
    def process_request
      
      if (@request.uri == "/favicon.ico")
        #do nothing
      else 
        resource = Resource.new(@request, @server.httpd_conf, @server.mimes)
        @response = resource.handle_request
        @logger.log(@request, @response)
        @logger.close
        @response.create_response
      end
            
    
    end
  end
end
