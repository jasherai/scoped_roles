class <%= "Assignment" %> < ActiveRecord::Base
  belongs_to :<%= role_model.tableize.singularize %>
  belongs_to :<%= user_model.tableize.singularize %>
  validates_uniqueness_of :<%= role_model.tableize.singularize %>_id, scope: :<%= user_model.tableize.singularize %>_id
end
