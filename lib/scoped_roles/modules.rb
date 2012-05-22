require 'active_support/core_ext/object/with_options'

ScopedRoles.with_options :model => true do |d|
  d.add_module :roles_through_join
end
