module ScopedRoles

  def self.role_scope
    @@role_scope.constantize
  end

  def self.role_model
    @@role_model.constantize
  end

  def self.role_model=(role_model)
    @@role_model = role_model.camelize
  end

  def self.role_scope=(role_scope)
    @@role_scope = role_scope.camelize
  end

  module Models
    module RolesThroughJoin
      extend ActiveSupport::Concern

      included do
        class_eval do
          self.send :has_many, :assignments #, class_name: 'ScopedRoles::RolesThroughJoins'
          self.send :has_many, :"#{ScopedRoles.role_model.name.downcase.pluralize}", through: :assignments
        end
      end

      def self.required_fields(klass)
        [] + klass.user_scope + klass.role_scope
      end

      def scoped_role
        logger.info "GRANT_ROLE: @ #{@scoped_role} #{ScopedRoles.role_scope} B"
        #@scoped_role ||= ScopedRoles.role_model.by_scope
          # send(:"find_by_\#{ScopedRoles.role_scope.name.downcase}_name(#{Thread.current[:role_scope]})") if Thread.current[:role_scope]
        # @scoped_role ||= ScopedRoles.role_model
        logger.info "GRANT_ROLE: @#{@scoped_role} #{ScopedRoles.role_scope} E"
        @scoped_role
      end
      def by_scope
        current_scope = ScopedRoles.role_scope.current
        Logger.info current_scope
        where("#{ScopedRoles.role_scope}.id = ?", ScopedRoles.role_scope.current.id)
      end

      def grant_role(role_name)
        logger.info "GRANT_ROLE:: #{scoped_role}"
        role = ScopedRoles.role_model.find_or_create_by_name_and_site_id(role_name, ScopedRoles.role_scope.current.id)
        self.roles << role
      end

      def has_role?(role_name)
        logger.warn "#{self} - #{role_name}"
        self.roles.where("roles.name = ?", role_name).size > 0
      end

      #def grant_role
        #"TODO:grant_role"
      #end

      #def grant_role
        #"TODO:grant_role"
      #end

      #def grant_role
        #"TODO:grant_role"
      #end

      module RoleScope
        module Associations
          extend ActiveSupport::Concern
          included do
            self.send :has_many, :roles
            self.send :instance_eval, "
              def self.current
                Thread.current[:role_scope]
              end
              def self.current=(role_scope)
                Thread.current[:role_scope] = role_scope
              end
            "
          end
        end
      end
      # Add association to the role_scope model (Site)
      ScopedRoles.role_scope.class_eval do |klass|
          #TODO: use role_model here maybe by passing class_name or passing a variable first
        klass.send(:include, ScopedRoles::Models::RolesThroughJoin::RoleScope::Associations)
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
