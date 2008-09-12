module ResourceHelper
  require 'resource_helper/active_resource_extensions'
  require 'resource_helper/action_controller_extensions'
  require 'resource_helper/resource_view_helper'
  ActiveResource::Base.send :include, ResourceHelper::ActiveResourceExtensions
end