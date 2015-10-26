require 'base64'

module WebServer
  class Htaccess

    def initialize(access_file)
      @access_file = access_file
      load_access_file
    end

    def auth_user_file
      @access['AuthUserFile']
    end

    def auth_type
      @access['AuthType']
    end

    def auth_name
      @access['AuthName']
    end

    def require_user
      @access['Require']
    end

    def authorized?(encrypted_string)
      user_file = WebServer::UserFile.new(auth_user_file)
      parts = Base64.decode64(encrypted_string).split(':')
      user_file.valid?(parts[0], parts[1])
    end

    def users
      user_file = WebServer::UserFile.new(auth_user_file)
      user_file.users
    end

    def load_access_file
      @access = Hash.new
      for access_line in @access_file.split(/(\n)/) # split by newline
        if access_line != nil && access_line.strip.length > 0
          parts = access_line.gsub(/\s+/m, ' ').strip.split(" ", 2) # split by whitespace including both tab & spaces
          key = parts[0]
          value = parts[1].gsub(/\"/m, '')
          @access[key] = value
        end
      end
    end

    private :load_access_file

  end
end
