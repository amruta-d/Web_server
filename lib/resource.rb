  require_relative 'response'
  require 'fileutils'

  module WebServer
  class Resource
    attr_reader :request, :conf, :mimes,:response_body, :response_string, :document_path

    def initialize(request, httpd_conf, mimes)
      @request = request
      @conf = httpd_conf
      @mimes = mimes
      @this_alias = nil
      @this_script_alias = nil
    end

    def handle_request
      
      @document_path = resolve

      # auth logic for 401 & 403 responses
      auth = WebServer::Auth::Browser.new(@document_path, @conf.access_file_name, @conf.document_root)
      if auth.protected?
        if @request.headers['AUTHORIZATION'] != nil
          if !auth.authorized?(@request.headers['AUTHORIZATION'])
            return handle_request_forbidden
          end
        else
          return handle_request_unauthorized(auth)
        end
      end

      if @request.http_method == "GET"
        handle_request_get
      
      elsif @request.http_method == "HEAD"
        handle_request_head
      
      elsif @request.http_method == "PUT"
        handle_request_put
      
      elsif @request.http_method == "DELETE"
        handle_request_delete
      
      elsif @request.http_method == "POST"
        handle_request_post
      
      else
        handle_response_bad_request
      end
    end  

    def handle_request_forbidden
      response_forbidden_object = Response::Factory.create_forbidden(self)
      response_forbidden_object.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
      response_forbidden_object.set_headers(Response.default_headers)
      response_forbidden_object
    end

    def handle_request_unauthorized(auth)
      response_unauthorized_object = Response::Factory.create_unauthorized(self)
      response_unauthorized_object.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
      response_unauthorized_object.set_headers(Response.default_headers, auth)
      response_unauthorized_object
    end
    
    def handle_request_get  
      if File.exist?(@document_path)
        handle_response_ok
      else
        handle_response_not_found
      end 
    end


    def handle_request_head
      if File.exist?(@document_path)
        handle_response_ok
      else
        handle_response_not_found
      end 

    end

    def handle_request_put
      dirname = File.dirname(@document_path)

      if !File.exists?(dirname)
        FileUtils.mkdir dirname
        File.open(@document_path, 'w') {|file_content| file_content.write(@request.body)}
      else 
        File.open(@document_path, 'w') {|file_content| file_content.write(@request.body)}

      end
      handle_response_successfully_created

    end

    def handle_request_delete
      if File.exist?(@document_path)
        File.delete(@document_path)
        handle_response_successfully_deleted
      else
        handle_response_successfully_deleted
      end

    end

    def handle_request_post

      if File.exist?(@document_path)
        handle_response_ok
      else
        handle_response_not_found
      end 
    end

    def handle_response_ok
      
        if(!script_aliased?)
          @response_body = (File.open(@document_path, 'r')).read
        else
          params_array = @request.params.to_a
          array1 = [ENV, @document_path]
          params_array.each do |param| array1.push(param)
                            end
          @response_body = IO.popen(array1).read
        end
      
      response_ok_object = Response::Factory.create_ok(self)
      response_ok_object.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
      response_ok_object.set_headers(Response.default_headers)
      response_ok_object
    end

    def handle_response_successfully_created
      
      response_successfully_created_object = Response::Factory.create_successfully_created(self)
      response_successfully_created_object.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
      response_successfully_created_object.set_headers(Response.default_headers)
      response_successfully_created_object
    end

    def handle_response_successfully_deleted
      
      response_successfully_deleted_object = Response::Factory.create_successfully_deleted(self)
      response_successfully_deleted_object.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
      response_successfully_deleted_object.set_headers(Response.default_headers)
      response_successfully_deleted_object
    end

    def handle_response_bad_request

      response_bad_request_object = Response::Factory.bad_request(self)
      response_bad_request_object.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
      response_bad_request_object.set_headers(Response.default_headers)
      response_bad_request_object

    end

    def handle_response_not_found

      response_not_found_object = Response::Factory.not_found(self)
      response_not_found_object.set_status_line(Response::DEFAULT_HTTP_VERSION, Response::RESPONSE_CODES)
      response_not_found_object.set_headers(Response.default_headers)
      response_not_found_object

    end   

    def resolve

      if (aliased?)
        uri = resolve_aliased_path
      elsif (script_aliased?)
        uri = resolve_script_aliased_path
      else
        uri = "#{@conf.document_root}#{@request.uri.sub("/","")}"
      end
      resolve_dir_path(uri)
    end

    def resolve_aliased_path

      aliased_path = @conf.alias_path(@this_alias)
      base_uri = @request.uri
      base_uri.sub! @this_alias, aliased_path #replace this_alias with aliased_path
      base_uri
    end

    def resolve_script_aliased_path
      script_aliased_path = @conf.script_alias_path(@this_script_alias)
      base_uri = String.new(@request.uri)
      base_uri.sub! @this_script_alias, script_aliased_path #replace this_script_alias with script_aliased_path
      base_uri
    end

    def resolve_dir_path(path)
      resolved_path = path
      if File.directory?(resolved_path)
          if !resolved_path.end_with?("/")
            resolved_path += "/"
          end
          resolved_path += "#{@conf.directory_index}"
      end
      resolved_path
    end

    def script_aliased?
      is_script_aliased = false
      
      for script_alias in @conf.script_aliases
        if (@request.uri.start_with?(script_alias))
          is_script_aliased = true
          @this_script_alias = script_alias
          break
        end
      end
      is_script_aliased
    end

    def aliased?
      is_aliased = false
      for _alias in @conf.aliases
        if (@request.uri.start_with?(_alias))
          is_aliased = true
          @this_alias = _alias
          break
        end
      end
      is_aliased
    end

    #def protected?
    #  is_protected = false
    #  #TODO: implement this
    #  is_protected
    #end

  end
end
