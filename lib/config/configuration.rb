# This class should be used to encapuslate the functionality 
# necessary to open and parse configuration files. See
# HttpdConf and MimeTypes, both derived from this parent class.
module WebServer
  class Configuration
    def initialize(file_content)
      @conf = Hash.new
      for line in file_content.split(/(\n)/) # split by newline
        if (!line.start_with?("#")) # ignore comment line
          parts = line.gsub(/\s+/m, ' ').strip.split(" ") # split by whitespace including both tab & spaces
          key = parts[0]
          if (key != nil)
            if (!@conf.has_key?(key))
              @conf[key] = Array.new
            end
            values = parts[1..-1]
            values.collect! { |element|
              element.gsub(/\"/m, '') # remove quotes
            }
            @conf[key] << values
            
          end
        end
      end
    end
  end
end

