require "scoped_roles/engine"
#require 'active_support/dependencies'

module ScopedRoles
  mattr_accessor :role_model
  @@role_model = "Role"

  mattr_accessor :user_model
  @@user_model = "User"

  # set the scope for the role model
  mattr_accessor :role_scope
  @@role_scope = nil

  # set the scope for the user model
  mattr_accessor :user_scope
  @@user_scope = nil

  # Store all activated modules here
  ALL = []

  # Default configuration method for scoped_roles
  def self.configure
    yield self
  end

  def self.add_module(module_name, options = {})
    ALL << module_name
    options.assert_valid_keys(:model)

    if model = options[:model]
      path = (options[:model] == true ? "scoped_roles/models/#{module_name}" : options[:model])
      camelized = ActiveSupport::Inflector.camelize(module_name.to_s)
      ScopedRoles::Models.send(:autoload, camelized.to_sym, path)
    end
  end
end

require 'scoped_roles/models'
require 'scoped_roles/modules'
