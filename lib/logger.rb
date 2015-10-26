require 'fileutils'

module WebServer
  class Logger

    # Takes the absolute path to the log file, and any options
    # you may want to specify.  I include the option :echo to 
    # allow me to decide if I want my server to print out log
    # messages as they get generated
    def initialize(log_file_path, options={})
      @log_file_path = log_file_path
      dirname = File.dirname(log_file_path)

      if !File.exists?(dirname)
        FileUtils.mkdir_p dirname
      end

      @file = File.new(log_file_path, 'a')
    end

    # Log a message using the information from Request and 
    # Response objects
    def log(request, response)
      
      @file.puts "#{Time.now} #{request.http_method} #{request.uri} #{request.version} #{response.code} #{response.headers['Content-Length']}"

    end

    # Allow the consumer of this class to flush and close the 
    # log file
    def close
      @file.close
    end
  end
end
