module ActiveResource
  module CoreExtensions
    
    # Class Methods
    class <<self
      
			def all
			  find(:all)
			end

			def first
			  find(:first)
			end

      # Generate a blank resource with the fields filled in to nil or default values (See Also ApplicationController::new) ?
      def generate
        instantiate_record(connection.get(self.plural_url_without_format.to_s + "/new"))
      end
      
      # Returns a URI object to the resource collection, useful in forms, for example
      # form_for :foo, @foo, Foo.plural_url.to_s, :method => :post
      # POSTS to http://host.com/foos
      def plural_url(params=nil, escape=true)
        tmp = site.dup
        unless params.blank?
          query = ''
          params.each_pair do |k,v|
            if escape
              query << CGI.escape("#{k}=#{v}&")
            else
              query << "#{k}=#{v}"
            end
          end
        end
        tmp.path = collection_path
        tmp.query = query
        return tmp
      end
      
      # In some case this can be useful as ActiveResource generated URLs from other methods witll append .xml
      def plural_url_without_format
        self.plural_url.to_s[0..-5]
      end
      
      # Returns a URI object to a sinle resource, useful in forms, for example
      # form_for :foo, @foo, Foo.singular_url(@foo.id).to_s, :method => :post
      # POSTS to http://host.com/foos
      # TODO: take object and use to_param
      def singular_url(ident, params=nil, escape=true)
        tmp = site.dup
        unless params.blank?
          query = ''
          params.each_pair do |k,v|
            if escape
              query << CGI.escape("#{k}=#{v}&")
            else
              query << "#{k}=#{v}"
            end
          end
        end 
        tmp.path = element_path(ident)
        tmp.query = query
        return tmp
      end
      
      # Provides an ActiveRecord-like class count method, used in conjunction with ApplicationController::count
      # Example: Foo.count -> 2
      def count(args={})
        # args.symbolize_keys!
        params = {}
        params[:conditions] = args[:conditions]  || {}
        params[:order]      = args[:order]       || {}
        params[:group]      = args[:group]       || {}
        self.get(:count, params)
      end
    end
    
    # Instance Methods
    # return the single URI object to this instance
    # convenience method, just wraps to class
    # form_for :foo, @foo, @foo.singular_url.to_s, :method => :post
    # POSTS to http://host.com/foos
    # TODO: take object and use to_param
    def singular_url(params=nil, escape=true)
      self.class.singular_url(self.to_param,params,escape)
    end
    
    # When using an association with ActiveResource, a nil association raises an error
    # Example: 
    # @foo.bar -> NoSuchMethodError: <#foo blah blah>#bar
    # with this alias you get a blank object instead
    # @foo.bar -> # a blank bar object
    def method_missing_with_recover_nil_association(method, *args, &block)
      # check if the string contains the name of a valid active resource model
      begin
        unless method.to_s.camelize.constantize.included_modules.include? ActiveResource::CustomMethods
          return method_missing_without_recover_nil_association(method, *args, &block) 
        end
      rescue NameError
        return method_missing_without_recover_nil_association(method, *args, &block)
      end
      # now because ActiveResource::Base has a method missing already, have to see if an association 
      # data is already available
      if respond_to? method
        return attributes[method.to_s]
      else
        return method.to_s.camelize.constantize.generate
      end
    end
    alias_method_chain :method_missing, :recover_nil_association
    
  end
end
