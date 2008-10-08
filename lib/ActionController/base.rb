# this creates an automatic index method on any controller, which creates a basic xml view for any model
module ActionController
  class Base  
    
    # returns a new Foo, used in conjunction with ActiveResource::Base#generate to easily create new models with 
    # proper fields
    def new
      instance_variable_set("@#{self.class.to_s.downcase}".to_sym,nil)
      klass = self.class.to_s[0..-11].singularize.constantize
      ivar = klass.new(params[klass.to_s.camelize])
      render :xml => ivar.to_xml and return false
    end
    
    # gives a basic XML view for any model
    def index
      instance_variable_set("@#{self.class.to_s.downcase.pluralize}".to_sym,nil)
      # Chnages FooBarController -> FooBar
      klass = self.class.to_s[0..-11].singularize.constantize
      ivar = klass.find(:all, :conditions => params[:conditions], :order => params[:order], :group => params[:group], :limit => params[:limit])
      render :xml => ivar.to_xml and return false
    end

    # used in conjunction with ActiveResource::Base#count to provide ActiveRecord-like count method
    def count
      klass = self.class.to_s[0..-11].singularize.constantize
      count = klass.count(:all, :conditions => params[:conditions], :order => params[:order], :group => params[:group])
      render :xml => count.to_xml(:root => "count") and return false
    end  

    # when protected, becomes a hidden method that cant be called directly as a controller action
    protected
    # used in conjunction with index_callback_tag (on the front end)
    # on the server side, use like:
    # callback and render :nothing => true, :status => 200 and return false
    # -> if the callback tag is present (provided by index_callback_tag) then redirect to the provided url, 
    #    otherwise do the render action
    def callback
      unless params[:callback].blank?
        redirect_to params[:callback] 
        return false
      else
        return true
      end
    end
    
  end
end