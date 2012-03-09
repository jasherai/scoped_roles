Rails.application.routes.draw do

  mount ScopedRoles::Engine => "/scoped_roles"
end
