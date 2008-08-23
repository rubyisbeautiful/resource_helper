module ActiveResource
  class Base
    class <<self
      
      def generate
        instantiate_record(connection.get(self.plural_url_without_format.to_s + "/new"))
      end
      
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
      
      def plural_url_without_format
        self.plural_url.to_s[0..-5]
      end
      
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
      
      def count(args={})
        # args.symbolize_keys!
        params = {}
        params[:conditions] = args[:conditions]  || {}
        params[:order]      = args[:order]       || {}
        params[:group]      = args[:group]       || {}
        self.get(:count, params)
      end
    end
    
    def singular_url(params=nil, escape=true)
      self.class.singular_url(self.to_param,params,escape)
    end
    
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

module ResourceViewHelper
  def index_callback_tag(mod)
    hidden_field_tag(:callback, instance_eval("#{mod.to_s.tableize}_url"))
  end
end