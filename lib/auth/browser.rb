require 'base64'

module WebServer
  module Auth
    class Browser
      attr_reader :htaccess_file
      def initialize(path, access_file_name, doc_root)
        @path = path
        @access_file_name = access_file_name
        @doc_root = doc_root

        if access_file_name != nil
          @access_file = find_access_files
        end

        if protected?
          @htaccess_file = WebServer::Htaccess.new(File.open(@access_file, "rb").read)
        end
      end

      def protected?
        if @access_file != nil && File.exist?(@access_file)
          return true
        end
        false
      end

      def authorized?(access_string)
        encrypted_str = access_string.gsub(/\s+/m, ' ').strip.split(" ", 2)[1]
        @htaccess_file.authorized?(encrypted_str)
      end

      def find_access_files
        current_dir = File.dirname(@path) + "/"
        while current_dir != @doc_root
          if File.exist?(current_dir + @access_file_name)          
            return current_dir + @access_file_name
          end
          current_dir = File.expand_path("..", current_dir) + "/"
        end

        if File.exist?(@doc_root + @access_file_name)
          return @doc_root + @access_file_name
        end
      end

      private :find_access_files
    end
  end
end
