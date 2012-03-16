module ScopedRoles
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      argument :user_model, type: :string, default: "User"
      argument :role_model, type: :string, default: "Role"
      argument :user_scope, type: :string, default: "Account"
      argument :role_scope, type: :string, default: "Site"
      desc "Create a ScopedRoles Initializer"

      def copy_initializer
        template "initializer.rb", "config/initializers/scoped_roles.rb"
      end

      def copy_migration
        migration_template "joined_roles_migration.rb", "db/migrate/scoped_roles_#{role_model.tableize}_joined_through"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
