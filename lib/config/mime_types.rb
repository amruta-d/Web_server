require_relative 'configuration'

# Parses, stores and exposes the values from the mime.types file
module WebServer
  class MimeTypes < Configuration
    DEFAULT_MIME_TYPE = 'text/plain'

    def initialize(mime_file_content)
    	super(mime_file_content)
        @inverted_conf = Hash.new
        @conf.each do |key, value|
            value.each do |element|
                element.each do |inner|
                    @inverted_conf[inner] = key
                end
            end
        end
    end
    
    # Returns the mime type for the specified extension
    def for_extension(extension)
    	mime_type = @inverted_conf[extension]
        if (mime_type == nil)
            mime_type = DEFAULT_MIME_TYPE
        end
        mime_type
    end
  end
end
