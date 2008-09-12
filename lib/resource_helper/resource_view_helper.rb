module ResourceHelper
  module ResourceViewHelper

    # very useful for proper form functions.
    # when calling an ActiveResource URL from a "regular" UI, you would normally get the result of a controller's method
    # from the ActiveResource _server_.  For example, if on the AR server you have a typical create method
    # def create
    #   @foo = Foo.create(params[:foo])
    #   respond_to do |format|
    #     format.html
    #     format.xml { render :nothing => true. :status => :created }
    #   end
    # end
    # 
    # you would get a blank screen on your UI front end.
    # using this method, in conjunction with the the callback_or_render resource_helper method, you get a callback every time
    # use in for like this
    # <form>
    #  index_callback_tag(Foo)
    # </form>
    # outputs something like <input type="hidden" name="callback" value="http://front-end-ui.example.com/foos"
    def index_callback_tag(mod)
      hidden_field_tag(:callback, instance_eval("#{mod.to_s.tableize}_url"))
    end
  end
end