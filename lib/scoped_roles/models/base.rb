module ScopedRoles
  module Models
    module Base
      extend ActiveSupport::Concern
      # Base module. Holds basic methods for handling roles.
      #
      # Can be overridden by role type instantiated.
      #
      #
      # = Options
      #
      #
      included do
        class_attribute :scoped_roles_modules, :instance_writer => false
        self.scoped_roles_modules ||= []
      end

      module ClassMethods
        ScopedRoles::Models.config(self)
      end
    end
  end
end
