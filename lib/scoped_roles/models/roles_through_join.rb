module ScopedRoles
  module Models
    module RolesThroughJoin
      extend ActiveSupport::Concern

      included do
        has_many :assignments
        #, class_name: 'ScopedRoles::RolesThroughJoins'
        has_many :roles, through: :assignments
        logger.warn "In RolesThroughJoinery"
      end

      def self.required_fields(klass)
        [] + klass.user_scope + klass.role_scope
      end

      def grant_role
        "TODO:grant_role"
      end

      protected
        module ClassMethods

          def roles_list
            "TODO:ROLES"
          end
          ScopedRoles::Models.config(self)
        end
    end

  end
end
