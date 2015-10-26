require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration
    DEFAULT_DIR_INDEX = 'index.html'
    DEFAULT_ACCESS_FILE = ".htaccess"
    DEFAULT_LOG_FILE = "server.log"
    DEFAULT_PORT = 8080
    def initialize(httpd_file_content)
        super(httpd_file_content)
    end

    # Returns the value of the ServerRoot
    def server_root
        @conf["ServerRoot"][0][0]
    end

    # Returns the value of the DocumentRoot
    def document_root
        @conf["DocumentRoot"][0][0]
    end

    # Returns the directory index file
    def directory_index
        if @conf["DirectoryIndex"] != nil &&
            @conf["DirectoryIndex"][0] != nil &&
            @conf["DirectoryIndex"][0][0] != nil

            return @conf["DirectoryIndex"][0][0]
        end
        DEFAULT_DIR_INDEX
    end

    # Returns the *integer* value of Listen
    def port
        if @conf["Listen"] != nil &&
            @conf["Listen"][0] != nil &&
            @conf["Listen"][0][0] != nil

            return @conf["Listen"][0][0].to_i
        end
        DEFAULT_PORT
    end

    # Returns the value of LogFile
    def log_file
        if @conf["LogFile"] != nil &&
            @conf["LogFile"][0] != nil &&
            @conf["LogFile"][0][0] != nil

            return @conf["LogFile"][0][0]
        end
        File.join(server_root, DEFAULT_LOG_FILE)
    end

    # Returns the name of the AccessFile 
    def access_file_name
        if @conf["AccessFileName"] != nil &&
            @conf["AccessFileName"][0] != nil &&
            @conf["AccessFileName"][0][0] != nil

            return @conf["AccessFileName"][0][0]
        end
        DEFAULT_ACCESS_FILE
    end

    # Returns an array of ScriptAlias directories
    def script_aliases
        all_aliases_and_abs_paths = @conf["ScriptAlias"]
        all_aliases = []
        for alias_and_abs_path in all_aliases_and_abs_paths
            all_aliases << alias_and_abs_path[0]
        end
        all_aliases
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(_alias)
        all_aliases_and_abs_paths = @conf["ScriptAlias"]
        abs_path = nil
        for alias_and_abs_path in all_aliases_and_abs_paths
            if (_alias == alias_and_abs_path[0])
                abs_path = alias_and_abs_path[1]
                break
            end
        end
        abs_path
    end

    # Returns an array of Alias directories
    def aliases
        all_aliases_and_abs_paths = @conf["Alias"]
        all_aliases = []
        for alias_and_abs_path in all_aliases_and_abs_paths
            all_aliases << alias_and_abs_path[0]
        end
        all_aliases
    end

    # Returns the aliased path for a given Alias directory
    def alias_path(_alias)
        all_aliases_and_abs_paths = @conf["Alias"]
        abs_path = nil
        for alias_and_abs_path in all_aliases_and_abs_paths
            if (_alias == alias_and_abs_path[0])
                abs_path = alias_and_abs_path[1]
                break
            end
        end
        abs_path
    end
  end
end
