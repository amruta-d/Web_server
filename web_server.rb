require 'socket'
require_relative 'lib/response'
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    attr_accessor :httpd_conf, :mimes

    def initialize(options={})
      # Set up WebServer's configuration files and logger here
      # Do any preparation necessary to allow threading multiple requests
      httpd_file = File.open("config/httpd.conf", "rb")
      @httpd_conf = HttpdConf.new(httpd_file.read)

      mime_file = File.open("config/mime.types", "rb")
      @mimes = MimeTypes.new(mime_file.read)
    end

    def start
      server = TCPServer.open('localhost', @httpd_conf.port)
      # Begin your 'infinite' loop, reading from the TCPServer, and
      # processing the requests as connections are made
      puts "started TCP server at port: #{@httpd_conf.port}"
      while true
        

        Thread.start(server.accept) do |socket|
          begin
            response = Worker.new(socket, self)
          
            if response == nil
              next
            end
            full_response = response.process_request
            
            #if error put the 500 error reponse on the socket
          rescue Exception => e
            server_error = Response::Factory.error(e)
            server_error.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
            server_error.set_headers(Response.default_headers)
            socket.puts server_error.create_response

            # if no error puts the response on the socket
          else
            socket.puts full_response
            #always close the socket for each thread
          ensure

            socket.close
          end
        end
      end
    end
  end
end

WebServer::Server.new.start
