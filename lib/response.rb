require_relative 'response/base'

module WebServer
  module Response
    DEFAULT_HTTP_VERSION = 'HTTP/1.1'

    RESPONSE_CODES = {
      200 => 'OK',
      201 => 'Successfully Created',
      204 => 'Successfully Deleted',
      304 => 'Not Modified',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not Found',
      500 => 'Internal Server Error'
    }.freeze

    def self.default_headers
      {
        'Date' => Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z'),
        'Server' => 'John Roberts CSC 667'
      }
    end

    module Factory
      def self.create(resource)
        Response::Base.new(resource)
      end

      def self.create_ok(resource)
        Response::Ok.new(resource)
      end
      def self.create_successfully_created(resource)
        Response::SuccessfullyCreated.new(resource)

      end

      def self.create_successfully_deleted(resource)
        Response::SuccessfullyDeleted.new(resource)

      end
      
      def self.bad_request(resource)
        Response::BadRequest.new(resource)
      end

      def self.not_found (resource)
        Response::NotFound.new(resource)
      end

      def self.create_unauthorized(resource)
        Response::Unauthorized.new(resource)
      end

      def self.create_forbidden(resource)
        Response::Forbidden.new(resource)
      end

      def self.error(resource=nil, error_object)
        Response::ServerError.new(exception: error_object)
      end
    end
  end
end
