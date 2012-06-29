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
          self.send :has_many, :assignments, uniq: true#, class_name: 'ScopedRoles::RolesThroughJoins'
          self.send :has_many, :"#{ScopedRoles.role_model.name.downcase.pluralize}", through: :assignments
        end
      end

      def self.required_fields(klass)
        [] + klass.user_scope + klass.role_scope
      end

      def by_scope
        current_scope = ScopedRoles.role_scope.send(:current)
        #logger.info current_scope.name if current_scope.respond_to?(:name)
        ScopedRoles.role_model.where("#{ScopedRoles.role_scope.name.downcase}_id = ?", ScopedRoles.role_scope.current.id)
        #where("#{ScopedRoles.role_model.name.downcase.pluralize}.#{ScopedRoles.role_scope.name.downcase}_id = ?", current_scope.id)
      end

      def scoped_role
        logger.info "SCOPED_ROLE: @ #{@scoped_role} #{ScopedRoles.role_scope} B"
        @scoped_role ||= by_scope
          # send(:"find_by_\#{ScopedRoles.role_scope.name.downcase}_name(#{Thread.current[:role_scope]})") if Thread.current[:role_scope]
        # @scoped_role ||= ScopedRoles.role_model
        logger.info "SCOPED_ROLE: @#{@scoped_role} #{ScopedRoles.role_scope} E"
       @scoped_role
      end

      def remove_role(role_name)
        logger.info "GRANT_ROLE:: #{scoped_role}"
        role = ScopedRoles.role_model.find_or_create_by_name_and_site_id(role_name, ScopedRoles.role_scope.current.id)
        return unless self.roles.find(role.id)
        self.roles.delete(role)
      end

      def grant_role(role_name)
        logger.info "GRANT_ROLE:: #{scoped_role}"
        role = ScopedRoles.role_model.find_or_create_by_name_and_site_id(role_name, ScopedRoles.role_scope.current.id)
        return if self.roles.find(role.id)
        self.roles << role
      end

      def has_role?(role_name)
        logger.debug "HAS_ROLE: #{self} - #{role_name}"
        #ScopedRoles.role_model.where("roles.name = ? AND #{} = ?", role_name, self).size > 0
        #scoped_role.where("roles.name = ?", role_name).size > 0
        scoped_role.pluck(:name).include?(role_name.to_s)
      end

      #def roles
        ##super
        ##by_scope.joins(ScopedRoles.user_model.tableize)
        #self.by_scope
      #end

      #def grant_role
        #"TODO:grant_role"
      #end

      #def grant_role
        #"TODO:grant_role"
      #end

      module RoleModel
        module InstanceMethods
          extend ActiveSupport::Concern
          included do
            self.send :instance_eval, "
              def self.by_scope
                current_scope = ScopedRoles.role_scope.send(:current)
                logger.info current_scope.name
                self.where(\"#{ScopedRoles.role_model.name.downcase}.#{ScopedRoles.role_scope.name.downcase}_id = ?\", ScopedRoles.role_scope.current.id)
              end
          "
          end
        end
      end
      ScopedRoles.role_model.class_eval do |klass|
          #TODO: use role_model here maybe by passing class_name or passing a variable first
        klass.send(:extend, ScopedRoles::Models::RolesThroughJoin::RoleModel::InstanceMethods)
      end


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
