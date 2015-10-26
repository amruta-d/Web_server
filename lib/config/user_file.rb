require 'digest'

module WebServer
  class UserFile
    def initialize(file_path)
      @file_path = file_path
      load_user_file
    end

    def valid?(username, password)
      Digest::SHA1.base64digest(password) == @user_pwd[username]
    end

    def users
      @user_pwd.keys
    end

    def load_user_file
      @user_pwd = Hash.new

      if File.exists?(@file_path)
        htpasswd_file = File.open(@file_path, "rb").read
        for htpasswd_line in htpasswd_file.split(/(\n)/) # split by newline
          if htpasswd_line != nil && htpasswd_line.strip.length > 0
            htpasswd_parts = htpasswd_line.split(':')
            user = htpasswd_parts[0]
            pwd = htpasswd_parts[1].gsub(/{SHA}/, '')
            @user_pwd[user] = pwd
          end
        end
      end
    end

    private :load_user_file

  end
end
