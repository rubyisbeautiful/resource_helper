module ResourceHelper
  module ActiveResourceExtensions
    
    def self.included(base)
      base.extend ClassMethods
      base.send :define_method, :singular_url, Proc.new{ self.class.singular_url(self.id) }
    end
      
    module ClassMethods
      
  		def all
			  find(:all)
			end

			def first
			  find(:first)
			end
			
			def last
			  find(:all, :params => { :order => "id DESC", :limit => 1 })
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
      end
      
    end
    
  end
end