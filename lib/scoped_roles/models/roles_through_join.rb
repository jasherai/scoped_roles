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
        logger.debug "ScopedRoles: by_scope - Do we have a current role_scope [#{ScopedRoles.role_scope.name}] set? #{ScopedRoles.role_scope.current}"
        #by_scope = !ScopedRoles.role_scope.current.nil? ? ScopedRoles.role_model.where("#{ScopedRoles.role_scope.name.downcase}_id = ?", ScopedRoles.role_scope.current.id) :
          #ScopedRoles.role_model.scoped
        by_scope = ScopedRoles.role_model.where("#{ScopedRoles.role_scope.name.downcase}_id = ?", ScopedRoles.role_scope.current.try(:id))
        logger.debug "ScopedRoles: by_scope - returning scope [#{by_scope}]"
        by_scope
      end

      def scoped_role
        logger.debug "SCOPED_ROLE: @ #{@scoped_role} #{ScopedRoles.role_scope} B"
        @scoped_role = by_scope
          # send(:"find_by_\#{ScopedRoles.role_scope.name.downcase}_name(#{Thread.current[:role_scope]})") if Thread.current[:role_scope]
        # @scoped_role ||= ScopedRoles.role_model
        logger.debug "SCOPED_ROLE: @#{@scoped_role} #{ScopedRoles.role_scope} E"
       @scoped_role
      end

      def remove_role(role_name)
        logger.info "[ScopedRole][remove_role] - removing role #{role_name.to_s} from #{self.class_name} [#{self.try(:id)} - #{self.try(:name)}]"
        role = ScopedRoles.role_model.find_or_create_by_name_and_site_id(role_name, ScopedRoles.role_scope.current.id)
        return unless self.roles.find(role.id)
        self.roles.delete(role)
      end

      def grant_role(role_name)
        logger.info "[ScopedRole][grant_role] - grant role #{role_name.to_s} from #{self.class_name} [#{self.try(:id)} - #{self.try(:name)}]"
        role = ScopedRoles.role_model.find_or_create_by_name_and_site_id(role_name, ScopedRoles.role_scope.current.id)
        return if self.roles.find(role.id)
        self.roles << role
      end

      #  has_role?
      #
      #  returns [boolean]
      def has_role?(role_name)
        logger.debug "ScopedRoles: has_role? - Check if user: #{self.try(:name)} has_role: #{role_name}"
        # TODO: make the role test case insensitive
        return false unless role = scoped_role.where(name: role_name.to_s).first
        logger.debug "ScopedRoles: has_role? - returned role : #{role.name}"
        logger.debug "ScopedRoles: has_role? User: #{self.try(:name)} has roles: #{self.roles}"
        #self.roles.where(id: role.id).any?
        self.roles.include?(role)
      end

      # Scoped roles for the user
      # return the intersection of a users roles and the roles available on the site.
      # returns Array
      def roles
        roles = super
        roles & scoped_role
      end

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
