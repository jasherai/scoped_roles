module ScopedRoles
  module Models

    def self.config(mod, *accessors)
      (class << mod; self; end).send :attr_accessor, :available_configs
      mod.available_configs = accessors

      accessors.each do |accessor|
        mod.class_eval <<-METHOD, __FILE__, __LINE__ +1
          def #{accessor}
            if defined?(@#{accessor})
              @#{accessor}
            elsif superclass.respond_to?(:#{accessor})
              superclass.#{accessor}
            else
              ScopedRoles.#{accessor}
            end
         end

         def #{accessor}=(value)
           @#{accessor} = value
         end
       METHOD
     end
    end

    def scope_role(*modules)
      options = modules.extract_options!.dup

      selected_modules = modules.map(&:to_sym).uniq

      scoped_roles_modules_hook! do
        include ScopedRoles::Models::Base
        selected_modules.each do |m|
          mod = ScopedRoles::Models.const_get(m.to_s.classify)

          if mod.const_defined?("ClassMethods")
            class_mod = mod.const_get("ClassMethods")
            extend class_mod

            if class_mod.respond_to?(:available_configs)
              available_configs = class_mod.available_configs
              available_configs.each do |config|
                next unless options.key?(config)
                send(:"#{config}=", options.delete(config))
              end
            end
          end

          include mod
        end

        self.scoped_roles_modules |= selected_modules
        options.each {|key, value| send(:"#{key}=", value) }
      end
    end

    def scoped_roles_modules_hook!
      yield
    end
  end
end

require 'scoped_roles/models/base'

ActiveRecord::Base.extend ScopedRoles::Models
