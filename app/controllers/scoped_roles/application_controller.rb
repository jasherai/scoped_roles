module ScopedRoles
  class ApplicationController < ActionController::Base
    append_before_filter :set_current_role_scope

    def set_current_role_scope
      logger.warn "ScopedRoles - Using default scoped_roles roles_scope finder. You should probably override this."
      @current_roles_scope ||= ScopedRoles.role_scope.send(:"#{role_scope}(current_site)")
    end
  end
end
