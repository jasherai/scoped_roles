class <%= role_model.camelize %> < ActiveRecord::Base
  belongs_to :<%= role_scope.tableize.singularize %>
  has_many :<%= role_model.tableize + "_" %>assignments
  has_many :<%= user_model.tableize %>, :through => :<%= role_model.tableize + "_" %>assignments
end
