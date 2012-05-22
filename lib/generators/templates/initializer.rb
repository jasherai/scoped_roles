# use this file to configure scoped_roles
# you can set many of these in your models
#
ScopedRoles.configure do |config|
  
  # Set your role scope here. all roles queries will be scoped to this model
  config.user_model = "<%= user_model || 'User' %>"

  # Set your role scope here. all roles queries will be scoped to this model
  config.role_model = "<%= role_model || 'Role' %>"

  # Set your user scope here. all user queries will be scoped to this model
  config.user_scope = "<%= user_scope || 'Account' %>"

  # Set your role scope here. all roles queries will be scoped to this model
  config.role_scope = "<%= role_scope || 'Site' %>"
end
